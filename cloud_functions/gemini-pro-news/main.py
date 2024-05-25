import functions_framework

from gnews import GNews
from requests.exceptions import RequestException
import time

import google.generativeai as genai

API_KEY = 'AIzaSyCOT4yo_5uUFHLjR5Wd2tZq7nH-SEO_iuE'
# GenerationConfig https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/gemini#:~:text=the%20following%20parameters%3A-,Parameter,-Description
SHORT_GENERATION_CONFIG = genai.GenerationConfig(
    temperature=0.1,
    top_p=1.0,
    top_k=32,
    candidate_count=1,
    max_output_tokens=32,
)
LONG_GENERATION_CONFIG = genai.GenerationConfig(
    temperature=0.9,
    top_p=1.0,
    top_k=32,
    candidate_count=1,
    max_output_tokens=8192,
)
symbol_and_name = 'Error: Parameter "symbol_and_name" cannot be empty.'

@functions_framework.http
def https(request):
    if request.method == 'GET':
        request_args = request.args
        if request_args and 'symbol_and_name' in request_args:
            symbol_and_name = str(request_args['symbol_and_name'])
        else:
            return symbol_and_name
    else:
        return 'GET method is required'
    
    try:
        genai.configure(api_key=API_KEY)
        MODEL = genai.GenerativeModel('gemini-1.5-pro-latest')
        try:
            google_news = GNews(period='90d', max_results=50, country='US')
            def get_google_news(symbol_and_name, max_retries=1, retry_delay=2):
                retries = 0
                news_list = [] # Create a list to store the news
                while retries <= max_retries:
                    try:
                        news = google_news.get_news(symbol_and_name)
                        for article in news:
                            news_list.append(article['title'])
                        # print(news_list)
                        return news_list
                    except (RequestException, TimeoutError) as e:
                        # print(f"An error occurred: {str(e)}")
                        # print("Retrying...")
                        retries += 1
                        if retries <= max_retries:
                            time.sleep(retry_delay)
                # print("Max retries exceeded. Unable to fetch news.")
                return None
            news = get_google_news(symbol_and_name)
            if news is not None:
                res = MODEL.generate_content('Are there any recent market news that may affecting the price of ' + symbol_and_name + '? Your answers should based on the following news only:' + str(news),
                                            generation_config=LONG_GENERATION_CONFIG,
                                            stream=False,
                                            )
                # return repr(res.candidates[0].content.parts[0].text)
                return res.candidates[0].content.parts[0].text
            else:
                return 'Max retries exceeded. Unable to fetch news.'
        except:
            return 'Error: Unable to generate content from model.'
    except:
        return 'Error: Unable to access model.'