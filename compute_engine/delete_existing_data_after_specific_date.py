import decimal
from google.cloud import firestore
from google.api_core.retry import Retry
from google.api_core.exceptions import DeadlineExceeded

db = firestore.Client(project='market-ai-2024')
# AVAILABLE_SYMBOL = ['spy', 'qqq', 'uso', 'gld']
AVAILABLE_SYMBOL = ['qqq']
BATCH_SIZE = 1000  # Firestore batch limit
PAGE_SIZE = 500  # Number of documents to fetch per page

# 1.
# Cloud SDK gcloud CLI Installation https://cloud.google.com/sdk/docs/install
# ADC Credential Setting https://cloud.google.com/docs/authentication/provide-credentials-adc#local-dev
# Run the following commands in the terminal locally:
# sudo pip3 install google-cloud-firestore
# sudo pip3 install google-api-core
# sudo pip3 install chardet
# sudo python3 delete_existing_data_after_specific_date.py

# 2.
def delete_documents_based_on_time_key(collection_ref, time_key_threshold):
    last_doc = None
    while True:
        query = collection_ref.where('time_key', '>', time_key_threshold).limit(PAGE_SIZE)
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
            batch.delete(doc_ref)
            count += 1

            if count % BATCH_SIZE == 0:
                batch.commit()
                batch = db.batch()

        if count % BATCH_SIZE != 0:
            batch.commit()

        last_doc = docs_list[-1]

def delete_all_documents(collection_ref):
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
            batch.delete(doc_ref)
            count += 1

            if count % BATCH_SIZE == 0:
                batch.commit()
                batch = db.batch()

        if count % BATCH_SIZE != 0:
            batch.commit()

        last_doc = docs_list[-1]

def main():
    for symbol in AVAILABLE_SYMBOL:
        print(f'Processing {symbol} collections')
        collection_ref = db.collection(symbol)
        update_collection_ref = db.collection(symbol + '_update')
        new_month_collection_ref = update_collection_ref.document('temp').collection(symbol + '_new_month')
        try:
            delete_documents_based_on_time_key(collection_ref, 1716998400)
            # delete_all_documents(new_month_collection_ref)
            update_collection_ref.document('last_time_key').set({'last_time_key': 1716998400})
            print(f'All {symbol} collections have been updated')
        except DeadlineExceeded as e:
            print(f'DeadlineExceeded error occurred: {e}')
        except Exception as e:
            print(f'An error occurred: {e}')

if __name__ == "__main__":
    main()