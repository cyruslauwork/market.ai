import decimal
from google.cloud import firestore
from google.api_core.retry import Retry
from google.api_core.exceptions import DeadlineExceeded

db = firestore.Client(project='market-ai-2024')
AVAILABLE_SYMBOL = ['spy', 'qqq', 'uso', 'gld']
BATCH_SIZE = 1000  # Firestore batch limit
PAGE_SIZE = 500  # Number of documents to fetch per page

# 1. 
# Cloud SDK gcloud CLI Installation https://cloud.google.com/sdk/docs/install
# ADC Credential Setting https://cloud.google.com/docs/authentication/provide-credentials-adc#local-dev
# Run the following commands in the terminal locally:
# sudo pip3 install google-cloud-firestore
# sudo pip3 install google-api-core
# sudo pip3 install chardet
# sudo python3 round_all_existing_data_from_gcs_and_firestore.py

# 2.
# Round all existing data from Firestore
def round_to_4_decimal_places(value):
    """Round a number to 4 decimal places."""
    decimal_value = decimal.Decimal(value)
    if decimal_value.as_tuple().exponent < -4:
        return float(decimal_value.quantize(decimal.Decimal('0.0001')))
    return value
# print(round_to_4_decimal_places(1.000123456))
# print(round_to_4_decimal_places(1.00012))
# print(round_to_4_decimal_places(1.0001))
# print(round_to_4_decimal_places(1.007))
# print(round_to_4_decimal_places(1.07))
# print(round_to_4_decimal_places(1.7))

def update_document_fields(doc_ref, data):
    """Update the document fields with rounded values."""
    updated_data = {}
    for field in ['close', 'open', 'high', 'low']:
        if field in data:
            rounded_value = round_to_4_decimal_places(data[field])
            if rounded_value != data[field]:
                updated_data[field] = rounded_value
    if updated_data:
        doc_ref.update(updated_data)

def collection_to_be_rounded(collection_ref):
    last_doc = None
    while True:
        query = collection_ref.limit(PAGE_SIZE)
        if last_doc:
            query = query.start_after(last_doc)

        docs = query.stream(retry=Retry())
        batch = db.batch()
        count = 0
        docs_list = list(docs)

        if not docs_list:
            break

        for doc in docs_list:
            doc_ref = doc.reference
            data = doc.to_dict()
            update_document_fields(doc_ref, data)
            count += 1

            if count % BATCH_SIZE == 0:
                batch.commit()
                batch = db.batch()

        if count % BATCH_SIZE != 0:
            batch.commit()

        last_doc = docs_list[-1]

def round_values_in_collection():
    for symbol in AVAILABLE_SYMBOL:
        print(f'Processing {symbol} collections')
        collection_ref = db.collection(symbol)
        update_collection_ref = db.collection(symbol + '_update')
        new_month_collection_ref = update_collection_ref.document('temp').collection(symbol + '_new_month')
        try:
            collection_to_be_rounded(collection_ref)
            collection_to_be_rounded(new_month_collection_ref)
            print(f'All {symbol} collections have updated')
        except DeadlineExceeded as e:
            print(f'DeadlineExceeded error occurred: {e}')
        except Exception as e:
            print(f'An error occurred: {e}')

if __name__ == "__main__":
    round_values_in_collection()