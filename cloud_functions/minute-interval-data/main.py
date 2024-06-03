import functions_framework
from google.cloud import firestore
from flask import jsonify
import json
from google.api_core.retry import Retry
from google.cloud import storage

api_key = 'A parameter cannot be empty.'
granularity = 'A parameter cannot be empty.'
symbol = 'A parameter cannot be empty.'
timestamp = 'A parameter cannot be empty.'

API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
db = firestore.Client(project='market-ai-2024')
storage_client = storage.Client()
BUCKET_NAME = 'market-ai-2024-minute-data-public_v74-x4b37-v_47'

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
        else:
            print({'error': timestamp})
            return jsonify({'error': timestamp})
    else:
        print({'error': 'GET method is required'})
        return jsonify({'error': 'GET method is required'})
    
    if api_key != API_KEY:
        print({'error': 'Invalid API key'})
        return jsonify({'error': 'Invalid API key'})

    if granularity == '1m':
        try:
            print(f'Finding {symbol} collection')
            collection_ref = db.collection(symbol)
            json_data = {}
            init = True
            if timestamp == 0:
                print(f'Retrieving all documents in {symbol} collection')
                docs = collection_ref.order_by('time_key').stream(retry=Retry())
            elif timestamp > 0:
                init = False
                print(f'Retrieving all documents in {symbol} collection that have timestamp greater than {timestamp}')
                docs = collection_ref.where('time_key', '>', timestamp).order_by('time_key').stream(retry=Retry())
                docs_list = list(docs)
                if not docs_list:
                    print(f'No document(s) with timestamp greater than {timestamp} was/were found')
                    print(f'Preparing to return JSON')
                    json_data['content'] = []
                    json_data['init'] = init
                    print(json_data)
                    return jsonify(json_data)
            docs_list = [doc.to_dict() for doc in docs]
            print(f'Retrieved required document(s) in {symbol} collection')
            print(f'Preparing to return JSON')
            json_data['content'] = docs_list
            json_data['init'] = init
            # print(json_data)
            if timestamp == 0:
                print('Uploading JSON to GCS')
                bucket = storage_client.bucket(BUCKET_NAME)
                bucket.storage_class = 'STANDARD'
                if not bucket.exists():
                    print('Creating bucket...')
                    bucket.create(location='us-west1')
                    bucket.make_public()
                blob = bucket.blob(symbol + '.json') # If needed, add the user ID to the JSON file name to avoid incorrect "init" boolean values ​​when queuing
                try:
                    if blob.exists():
                        blob.delete()  # Delete existing blob
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
                # Assume the file size does not exceed the following limits:
                # - 100MB (compressed) for sources
                # - 500MB (uncompressed) for sources plus modules
                # - 10MB for streaming responses
                # - 32MB for non-streaming responses
                print('Returning JSON')
                return jsonify(json_data)
        except Exception as e:
            print({'error': f'{e}'})
            return jsonify({'error': f'{e}'})
    else:
        print({'error': 'No specified granularity provided'})
        return jsonify({'error': 'No specified granularity provided'})