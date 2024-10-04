import functions_framework
from google.cloud import firestore
from flask import jsonify
import json
from google.api_core.retry import Retry
from google.cloud import storage
from datetime import datetime, timedelta, timezone
import requests
from retry import retry

api_key = 'A parameter cannot be empty.'
granularity = 'A parameter cannot be empty.'
symbol = 'A parameter cannot be empty.'
timestamp = 'A parameter cannot be empty.'

API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
db = firestore.Client(project='market-ai-2024')
storage_client = storage.Client()
BUCKET_NAME = 'market-ai-2024-minute-data-public_v74-x4b37-v_47'
AVAILABLE_SYMBOL = ['spy', 'qqq', 'uso', 'gld', 'slv', 'iwm', 'xlk', 'aapl', 'ba', 'bac', 'mcd', 'msft', 'nvda', 'gsk', 'tsla', 'amzn']
last_time_key = None
BATCH_SIZE = 390  # Firestore batch limit is 390 operations per batch
last_time_key_field_name = 'last_time_key'

@functions_framework.http
def https(request):
    if request.method == 'GET':
        request_args = request.args
        if request_args and 'api_key' in request_args:
            api_key = str(request_args['api_key'])
        else:
            print({'error': api_key})
            return jsonify({'error': api_key})
        if request_args and 'granularity' in request_args:
            granularity = str(request_args['granularity'])
        else:
            print({'error': granularity})
            return jsonify({'error': granularity})
        if request_args and 'symbol' in request_args:
            symbol = str(request_args['symbol']).lower()
        else:
            print({'error': symbol})
            return jsonify({'error': symbol})
        if request_args and 'timestamp' in request_args:
            timestamp = int(request_args['timestamp'])
            print(timestamp)
        else:
            print({'error': timestamp})
            return jsonify({'error': timestamp})
    else:
        print({'error': 'GET method is required'})
        return jsonify({'error': 'GET method is required'})
    
    if api_key != API_KEY:
        print({'error': 'Invalid API key'})
        return jsonify({'error': 'Invalid API key'})

    if symbol not in AVAILABLE_SYMBOL:
        print({'error': 'Invalid symbol'})
        return jsonify({'error': 'Invalid symbol'})

    if granularity == '1m':
        try:
            print(f'Finding {symbol} collection')
            collection_ref = db.collection(symbol)
            update_collection_ref = db.collection(symbol + '_update')
            new_month_collection_ref = update_collection_ref.document('temp').collection(symbol + '_last_fifteen_days')
            json_data = {}
            bucket = storage_client.bucket(BUCKET_NAME)
            bucket.storage_class = 'STANDARD'
            blob = bucket.blob(symbol + '.json')

            @retry(tries=5, delay=2, backoff=2, exceptions=(Exception,))
            def download_blob_with_retry(blob):
                return blob.download_as_string(timeout=120).decode('utf-8')

            @retry(tries=5, delay=2, backoff=2, exceptions=(Exception,))
            def upload_blob_with_retry(blob, json_str):
                return blob.upload_from_string(json_str, content_type='application/json', timeout=120)

            def add_documents_in_batches(collection_ref, new_documents):
                batch = db.batch()
                count = 0
                for doc in new_documents:
                    doc_ref = collection_ref.document()
                    batch.set(doc_ref, doc)
                    count += 1
                    if count % BATCH_SIZE == 0:
                        batch.commit()
                        batch = db.batch()
                if count % BATCH_SIZE != 0:
                    batch.commit()

            def delete_fifteen_days_ago_documents_in_batches(collection_ref, fifteen_days_ago_timestamp):
                query = collection_ref.where('time_key', '<', fifteen_days_ago_timestamp)
                docs_to_delete = query.stream(retry=Retry())
                batch = db.batch()
                count = 0
                for doc in docs_to_delete:
                    batch.delete(doc.reference)
                    count += 1
                    if count % BATCH_SIZE == 0:
                        batch.commit()
                        batch = db.batch()
                if count % BATCH_SIZE != 0:
                    batch.commit()
            
            def fetch_update_insert_delete_data(timestamp):
                # Get update status to avoid duplication
                is_updating = 'is_updating'
                update_queue = 'update_queue'
                update_status = 0
                print(f'Retrieving is_updating document in {symbol}_update collection')
                is_updating_doc_ref = update_collection_ref.document(is_updating)
                doc = is_updating_doc_ref.get()
                if doc.exists:
                    update_status = doc.get(is_updating)
                    if update_status == 1:
                        print(f'Another update is already in progress. Please try again later.')
                        return
                    elif update_status is None:
                        print(f'{is_updating} is not set in the document. Setting...')
                        is_updating_doc_ref.set({is_updating: 1})
                    else:
                        print(f'value {update_status} in is_updating document in {symbol}_update collection retrieved. Updating...')
                        is_updating_doc_ref.update({is_updating: 1})
                else:
                    print(f'Document does not exist. Creating...')
                    is_updating_doc_ref.set({is_updating: 1})
                # Add to queue to check for duplicates later
                update_queue = {}
                timestamp_now = datetime.now(timezone.utc)
                update_queue['created_at'] = timestamp_now
                update_queue_collection_ref = update_collection_ref.document('temp').collection(symbol + '_update_queue')
                update_queue_collection_ref.add(update_queue)
                print(f'Added document to {symbol}_update_queue collection with attribute timestamp created_at: {timestamp_now}')
                # Fetch data from Yahoo Finance API
                global last_time_key # Declare that we are using the global last_time_key
                headers = {
                    'User-Agent': 'Mozilla/5.0'
                }
                if timestamp != -1:
                    # User request
                    url = f'https://query1.finance.yahoo.com/v7/finance/chart/{symbol}?dataGranularity=1m&range=1d'
                else:
                    # Server request
                    url = f'https://query1.finance.yahoo.com/v7/finance/chart/{symbol}?dataGranularity=1m&range=2d'
                response = requests.get(url, headers=headers) # Send a GET request to the URL and fetch the JSON response
                print(f"Fetching JSON response for symbol '{symbol}' from Yahoo Finance")
                # Check if the request was successful (status code 200)
                if response.status_code == 200:
                    print('Parsing JSON response')
                    # Extract the JSON response
                    response_data = response.json()
                    # Extract the relevant data
                    times = response_data['chart']['result'][0].get('timestamp', [])
                    opens = response_data['chart']['result'][0]['indicators']['quote'][0].get('open', [])
                    highs = response_data['chart']['result'][0]['indicators']['quote'][0].get('high', [])
                    lows = response_data['chart']['result'][0]['indicators']['quote'][0].get('low', [])
                    closes = response_data['chart']['result'][0]['indicators']['quote'][0].get('close', [])
                    volumes = response_data['chart']['result'][0]['indicators']['quote'][0].get('volume', [])
                    # Verify that the data
                    if not times or not opens or not highs or not lows or not closes or not volumes:
                        print('Error: No data found')
                        doc_ref = update_collection_ref.document(is_updating)
                        doc_ref.update({is_updating: 0})
                        return
                    elif times == 'null' or opens == 'null' or highs == 'null' or lows == 'null' or closes == 'null' or volumes == 'null':
                        print('Error: Data cannot be null')
                        doc_ref = update_collection_ref.document(is_updating)
                        doc_ref.update({is_updating: 0})
                        return
                    elif times is None or opens is None or highs is None or lows is None or closes is None or volumes is None:
                        print('Error: Data cannot be None')
                        doc_ref = update_collection_ref.document(is_updating)
                        doc_ref.update({is_updating: 0})
                        return
                    else:
                        # Additional check if times is a list and its length is at least 3
                        if not isinstance(times, list):
                            print("Error: 'times' is not a list")
                            doc_ref = update_collection_ref.document(is_updating)
                            doc_ref.update({is_updating: 0})
                            return
                        elif len(times) < 3:
                            print("Error: 'times' list has less than 3 elements")
                            doc_ref = update_collection_ref.document(is_updating)
                            doc_ref.update({is_updating: 0})
                            return
                        else:
                            print('All data appears to be valid')
                    # Check if the trading time is entered incorrectly by using special signals in Yahoo Finance API JSON response
                    second_last_close_value = closes[-2]
                    if second_last_close_value is None or second_last_close_value == 'null':
                        # Remove the last items that are changing and the null items that being calculated for the last minute
                        times = times[:-2]
                        opens = opens[:-2]
                        highs = highs[:-2]
                        lows = lows[:-2]
                        closes = closes[:-2]
                        volumes = volumes[:-2]
                        print('Due to trading hours, the last 2 items from each list have been removed')
                    # Get last_time_key
                    print(f'Retrieving last_time_key document in {symbol}_update collection')
                    last_time_key_doc_ref = update_collection_ref.document(last_time_key_field_name)
                    doc = last_time_key_doc_ref.get()
                    if doc.exists:
                        last_time_key = doc.get(last_time_key_field_name)
                        if last_time_key is None:
                            print(f'{last_time_key_field_name} is not set in the document')
                            docs = collection_ref.order_by('time_key', direction=firestore.Query.DESCENDING).limit(1).stream(retry=Retry())
                            for doc in docs:
                                last_time_key = doc.get('time_key')
                            if last_time_key is None:
                                print(f'Last document time_key not found in the {symbol} collection')
                                doc_ref = update_collection_ref.document(is_updating)
                                doc_ref.update({is_updating: 0})
                                return
                            last_time_key_doc_ref = update_collection_ref.document(last_time_key_field_name)
                            last_time_key_doc_ref.update({last_time_key_field_name: last_time_key})
                            print(f'Updated value {last_time_key} in last_time_key document in {symbol}_update collection')
                        else:
                            print(f'value {last_time_key} in last_time_key document in {symbol}_update collection retrieved')
                    else:
                        print(f'Document does not exist')
                        docs = collection_ref.order_by('time_key', direction=firestore.Query.DESCENDING).limit(1).stream(retry=Retry())
                        for doc in docs:
                            last_time_key = doc.get('time_key')
                        if last_time_key is None:
                            print(f'Last document time_key not found in the {symbol} collection')
                            doc_ref = update_collection_ref.document(is_updating)
                            doc_ref.update({is_updating: 0})
                            return
                        last_time_key_doc_ref = update_collection_ref.document(last_time_key_field_name)
                        last_time_key_doc_ref.set({last_time_key_field_name: last_time_key})
                        print(f'Added value {last_time_key} in last_time_key document in {symbol}_update collection')
                    print(f'Filtering time_key from new document(s) that have not value greater than last_time_key {last_time_key}')
                    last_time_key = int(last_time_key)
                    new_documents = [] # Initialize an empty list
                    for time, o, high, low, close, volume in zip(times, opens, highs, lows, closes, volumes):
                        if int(time) <= last_time_key:
                            continue # Skip the current iteration and move to the next iteration
                        if time == 'null' or o == 'null' or high == 'null' or low == 'null' or close == 'null' or volume == 'null':
                            continue # Skip the current iteration and move to the next iteration
                        if time is None or o is None or high is None or low is None or close is None or volume is None:
                            # Handle the case where any of the variables is None
                            continue  # Skip the current iteration and move to the next iteration
                        # Convert 'time' to string and check if the last character is not '0'
                        if str(time)[-1] != '0':
                            continue # Skip the current iteration and move to the next iteration
                        trading_periods = response_data['chart']['result'][0]['meta']['tradingPeriods']
                        # Loop through each trading period
                        for period in trading_periods:
                            # Each period is a list, so we need to access the first element
                            end_time = period[0]['end']
                            if time == end_time:
                                continue
                        # Create a new JSON with the desired columns
                        result_json = {
                            'time_key': time,
                            'open': round(o, 4),
                            'high': round(high, 4),
                            'low': round(low, 4),
                            'close': round(close, 4),
                            'volume': volume
                        }
                        new_documents.append(result_json) # Append the dictionary to the list
                    if len(new_documents) > 0:
                        # Check if the document is the first in the queue
                        docs = update_queue_collection_ref.order_by('created_at', direction=firestore.Query.ASCENDING).limit(1).stream(retry=Retry()) # Order by timestamp e.g. Jun 15, 2024, 4:21:53.689 PM
                        first_doc = next(docs, None)
                        for doc in docs:
                            first_doc = doc
                            break
                        if first_doc is None:
                            doc_ref = update_collection_ref.document(is_updating)
                            doc_ref.update({is_updating: 0})
                            print('Error: No document in the queue.')
                            return
                        first_doc_created_at = first_doc.get('created_at')
                        if timestamp_now == first_doc_created_at:
                            print('This is the first document in the queue. Continuing the process...')
                        else:
                            print('This is not the first document in the queue. Exiting...')
                            return
                        # Delete documents older than 15 days
                        print(f'Deleting documents older than 15 days from {symbol} collection')
                        fifteen_days_ago = datetime.fromtimestamp(last_time_key) - timedelta(days=15)
                        fifteen_days_ago_timestamp = fifteen_days_ago.timestamp()
                        delete_fifteen_days_ago_documents_in_batches(new_month_collection_ref, fifteen_days_ago_timestamp)
                        # Insert new documents into 'collection_ref' and 'new_month_collection_ref' Firestore collections
                        print(f'Inserting new document(s)')
                        add_documents_in_batches(collection_ref, new_documents)
                        add_documents_in_batches(new_month_collection_ref, new_documents)
                        # Update last_time_key document
                        last_time_key = max(doc['time_key'] for doc in new_documents)
                        print(f'Updating last_time_key document in {symbol}_update collection with value {last_time_key}')
                        doc_ref = update_collection_ref.document(last_time_key_field_name)
                        doc_ref.update({last_time_key_field_name: last_time_key})
                        # Reset queue and update status
                        docs = update_queue_collection_ref.stream(retry=Retry())
                        for doc in docs:
                            doc.reference.delete()
                        doc_ref = update_collection_ref.document(is_updating)
                        doc_ref.set({is_updating: 0})
                        # Create/update Cloud Storage
                        if timestamp == -1 or timestamp == 0: # Request from server (-1) or client with no data (0)
                            backend_json_data = {'content': []}
                            json_file_last_time_key = None
                            if bucket.exists():
                                if blob.exists():
                                    json_file = download_blob_with_retry(blob)
                                    collection = json.loads(json_file)
                                    docs = collection.get('content', [])
                                    json_file_last_time_key = collection.get(last_time_key_field_name, None)
                                    if docs is None or docs == 'null':
                                        docs = []
                                    # blob.delete()  # Delete existing blob
                                    # print('Object deleted')
                                else:
                                    print(f'Retrieving all documents in {symbol} collection')
                                    docs = collection_ref.order_by('time_key').stream(retry=Retry())
                                    docs = [doc.to_dict() for doc in docs]
                                # JSON file is inconsistent with the Firestore records, so insert all the data at once
                                json_new_documents = []
                                if json_file_last_time_key is not None:
                                    for time, o, high, low, close, volume in zip(times, opens, highs, lows, closes, volumes):
                                        if int(time) <= json_file_last_time_key:
                                            continue # Skip the current iteration and move to the next iteration
                                        if time == 'null' or o == 'null' or high == 'null' or low == 'null' or close == 'null' or volume == 'null':
                                            continue # Skip the current iteration and move to the next iteration
                                        if time is None or o is None or high is None or low is None or close is None or volume is None:
                                            # Handle the case where any of the variables is None
                                            continue  # Skip the current iteration and move to the next iteration
                                        # Convert 'time' to string and check if the last character is not '0'
                                        if str(time)[-1] != '0':
                                            continue # Skip the current iteration and move to the next iteration
                                        trading_periods = response_data['chart']['result'][0]['meta']['tradingPeriods']
                                        # Loop through each trading period
                                        for period in trading_periods:
                                            # Each period is a list, so we need to access the first element
                                            end_time = period[0]['end']
                                            if time == end_time:
                                                continue
                                        # Create a new JSON with the desired columns
                                        result_json = {
                                            'time_key': time,
                                            'open': round(o, 4),
                                            'high': round(high, 4),
                                            'low': round(low, 4),
                                            'close': round(close, 4),
                                            'volume': volume
                                        }
                                        json_new_documents.append(result_json) # Append the dictionary to the list
                                    backend_json_data[last_time_key_field_name] = max(doc['time_key'] for doc in json_new_documents)
                                else:
                                    backend_json_data[last_time_key_field_name] = last_time_key
                                backend_json_data['content'] = docs + json_new_documents
                                # Convert the result to JSON format
                                json_str = json.dumps(backend_json_data)
                                try:
                                    upload_blob_with_retry(blob, json_str)
                                    print('Object uploaded successfully')
                                except Exception as e:
                                    print(f'Create object timeout {e}')
                                    return
                            else:
                                print('Creating bucket...')
                                bucket.create(location='us-west1')
                                bucket.make_public()
                                policy = bucket.get_iam_policy()
                                policy['roles/storage.objectViewer'].add('allUsers')
                                policy['roles/storage.legacyObjectReader'].add('allUsers')
                                bucket.set_iam_policy(policy)
                                print(f'Retrieving all documents in {symbol} collection')
                                docs = collection_ref.order_by('time_key').stream(retry=Retry())
                                docs_list = [doc.to_dict() for doc in docs]
                                print(f'Retrieved required document(s) in {symbol} collection')
                                print(f'Preparing to return JSON')
                                backend_json_data['content'] = docs_list
                                backend_json_data[last_time_key_field_name] = last_time_key
                                print('Uploading JSON to GCS')
                                # Convert the result to JSON format
                                json_str = json.dumps(backend_json_data)
                                try:
                                    upload_blob_with_retry(blob, json_str)
                                    print('Blob uploaded successfully')
                                except:
                                    print('Handling blob timed out')
                                    return
                        else:
                            return
                    else:
                        docs = update_queue_collection_ref.stream(retry=Retry())
                        for doc in docs:
                            doc.reference.delete()
                        doc_ref = update_collection_ref.document(is_updating)
                        doc_ref.update({is_updating: 0})
                        print('No new data to update')
                        return
                else:
                    docs = update_queue_collection_ref.stream(retry=Retry())
                    for doc in docs:
                        doc.reference.delete()
                    doc_ref = update_collection_ref.document(is_updating)
                    doc_ref.update({is_updating: 0})
                    print({'error': f'Error fetching data from Yahoo Finance: {response.status_code} {response.reason}'})
                    return
            fetch_update_insert_delete_data(timestamp)

            # About the Firestore reading cost, ref to https://cloud.google.com/skus?hl=en&filter=C91A-FAC3-A285&currency=USD
            if timestamp == 0:
                if bucket.exists():
                    if blob.exists():
                        print('Bucket already exists')
                        # Get public URL of the blob
                        public_url = blob.public_url
                        print('Returning public URL')
                        return jsonify({'public_url': public_url})
                    else:
                        print(f'Retrieving all documents in {symbol} collection')
                        docs = collection_ref.order_by('time_key').stream(retry=Retry())
                        docs_list = [doc.to_dict() for doc in docs]
                        print(f'Retrieved required document(s) in {symbol} collection')
                        print(f'Preparing to return JSON')
                        json_data['content'] = docs_list
                        backend_json_data[last_time_key_field_name] = max(doc['time_key'] for doc in docs_list)
                        print('Uploading JSON to GCS')
                        json_str = json.dumps(json_data)
                        try:
                            upload_blob_with_retry(blob, json_str)
                            print('Blob uploaded successfully')
                        except:
                            print({'error': 'Handling blob timed out'})
                            return jsonify({'error': 'Handling blob timed out'})
                        # Get public URL of the uploaded blob
                        public_url = blob.public_url
                        print('Returning public URL')
                        return jsonify({'public_url': public_url})
                else:
                    print('Creating bucket...')
                    bucket.create(location='us-west1')
                    bucket.make_public()
                    policy = bucket.get_iam_policy()
                    policy['roles/storage.objectViewer'].add('allUsers')
                    policy['roles/storage.legacyObjectReader'].add('allUsers')
                    bucket.set_iam_policy(policy)
                    print(f'Retrieving all documents in {symbol} collection')
                    docs = collection_ref.order_by('time_key').stream(retry=Retry())
                    docs_list = [doc.to_dict() for doc in docs]
                    print(f'Retrieved required document(s) in {symbol} collection')
                    print(f'Preparing to return JSON')
                    json_data['content'] = docs_list
                    backend_json_data[last_time_key_field_name] = max(doc['time_key'] for doc in docs_list)
                    print('Uploading JSON to GCS')
                    json_str = json.dumps(json_data)
                    try:
                        upload_blob_with_retry(blob, json_str)
                        print('Blob uploaded successfully')
                    except:
                        print({'error': 'Handling blob timed out'})
                        return jsonify({'error': 'Handling blob timed out'})
                    # Get public URL of the uploaded blob
                    public_url = blob.public_url
                    print('Returning public URL')
                    return jsonify({'public_url': public_url})
            elif timestamp > 0:
                # print(f'Retrieving all documents in {symbol} collection that have values greater than {timestamp}')
                # docs = collection_ref.where('time_key', '>', timestamp).order_by('time_key').stream(retry=Retry())
                # docs_list = list(docs)
                # if not docs_list:
                #     print(f'No document(s) with timestamp greater than {timestamp} was/were found')
                #     print(f'Preparing to return JSON')
                #     json_data['content'] = []
                #     print(json_data)
                #     return jsonify(json_data)
                if last_time_key is None:
                    print({'error': 'last_time_key cannot be None'})
                    return jsonify({'error': f'last_time_key cannot be None. It is suggested to reset is_updating document to 0 and clear temp/{symbol}_update_queue in {symbol}_update collection'})
                if last_time_key > timestamp:
                    print(f'Retrieving all documents in {symbol}_last_fifteen_days collection under {symbol}_update collection that have values greater than {timestamp}')
                    docs = new_month_collection_ref.where('time_key', '>', timestamp).order_by('time_key', direction=firestore.Query.DESCENDING).stream(retry=Retry())
                    docs_list = [doc.to_dict() for doc in docs]
                    print(f'Retrieved required document(s) in {symbol}_last_fifteen_days collection')
                    timestamp_datetime = datetime.fromtimestamp(timestamp)
                    for doc in docs_list[:1]: # To loop over only the first item (largest timestamp)
                        time_key = doc.get('time_key')
                        time_key_datetime = datetime.fromtimestamp(time_key)
                        if time_key_datetime > timestamp_datetime + timedelta(days=15):
                            print('Outdated user data detected, please reinstall the app. Returning message')
                            return jsonify({'message': 'User data outdated'})
                    print(f'Preparing to return JSON')
                    json_data['content'] = docs_list
                else:
                    print('No update required. Returning message')
                    return jsonify({'message': 'No update required'})
                # Assume the file size does not exceed the following limits:
                # - 100MB (compressed) for sources
                # - 500MB (uncompressed) for sources plus modules
                # - 10MB for streaming responses
                # - 32MB for non-streaming responses
                print('Returning JSON')
                return jsonify(json_data)
            else:
                print('Updated minute data in Firestore and Cloud Storage')
                return 'Updated minute data in Firestore and Cloud Storage'
        except Exception as e:
            print({'error': f'{e}'})
            return jsonify({'error': f'{e}'})
    else:
        print({'error': 'No specified granularity provided'})
        return jsonify({'error': 'No specified granularity provided'})