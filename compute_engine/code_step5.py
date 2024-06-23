import requests
from flask import Flask, Response, jsonify, request
from datetime import datetime, timedelta
import subprocess
from urllib.parse import quote
import json
import schedule
import time
import threading
import shlex
import urllib.parse
import sys
from google.cloud import storage
import pytz

app = Flask(__name__)

API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# Counter and timestamp for tracking the number of requests and the start of each month
GCE_OUTBOUND_KB_LIMIT = 1048576 # Free tier: 1 GB
storage_client = storage.Client()
BUCKET_NAME = 'market-ai-2024'
FILE_NAME = 'gce_monthly_kb_counters.json'
AVAILABLE_SYMBOL = ['SPY', 'QQQ', 'USO', 'GLD', 'SLV', 'IWM', 'XLK', 'AAPL']

def return_jsonify(json_data, response_code, blob, current_month, gce_monthly_kb_counters, kb):
    # Check if it's a new month and reset the counter if needed
    if current_month not in gce_monthly_kb_counters:
        gce_monthly_kb_counters[current_month] = 0
    # Increment the request counter and update the dictionary
    gce_monthly_kb_counters[current_month] += kb
    # Update the JSON file in Google Cloud Storage
    try:
        if blob.exists():
            blob.delete()  # Delete existing blob
        blob.upload_from_string(json.dumps(gce_monthly_kb_counters), content_type='application/json', timeout=15)
    except:
        print('Handling gce_monthly_kb_counters timed out')
        return {'error': 'Handling gce_monthly_kb_counters timed out'}, 504
    return jsonify(json_data), response_code

def return_string(string, response_code, blob, current_month, gce_monthly_kb_counters, kb):
    # Check if it's a new month and reset the counter if needed
    if current_month not in gce_monthly_kb_counters:
        gce_monthly_kb_counters[current_month] = 0
    # Increment the request counter and update the dictionary
    gce_monthly_kb_counters[current_month] += kb
    # Update the JSON file in Google Cloud Storage
    try:
        if blob.exists():
            blob.delete()  # Delete existing blob
        blob.upload_from_string(json.dumps(gce_monthly_kb_counters), content_type='application/json', timeout=15)
    except:
        print('Handling gce_monthly_kb_counters timed out')
        return 'Handling gce_monthly_kb_counters timed out', 504
    return string, response_code

def print_string(string, blob, current_month, gce_monthly_kb_counters, kb):
    # Check if it's a new month and reset the counter if needed
    if current_month not in gce_monthly_kb_counters:
        gce_monthly_kb_counters[current_month] = 0
    # Increment the request counter and update the dictionary
    gce_monthly_kb_counters[current_month] += kb
    # Update the JSON file in Google Cloud Storage
    try:
        if blob.exists():
            blob.delete()  # Delete existing blob
        blob.upload_from_string(json.dumps(gce_monthly_kb_counters), content_type='application/json', timeout=15)
    except:
        print(({'error': 'Handling gce_monthly_kb_counters timed out'}, 504))
    print(string)

def monthly_usage_limit(current_month):
    bucket = storage_client.bucket(BUCKET_NAME)
    bucket.storage_class = 'STANDARD'
    if bucket.exists() is False:
        print('Creating bucket...')
        storage_client.create_bucket(bucket, location='us-west1')
    blob = bucket.blob(FILE_NAME)
    if blob.exists() is False:
        # If the file doesn't exist or there's an error loading it, initialize with an empty dictionary
        gce_monthly_kb_counters = {}
        return False, blob, gce_monthly_kb_counters, False
    max_retries = 3
    for retry in range(max_retries):
        try:
            json_file = blob.download_as_text()
            break
        except Exception as e:
            if retry < max_retries - 1:
                print(f"Retrying 'json_file = blob.download_as_text()' (attempt {retry + 1})...")
            else:
                return False, blob, gce_monthly_kb_counters, True
    gce_monthly_kb_counters = json.loads(json_file)
    # Check if the KB limit is approached
    if current_month in gce_monthly_kb_counters:
        if gce_monthly_kb_counters[current_month] >= (GCE_OUTBOUND_KB_LIMIT * 0.99):
            return True, blob, gce_monthly_kb_counters, False
    return False, blob, gce_monthly_kb_counters, False

def fetch_and_store_etfs_listing():
    # Monthly usage tracking
    now = datetime.now()
    current_month = now.strftime("%Y-%m")
    limit_exceed, blob, gce_monthly_kb_counters, server_error = monthly_usage_limit(current_month)
    if limit_exceed:
        print_string('Monthly request limit exceeded', blob, current_month, gce_monthly_kb_counters, 1)
        return
    if server_error:
        print_string('Failed to fetch monthly request limit', blob, current_month, gce_monthly_kb_counters, 1)
        return
    # Construct the cURL command with the URL and authorization header
    curl_command = 'curl -X GET "https://us-west1-market-ai-2024.cloudfunctions.net/nyse-etfs-symbol-name" -H "Authorization: bearer $(gcloud auth print-identity-token)"'
    # Execute the cURL command using subprocess
    try:
        response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=1200)
        # Get the output from the command output
        output = response.stdout
        error = response.stderr
        if response.returncode != 0:
            print_string(error, blob, current_month, gce_monthly_kb_counters, 1)
        else:
            print_string(output, blob, current_month, gce_monthly_kb_counters, 1)
    except subprocess.TimeoutExpired:
        # Handle the case when the command exceeds the timeout
        print_string('Function fetch_and_store_etfs_listing execution timed out', blob, current_month, gce_monthly_kb_counters, 1)

# Check if the current time is within the US stock regular trading hours or not
def is_within_regular_trading_hours():
    now = datetime.utcnow()
    us_eastern = pytz.timezone('US/Eastern')
    now_us_eastern = now.astimezone(us_eastern)
    # Extract the hour and minute components
    hour = now_us_eastern.hour
    minute = now_us_eastern.minute
    return (hour == 9 and minute >= 29) or (9 < hour < 16) or (hour == 16 and minute == 0)

def fetch_and_store_one_minute_candlestick_json():
    if not is_within_regular_trading_hours():
        # Monthly usage tracking
        now = datetime.now()
        current_month = now.strftime("%Y-%m")
        limit_exceed, blob, gce_monthly_kb_counters, server_error = monthly_usage_limit(current_month)
        if server_error:
            print_string('Failed to fetch monthly request limit', blob, current_month, gce_monthly_kb_counters, 1)
            return
        url_encoded_apikey = quote(API_KEY)
        url_encoded_granularity = quote('1m')
        url_encoded_timestamp = quote('-1')
        for symbol in AVAILABLE_SYMBOL:
            url_encoded_symbol = quote(symbol)
            curl_command = f'curl -X GET "https://us-west1-market-ai-2024.cloudfunctions.net/minute-interval-data?api_key={url_encoded_apikey}&granularity={url_encoded_granularity}&symbol={url_encoded_symbol}&timestamp={url_encoded_timestamp}" -H "Authorization: bearer $(gcloud auth print-identity-token)"'
            try:
                response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=1800)
                # Get the output from the command output
                output = response.stdout
                error = response.stderr
                if response.returncode != 0:
                    print_string(error, blob, current_month, gce_monthly_kb_counters, 1)
                else:
                    print_string(f'fetch_and_store_one_minute_candlestick_json executed: {output}', blob, current_month, gce_monthly_kb_counters, 1)
            except subprocess.TimeoutExpired:
                # Handle the case when the command exceeds the timeout
                print_string('fetch_and_store_one_minute_candlestick_json execution timed out', blob, current_month, gce_monthly_kb_counters, 1)
        return

@app.route('/', methods=['POST', 'GET'])
def forward_request():
    # Monthly usage tracking
    now = datetime.now()
    current_month = now.strftime("%Y-%m")
    limit_exceed, blob, gce_monthly_kb_counters, server_error = monthly_usage_limit(current_month)
    if server_error:
        return return_jsonify({'error': 'Failed to fetch monthly request limit'}, 503, blob, current_month, gce_monthly_kb_counters, 1)
    if limit_exceed:
        return return_jsonify({'error': 'Monthly request limit exceeded'}, 503, blob, current_month, gce_monthly_kb_counters, 1)
    
    # Incorporate a delay of three seconds 'time.sleep(3)' following each parameter-related erroneous response. 
    # This strategy is designed to deter brute-force attacks by increasing the time cost for each attempted breach.
    if request.method == 'POST':
        api_key = request.form.get('api_key')
        if api_key == API_KEY:
            func_name = request.form.get('func') # Get the 'func' parameter from the URL (the Cloud Function user want to call)
            if func_name == 'subtrend-to-csv-png':
                # Get parameters from the user's GET request
                sub_trend = request.form.get('sub_trend')
                lang = request.form.get('lang')
                min_value = request.form.get('min_value')
                max_value = request.form.get('max_value')
                # Get the identity token from the request
                access_token_command = 'gcloud auth print-access-token'
                try:
                    access_res = subprocess.run(access_token_command, capture_output=True, text=True, shell=True, timeout=15)
                    # Get the output from the command output
                    access_output = access_res.stdout
                    access_error = access_res.stderr
                    if access_res.returncode != 0:
                        return return_jsonify({'error': f'Failed to get access token ({access_error})'}, 400, blob, current_month, gce_monthly_kb_counters, 1)
                    else:
                        # Make a request to the Cloud Functions URL
                        # Construct the cURL command with the URL and authorization header
                        curl_command = ['curl', '--http1.1', '-X', 'POST', 'https://us-west1-market-ai-2024.cloudfunctions.net/subtrend-to-csv-png',
                            '-d', f'sub_trend={shlex.quote(sub_trend)}&lang={lang}&access_token={access_output}&min_value={min_value}&max_value={max_value}', 
                            '-H', 'Authorization: bearer $(gcloud auth print-identity-token)', 
                            '-H', 'Content-Type: application/x-www-form-urlencoded',
                            '-H', 'Accept: application/json']
                        # Execute the cURL command using subprocess
                        try:
                            response = subprocess.Popen(curl_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
                            # Get the output from the command output
                            output, error = response.communicate(timeout=60)
                            if response.returncode != 0:
                                return return_jsonify({'error': str(error)}, 502, blob, current_month, gce_monthly_kb_counters, 1)
                            else:
                                try:
                                    # Try to parse the output as JSON
                                    json_data = json.loads(output)
                                    # Calculate the size in kilobytes
                                    json_string = json.dumps(json_data)
                                    json_string_bytes = json_string.encode('utf-8')
                                    command_string = ' '.join(curl_command)
                                    command_bytes = command_string.encode('utf-8')
                                    size_in_kb = (len(json_string_bytes) + len(command_bytes)) / 1024
                                    # Return the parsed JSON data as a response
                                    return return_jsonify(json_data, 201, blob, current_month, gce_monthly_kb_counters, 1 + size_in_kb)
                                except json.JSONDecodeError:
                                    # Handle the case when the output is not valid JSON
                                    return return_jsonify({'error': 'Invalid JSON response'}, 500, blob, current_month, gce_monthly_kb_counters, 1)
                        except subprocess.TimeoutExpired:
                            # Handle the case when the command exceeds the timeout
                            return return_jsonify({'error': 'subtrend-to-csv-png execution timed out'}, 504, blob, current_month, gce_monthly_kb_counters, 1)
                except subprocess.TimeoutExpired:
                    # Handle the case when the command exceeds the timeout
                    return return_jsonify({'error': 'access_token_command/id_token_command execution timed out'}, 504, blob, current_month, gce_monthly_kb_counters, 1)
            else:
                time.sleep(3)
                return return_jsonify({'error': 'Invalid function name'}, 400, blob, current_month, gce_monthly_kb_counters, 1)
        else:
            time.sleep(3)
            return return_jsonify({'error': 'Invalid API key'}, 401, blob, current_month, gce_monthly_kb_counters, 1)
    elif request.method == 'GET':
        # Vertex AI
        # Get the app access token from the request
        # curl_command = 'gcloud auth application-default print-access-token'
        # try:
        #     response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=30)
        #     # Get the output from the command output
        #     output = response.stdout
        #     error = response.stderr
        #     if response.returncode != 0:
        #         return_jsonify({'error': str(error)}, 500)
        #     else:
        #
        func_name = request.args.get('func') # Get the 'func' parameter from the URL (the Cloud Function user want to call)
        if func_name == 'gemini-pro-news':
            api_key = request.args.get('api_key')
            if api_key == API_KEY:
                # Get parameters from the user's GET request
                symbol_and_name = request.args.get('symbol_and_name')
                # URL-encode the symbol_and_name parameter value
                url_encoded_symbol_and_name = quote(symbol_and_name)
                # Make a request to the Cloud Functions URL
                # Construct the cURL command with the URL and authorization header
                curl_command = f'curl -X GET "https://us-west1-market-ai-2024.cloudfunctions.net/gemini-pro-news?symbol_and_name={url_encoded_symbol_and_name}" -H "Authorization: bearer $(gcloud auth print-identity-token)" -H "Accept: text/plain"'
                # Execute the cURL command using subprocess
                try:
                    response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=60)
                    # Get the output from the command output
                    output = response.stdout
                    error = response.stderr
                    if response.returncode != 0:
                        return return_string(error, 502, blob, current_month, gce_monthly_kb_counters, 1)
                    else:
                        # Get the byte representation of output
                        output_bytes = output.encode(sys.getdefaultencoding())
                        command_string = ' '.join(curl_command)
                        command_bytes = command_string.encode('utf-8')
                        size_in_kb = (len(output_bytes) + len(command_bytes)) / 1024
                        return return_string(output, 201, blob, current_month, gce_monthly_kb_counters, size_in_kb)
                except subprocess.TimeoutExpired:
                    # Handle the case when the command exceeds the timeout
                    return return_string('gemini-pro-news execution timed out', 504, blob, current_month, gce_monthly_kb_counters, 1)
            else:
                time.sleep(3)
                return return_string('Invalid API key', 401, blob, current_month, gce_monthly_kb_counters, 1)
        elif func_name == 'gemini-pro-news-custom':
            api_key = request.args.get('api_key')
            if api_key == API_KEY:
                # Get parameters from the user's GET request
                symbols = request.args.get('symbols')
                question = request.args.get('question')
                # URL-encode the prompt parameter value
                url_encoded_symbols = quote(symbols)
                url_encoded_question = quote(question)
                # Vertex AI
                # url_encoded_output = quote(output)
                #
                # Make a request to the Cloud Functions URL
                # Construct the cURL command with the URL and authorization header
                curl_command = f'curl -X GET "https://us-west1-market-ai-2024.cloudfunctions.net/gemini-pro-news-custom?symbols={url_encoded_symbols}&question={url_encoded_question}" -H "Authorization: bearer $(gcloud auth print-identity-token)" -H "Accept: text/plain"'
                # Vertex AI
                # curl_command = f'curl -X GET "https://us-west1-market-ai-2024.cloudfunctions.net/gemini-pro-news-custom?symbols={url_encoded_symbols}&question={url_encoded_question}&app_access_token={url_encoded_output}" -H "Authorization: bearer $(gcloud auth print-identity-token)" -H "Accept: text/plain"'
                #
                # Execute the cURL command using subprocess
                try:
                    response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=60)
                    # Get the output from the command output
                    output = response.stdout
                    error = response.stderr
                    if response.returncode != 0:
                        return return_string(error, 502, blob, current_month, gce_monthly_kb_counters, 1)
                    else:
                        # Get the byte representation of output
                        output_bytes = output.encode(sys.getdefaultencoding())
                        command_string = ' '.join(curl_command)
                        command_bytes = command_string.encode('utf-8')
                        size_in_kb = (len(output_bytes) + len(command_bytes)) / 1024
                        return return_string(output, 201, blob, current_month, gce_monthly_kb_counters, size_in_kb)
                except subprocess.TimeoutExpired:
                    # Handle the case when the command exceeds the timeout
                    return return_string('gemini-pro-news-custom execution timed out', 504, blob, current_month, gce_monthly_kb_counters, 1)
            else:
                time.sleep(3)
                return return_string('Invalid API key', 401, blob, current_month, gce_monthly_kb_counters, 1)
        elif func_name == 'nyse-etfs-symbol-name':
            BUCKET_NAME = 'market-ai-2024'
            object_name = 'nyse-etfs-symbol-name.json'
            url_encoded_BUCKET_NAME = quote(BUCKET_NAME)
            url_encoded_object_name = quote(object_name)
            # Construct the cURL command with the URL and authorization header
            curl_command = f'curl -X GET "https://storage.googleapis.com/storage/v1/b/{url_encoded_BUCKET_NAME}/o/{url_encoded_object_name}?alt=media" -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Accept: application/json"'
            # Execute the cURL command using subprocess
            try:
                response = subprocess.run(curl_command, capture_output=True, text=True, shell=True, timeout=15)
                # Get the output from the command output
                output = response.stdout
                error = response.stderr
                if response.returncode != 0:
                    return return_jsonify({'error': str(error)}, 502, blob, current_month, gce_monthly_kb_counters, 1)
                else:
                    try:
                        # Try to parse the output as JSON
                        json_data = json.loads(output)
                        # Calculate the size in kilobytes
                        json_string = json.dumps(json_data)
                        json_string_bytes = json_string.encode('utf-8')
                        command_string = ' '.join(curl_command)
                        command_bytes = command_string.encode('utf-8')
                        size_in_kb = (len(json_string_bytes) + len(command_bytes)) / 1024
                        # Return the parsed JSON data as a response
                        return return_jsonify(json_data, 201, blob, current_month, gce_monthly_kb_counters, size_in_kb)
                    except json.JSONDecodeError:
                        # Handle the case when the output is not valid JSON
                        return return_jsonify({'error': 'Invalid JSON response'}, 500, blob, current_month, gce_monthly_kb_counters, 1)
            except subprocess.TimeoutExpired:
                # Handle the case when the command exceeds the timeout
                return return_jsonify({'error': 'nyse-etfs-symbol-name execution timed out'}, 504, blob, current_month, gce_monthly_kb_counters, 1)
        else:
            time.sleep(3)
            return return_jsonify({'error': 'Invalid function name'}, 400, blob, current_month, gce_monthly_kb_counters, 1)
        # Vertex AI
        # except subprocess.TimeoutExpired:
        #     # Handle the case when the command exceeds the timeout
        #     return_jsonify({'error': 'app_access_token_command execution timed out!'}, 504, blob, current_month, gce_monthly_kb_counters, 1)
        #
    else:
        time.sleep(3)
        return return_jsonify({'error': 'Invalid HTTP method'}, 400, blob, current_month, gce_monthly_kb_counters, 1)

if __name__ == '__main__':
    # app.run(host='0.0.0.0', port=80)
    # Start the Flask server in a separate thread
    server_thread = threading.Thread(target=app.run, kwargs={'host': '0.0.0.0', 'port': 80})
    server_thread.start()

    # Execute the initial function
    fetch_and_store_one_minute_candlestick_json()
    fetch_and_store_etfs_listing()
    # Schedule the function to run every specific period
    schedule.every(8).hours.do(fetch_and_store_one_minute_candlestick_json)
    schedule.every(30).days.do(fetch_and_store_etfs_listing)
    # Run the scheduled tasks in the background
    while True:
        schedule.run_pending()
        time.sleep(1)