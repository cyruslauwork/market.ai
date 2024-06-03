from google.cloud import firestore
from google.cloud import storage
import json

db = firestore.Client(project='market-ai-2024')
storage_client = storage.Client()

BUCKET_NAME = 'market-ai-2024'
FILE_NAME_WITH_EXTENSION = ['spy.json', 'qqq.json', 'uso.json', 'gld.json']
bucket = storage_client.bucket(BUCKET_NAME)

# 1. Upload json files to Cloud Storage manually
# Run the following command in the terminal on GCE:
# sudo python3 firestore_init_gce.py

# 2. 
# Function to upload JSON data using batch writes
def upload_json_to_firestore(collection_ref, json_data):
    batch = db.batch()
    batch_size = 1000  # Firestore batch limit is 500
    count = 0
    for row in json_data:
        doc_ref = collection_ref.document()
        batch.set(doc_ref, row)
        count += 1
        # Commit the batch every 500 operations
        if count % batch_size == 0:
            batch.commit()
            batch = db.batch()
    # Commit any remaining operations in the final batch
    if count % batch_size != 0:
        batch.commit()
# Upload JSON files as documents
for file_name_with_extension in FILE_NAME_WITH_EXTENSION:
    collection_name = file_name_with_extension[:-5]  # Remove the '.json' extension from the file name
    collection_ref = db.collection(collection_name)
    print(f'Retrieving JSON file from {file_name_with_extension}')
    blob = bucket.blob(file_name)
    json_file = blob.download_as_text()
    print(f'Retrieved JSON file from {file_name_with_extension}')
    try:
        print(f'Loading JSON file from {file_name_with_extension}')
        json_data = json.loads(json_file)
        print(f'Loaded JSON file from {file_name_with_extension}')
    except json.JSONDecodeError:
        # Handle the case when the JSON data is invalid
        print(json.JSONDecodeError)
        break
    try:
        print(f'Inserting JSON data into collection: {collection_name}')
        upload_json_to_firestore(collection_ref, json_data)
        print(f'Inserted JSON data into collection: {collection_name}')
    except Exception as e:
        # Handle other exceptions
        print(e)
        break
print('Upload has finished')

# 3. Read, retrieve, and check JSON files
# for file_name_with_extension in FILE_NAME_WITH_EXTENSION:
#     collection_name = file_name_with_extension[:-5]  # Remove the '.json' extension from the file name
#     collection_ref = db.collection(collection_name)
#     if collection_ref.get():
#         print(f'Collection {collection_name} exists')
#     else:
#         print(f'Collection {collection_name} does not exist')

# If "Killed" appears, it means that the memory usage is too large and you should consider using smaller files