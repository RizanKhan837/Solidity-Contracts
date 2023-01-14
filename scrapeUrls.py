import requests
from bs4 import BeautifulSoup
import pandas as pd

# Specify the category to search for
category = 'software development'

# Make a request to the LinkedIn search page
url = 'https://www.linkedin.com/search/results/companies/?keywords=' + category
response = requests.get(url)

# Parse the HTML
soup = BeautifulSoup(response.text, 'html.parser')

# Extract the URLs
urls = []
for link in soup.find_all('a', {'class': 'search-result__result-link'}):
    urls.append(link.get('href'))

# Write the URLs to an Excel file
df = pd.DataFrame({'URLs': urls})
df.to_excel('linkedin_urls.xlsx', index=False)
