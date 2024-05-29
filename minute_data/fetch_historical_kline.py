# Windows: pip install futu-api
# Linux/macOS: pip3 install futu-api

# Ref to https://openapi.futunn.com/futu-api-doc/en/quote/request-history-kline.html

# Interface Restrictions:
# - Candlestick data with timeframes of 60 minutes and below, is only supported for the last 8 years.
# Data with timeframes of daily and above, is supported for the last 10 years.
# - A maximum of 60 requests per 30 seconds. Note: If you obtain data by page, 
# this frequency limit rule is only applicable to the first time calling the interface, 
# and subsequent pages request frequency is unlimited.
# - Historical candlestick quota based on your account assets and transaction conditions. Therefore, 
# you can only obtain historical candlestick data for a limited number of stocks within 30 days. 
# For specific rules, refer to https://openapi.futunn.com/futu-api-doc/en/intro/authority.html#9123. 
# The historical candlestick quota you consume on that day will be automatically released after 30 days.

# Adjustment
# Whenever you are looking to estimate total return, you would use adjusted closing prices. 
# If you are strictly looking for the future stock price, you would use unadjusted closing price. 
# I assume, though, that you are looking to predict the value of holding a stock during a given period, 
# so you would want to use adjusted prices. 

from futu import *
import pandas as pd

FUTUOPEND_ADDRESS = '127.0.0.1'
FUTUOPEND_PORT = 11111
TRADING_FINANCIAL_INSTRUMENT = 'HK.00700'
START_DATE = '2016-05-23'
END_DATE = '2016-05-24'

df = pd.DataFrame()

quote_ctx = OpenQuoteContext(host=FUTUOPEND_ADDRESS, port=FUTUOPEND_PORT, is_encrypt=False)  # Create quote object

ret, data, page_req_key = quote_ctx.request_history_kline(
    TRADING_FINANCIAL_INSTRUMENT, 
    start=START_DATE, 
    end=END_DATE, 
    ktype=KLType.K_1M, # 1 minute data
    autype=AuType.NONE, # Actual price without adjustment
    fields=[KL_FIELD.DATE_TIME, KL_FIELD.OPEN, KL_FIELD.HIGH, KL_FIELD.LOW, KL_FIELD.CLOSE, KL_FIELD.TRADE_VOL], 
    max_count=390, # 390 (6.5 trading hrs * 60 mins) per page, request the first page
    page_req_key=None, 
    extended_time=False
    )
if ret == RET_OK:
    print(data)
    df = pd.concat([df, data], ignore_index=True) # Concatenate existing df and data into new df with unique order
    # print(data['code'][0]) # Take the first stock code
    # print(data['close'].values.tolist()) # The closing price of the first page is converted to a list
else:
    print('error:', data)
while page_req_key != None: # Request all results after
    print('*************************************')
    ret, data, page_req_key = quote_ctx.request_history_kline(
        TRADING_FINANCIAL_INSTRUMENT, 
        start=START_DATE, 
        end=END_DATE, 
        ktype=KLType.K_1M, # 1 minute data
        autype=AuType.NONE, # Actual price without adjustment
        fields=[KL_FIELD.DATE_TIME, KL_FIELD.OPEN, KL_FIELD.HIGH, KL_FIELD.LOW, KL_FIELD.CLOSE, KL_FIELD.TRADE_VOL], 
        max_count=390, # 390 (6.5 trading hrs * 60 mins) per page, request the first page
        page_req_key=page_req_key, 
        extended_time=False
        ) # Request the page after turning data
    if ret == RET_OK:
        print(data)
        df = pd.concat([df, data], ignore_index=True) # Concatenate existing df and data into new df with unique order
    else:
        print('error:', data)
print('All pages are finished!')

df['time_key'] = pd.to_datetime(df['time_key']).astype(int) // 10**9 # Convert 'time_key' column to Unix timestamp
df = df.drop(['code', 'name'], axis=1)
print(df)
df.to_json('output.json', orient='records') # Save as JSON

quote_ctx.close() # Close object to prevent the number of connections from running out