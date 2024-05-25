import functions_framework

# import google_colab_selenium as gs # For Colab
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import ElementClickInterceptedException
import json
from google.cloud import storage

@functions_framework.http
def https(request):
    url = 'https://www.nyse.com/listings_directory/etf'
    # Instantiate options
    options = Options()
    # Add extra options
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-popup-blocking")  # Disable pop-ups
    options.add_argument("--ignore-certificate-errors")  # Ignore certificate errors
    options.add_argument("--incognito")  # Use Chrome in incognito mode
    # set up the driver
    # driver = gs.Chrome(options=options) # For Colab
    driver = webdriver.Chrome(options=options)
    driver.get(url)
    # Wait until the specified div is present on the page
    wait = WebDriverWait(driver, 10)

    etf_listings = []
    # from PIL import Image # For Colab debugging
    # from google.colab import files # For Colab debugging
    # image = Image.new('RGBA', (1000, 1000)) # For Colab debugging
    cookies_consent_banner = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '.ot-sdk-three.ot-sdk-columns.has-reject-all-button')))
    btn_group = cookies_consent_banner.find_element(By.ID, 'onetrust-button-group')
    accept_btn = wait.until(EC.element_to_be_clickable(btn_group.find_element(By.ID, 'onetrust-accept-btn-handler')))
    accept_btn.click()
    while True:
    # Find the tbody
        div = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '.basis-2\\/3 .overflow-x-auto')))
        table = div.find_element(By.TAG_NAME, 'table')
        tbody = table.find_element(By.TAG_NAME, 'tbody')
        rows = tbody.find_elements(By.TAG_NAME, 'tr')
        # Extract the ETF symbols and names from each row of tbody
        for row in rows:
            symbol = row.find_element(By.TAG_NAME, 'td').find_element(By.TAG_NAME, 'a').text
            name = row.find_elements(By.TAG_NAME, 'td')[1].text
            etf_listings.append({'symbol': symbol, 'name': name})
        print(len(etf_listings))
        # Find the 'Next' anchor tag
        div = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '.justify-between.py-2.flex')))
        # print(div.get_attribute('outerHTML')) # For debugging
        ul = div.find_element(By.TAG_NAME, 'ul')
        li = ul.find_elements(By.TAG_NAME, 'li')
        second_last_li = li[-2]
        # print(second_last_li.get_attribute('outerHTML')) # For debugging
        # Exit the loop if no more 'Next' anchor tag found
        if 'text-gray-500' in second_last_li.get_attribute('class'):
            break
        next = wait.until(EC.element_to_be_clickable(second_last_li.find_element(By.TAG_NAME, 'a')))
        # print(next.get_attribute('outerHTML')) # For debugging
        # driver.execute_script('arguments[0].scrollIntoView(true)', next) # For debugging
        # driver.get_screenshot_as_file("filname.png") # For Colab debugging
        # Click on 'Next' anchor tag
        next.click()
    driver.quit()
    # For Colab debugging
    # Print the extracted ETF symbols and names
    # for listing in etf_listings:
    #     print(f"Symbol: {listing['Symbol']}, Name: {listing['Name']}")

    etfs_json = {"data": {"table": {"rows": etf_listings}}}
    etfs_json_string = json.dumps(etfs_json, indent=4)
    # files.download("filname.png") # For Colab debugging

    bucket_name = 'market-ai-2024'
    object_name = 'nyse-etfs-symbol-name.json'
    # Add/Replace a JSON file in Google Cloud Storage
    def replace_json_in_storage(bucket_name, object_name, data):
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        bucket.storage_class = "STANDARD"
        if bucket.exists():
            blob = bucket.blob(object_name)
            if blob.exists():
                blob.delete()  # Delete existing blob
            print('Object deleted')
            try:
                blob.upload_from_string(data, content_type='application/json')
            except:
                print('Create object timeout')
                return 'Create object timeout' 
        else:
            print('Creating bucket...')
            bucket = storage_client.create_bucket(bucket, location="us-west1")
            blob = bucket.blob(object_name)
            try:
                blob.upload_from_string(data, content_type='application/json', timeout=15)
            except:
                print('Create object timeout')
                return 'Create object timeout' 
        print('Object created')
        return 'Executed'
        # Ref https://github.com/googleapis/python-storage/tree/main/samples/snippets
    res = replace_json_in_storage(bucket_name, object_name, etfs_json_string)
    return res