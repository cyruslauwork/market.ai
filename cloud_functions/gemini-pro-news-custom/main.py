import functions_framework

from gnews import GNews
from requests.exceptions import RequestException
import time

# GenAI
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

# VertexAI
# import subprocess
# MODEL_ID = 'gemini-1.5-pro-preview-0409'
# PROJECT_ID = 'market-ai-2024'

symbols = 'Error: Parameter "symbols" cannot be empty.'
question = 'Error: Parameter "question" cannot be empty.'
# VertexAI
# app_access_token = 'Error: Parameter "app_access_token" cannot be empty.'

@functions_framework.http
def https(request):
    if request.method == 'GET':
        request_args = request.args
        if request_args and 'symbols' in request_args:
            symbols = str(request_args['symbols'])
        else:
            return symbols
        if request_args and 'question' in request_args:
            question = str(request_args['question'])
        else:
            return question
        # VertexAI
        # if request_args and 'app_access_token' in request_args:
        #     app_access_token = str(request_args['app_access_token'])
        # else:
        #     return app_access_token
    else:
        return 'GET method is required'
    
    try:
        # GenAI
        genai.configure(api_key=API_KEY)
        # def list_all_models():
        #     try:
        #         models = genai.list_models()
        #         for model in models:
        #             print(f"Name: {model.name}, Display Name: {model.display_name}")
        #     except Exception as exception:
        #         print("Error listing models:", exception)
        # list_all_models()
        MODEL = genai.GenerativeModel('gemini-1.5-pro-latest')

        try:
            google_news = GNews(period='90d', max_results=50, country='US')
            def get_google_news(symbols, max_retries=1, retry_delay=2):
                retries = 0
                news_list = [] # Create a list to store the news
                while retries <= max_retries:
                    try:
                        news = google_news.get_news(symbols)
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
            news = get_google_news(symbols)
            if news is not None:
                # GenAI
                res = MODEL.generate_content(question + symbols + '?' + ' Your answers should based on the following news titles only: ' + str(news),
                                            generation_config=LONG_GENERATION_CONFIG,
                                            stream=False,
                                            )
                # VertexAI
                # text = question + symbols + '?' + ' Your answers should based on the following news titles only: ' + str(news)
                # curl_commmand = """curl \
                #                 -X POST \
                #                 -H "Authorization: Bearer {app_access_token}" \
                #                 -H "Content-Type: application/json" \
                #                 https://asia-east1-aiplatform.googleapis.com/v1/projects/{PROJECT_ID}/locations/asia-east1/publishers/google/models/{MODEL_ID}:streamGenerateContent -d \
                #                 $'{
                #                     "contents": {
                #                     "role": "user",
                #                     "parts": [
                #                         {
                #                         "text": {text}
                #                         }
                #                     ]
                #                     },
                #                     "safety_settings": {
                #                     "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                #                     "threshold": "BLOCK_LOW_AND_ABOVE"
                #                     },
                #                     "generation_config": {
                #                         "temperature": 1.0,
                #                         "topP": 0.95,
                #                         "maxOutputTokens": 8192,
                #                     }
                #                 }'"""
                # res = subprocess.run(curl_commmand, capture_output=True, text=True, shell=True, timeout=60)
                # # Get the output from the command output
                # output = response.stdout
                # error = response.stderr
                # if response.returncode != 0:
                #     return 'Error: ' + str(error), 500
                # else:
                #     res = output

                return res.candidates[0].content.parts[0].text
            else:
                return 'Max retries exceeded. Unable to fetch news.'
        except:
            return'Error: Unable to generate content from model.'
    except:
        return 'Error: Unable to access model.'