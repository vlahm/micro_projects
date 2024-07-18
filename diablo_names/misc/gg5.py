import requests
from bs4 import BeautifulSoup
import os

# Define the URL of the page
url = 'https://diablo-archive.fandom.com/wiki/Category:Diablo_II_Monster_Images?fileuntil=Returned+Lightning+Mage+%28Diablo+II%29.gif#mw-category-media'

# Create a directory to save the GIFs if it doesn't exist
os.makedirs('diablo_ii_monster_images', exist_ok=True)

# Fetch the HTML content of the page
response = requests.get(url)
response.raise_for_status()  # Ensure we notice bad responses

# Parse the HTML
soup = BeautifulSoup(response.content, 'html.parser')

# Find all image tags
images = soup.find_all('img', src=True)

# Filter for GIF images and download them
for img in images:
    src = img['src']
    if '.gif' in src:
        # Extract the filename from the URL
        filename = os.path.basename(src).split('?')[0]
        # Fetch the image
        img_response = requests.get(src)
        img_response.raise_for_status()
        # Save the image to the directory
        with open(os.path.join('diablo_ii_monster_images', filename), 'wb') as f:
            f.write(img_response.content)
        print(f'Saved {filename}')

print('All images have been downloaded.')

