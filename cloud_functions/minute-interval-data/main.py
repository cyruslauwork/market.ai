import functions_framework
from google.cloud import firestore
from flask import jsonify
import json
from google.api_core.retry import Retry
from google.cloud import storage
from datetime import datetime, timedelta
import requests

api_key = 'A parameter cannot be empty.'
granularity = 'A parameter cannot be empty.'
symbol = 'A parameter cannot be empty.'
timestamp = 'A parameter cannot be empty.'

API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
db = firestore.Client(project='market-ai-2024')
storage_client = storage.Client()
BUCKET_NAME = 'market-ai-2024-minute-data-public_v74-x4b37-v_47'
AVAILABLE_SYMBOL = ['spy', 'qqq', 'uso', 'gld']
last_time_key = 0
new_documents = [] # Initialize an empty list

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
            new_month_collection_ref = update_collection_ref.document('temp').collection(symbol + '_new_month')
            json_data = {}
            bucket = storage_client.bucket(BUCKET_NAME)
            bucket.storage_class = 'STANDARD'
            blob = bucket.blob(symbol + '.json')
            
            def fetch_update_insert_delete_data(timestamp):
                global last_time_key, new_documents # Declare that we are using the global last_time_key, new_documents
                field_name = 'last_time_key'
                print(f'Retrieving last_time_key document in {symbol}_update collection')
                doc_ref = update_collection_ref.document(field_name)
                doc = doc_ref.get()
                if doc.exists:
                    last_time_key = doc.get(field_name)
                    if last_time_key is None:
                        print(f'{field_name} is not set in the document')
                        return jsonify({'error': f'{field_name} is not set in the document'})
                else:
                    print(f'Document does not exist')
                    docs = collection_ref.order_by('time_key', direction=firestore.Query.DESCENDING).limit(1).stream(retry=Retry())
                    doc_ref = update_collection_ref.document(field_name)
                    doc_ref.set({field_name: docs.get('time_key')})
                headers = {
                    'User-Agent': 'Mozilla/5.0'
                }
                url = f'https://query1.finance.yahoo.com/v7/finance/chart/{symbol}?dataGranularity=1m&range=1d'
                response = requests.get(url, headers=headers) # Send a GET request to the URL and fetch the JSON response
                print(f"Fetching JSON response for symbol '{symbol}' from Yahoo Finance")
                # Check if the request was successful (status code 200)
                if response.status_code == 200:
                    # Extract the JSON response
                    response_data = response.json()
                    # Extract the relevant data
                    times = response_data['chart']['result'][0]['timestamp']
                    opens = response_data['chart']['result'][0]['indicators']['quote'][0]['open']
                    highs = response_data['chart']['result'][0]['indicators']['quote'][0]['high']
                    lows = response_data['chart']['result'][0]['indicators']['quote'][0]['low']
                    closes = response_data['chart']['result'][0]['indicators']['quote'][0]['close']
                    volumes = response_data['chart']['result'][0]['indicators']['quote'][0]['volume']
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
                    print(f'Filtering time_key from new document(s) that have not value greater than last_time_key {last_time_key}')
                    for time, open, high, low, close, volume in zip(times, opens, highs, lows, closes, volumes):
                        if time is None or open is None or high is None or low is None or close is None or volume is None:
                            # Handle the case where any of the variables is None
                            continue  # Skip the current iteration and move to the next iteration
                        if time == 'null' or open == 'null' or high == 'null' or low == 'null' or close == 'null' or volume == 'null':
                            continue # Skip the current iteration and move to the next iteration
                        if time <= last_time_key:
                            continue # Skip the current iteration and move to the next iteration
                        # Create a new JSON with the desired columns
                        result_json = {
                            'time_key': time,
                            'open': open,
                            'high': high,
                            'low': low,
                            'close': close,
                            'volume': volume
                        }
                        new_documents.append(result_json) # Append the dictionary to the list
                    if len(new_documents) > 0:
                        # Insert new documents into 'collection_ref' and 'new_month_collection_ref' Firestore collections
                        for document in new_documents:
                            collection_ref.add(document)
                            new_month_collection_ref.add(document)
                        # Update last_time_key document
                        new_last_time_key = max(doc['time_key'] for doc in new_documents)
                        doc_ref = update_collection_ref.document(field_name)
                        doc_ref.set({field_name: new_last_time_key})
                        # Delete documents older than 30 days
                        thirty_days_ago = datetime.fromtimestamp(last_time_key) - timedelta(days=30)
                        thirty_days_ago_timestamp = thirty_days_ago.timestamp()
                        query = new_month_collection_ref.where('time_key', '<', thirty_days_ago_timestamp)
                        docs_to_delete = query.stream(retry=Retry())
                        for doc in docs_to_delete:
                            doc.reference.delete()
                        # Create/update Cloud Storage
                        if timestamp == -1:
                            server_end_json_data = {'content': new_documents}
                            if bucket.exists():
                                if blob.exists():
                                    json_file = blob.download_as_string().decode('utf-8')
                                    collection = json.loads(json_file)
                                    docs = collection.get('content', [])
                                    if docs is None:
                                        docs = []
                                    blob.delete()  # Delete existing blob
                                    print('Object deleted')
                                else:
                                    print(f'Retrieving all documents in {symbol} collection')
                                    docs = collection_ref.order_by('time_key').stream(retry=Retry())
                                    docs = [doc.to_dict() for doc in docs]
                                server_end_json_data['content'].extend(docs)
                                # Convert the result to JSON format
                                json_str = json.dumps(server_end_json_data)
                                try:
                                    blob.upload_from_string(json_str, content_type='application/json')
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
                                server_end_json_data['content'].extend(docs_list)
                                print('Uploading JSON to GCS')
                                # Convert the result to JSON format
                                json_str = json.dumps(server_end_json_data)
                                try:
                                    blob.upload_from_string(json_str, content_type='application/json', timeout=60)
                                    print('Blob uploaded successfully')
                                except:
                                    print('Handling blob timed out')
                                    return
                        else:
                            return
                    else:
                        return
                else:
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
                        print('Uploading JSON to GCS')
                        try:
                            blob.upload_from_string(json.dumps(json_data), content_type='application/json', timeout=60)
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
                    print('Uploading JSON to GCS')
                    try:
                        blob.upload_from_string(json.dumps(json_data), content_type='application/json', timeout=60)
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
                if last_time_key > timestamp:
                    print(f'Retrieving all documents in {symbol}_new_month collection under {symbol}_update collection that have values greater than {timestamp}')
                    docs = new_month_collection_ref.where('time_key', '>', timestamp).order_by('time_key').stream(retry=Retry())
                    docs_list = [doc.to_dict() for doc in docs]
                    print(f'Retrieved required document(s) in {symbol}_new_month collection')
                    timestamp_datetime = datetime.fromtimestamp(timestamp)
                    for doc_data in docs_list:
                        time_key = doc_data.get('time_key')
                        time_key_datetime = datetime.fromtimestamp(time_key)
                        if time_key_datetime > timestamp_datetime + timedelta(days=30):
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