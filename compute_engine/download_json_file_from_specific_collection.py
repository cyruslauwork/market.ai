import json
from google.cloud import firestore
from google.api_core.retry import Retry

def download_collection_to_json(symbol):
    # Initialize Firestore client
    db = firestore.Client(project='market-ai-2024')
    
    # Get reference to the collection
    update_collection_ref = db.collection(symbol + '_update')
    new_month_collection_ref = update_collection_ref.document('temp').collection(symbol + '_new_month')
    
    # Stream documents from the collection
    docs = new_month_collection_ref.stream(retry=Retry())
    
    # Collect data from each document
    documents_data = []
    for doc in docs:
        documents_data.append(doc.to_dict())
    
    # Write collected data to a JSON file
    output_file = f'{symbol}_new_month_collection.json'
    with open(output_file, 'w') as file:
        json.dump(documents_data, file, indent=4)
    
    print(f'Data from {symbol}_new_month_collection_ref has been written to {output_file}')

if __name__ == "__main__":
    symbol = 'qqq'  # Replace with your actual symbol
    download_collection_to_json(symbol)