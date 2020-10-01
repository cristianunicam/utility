from os import write
from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup

cai_url = 'https://www.caifabriano.it/wp/cpc/elenco-sentieri/'
csvFile='data.csv'
csv=open(csvFile,'w')
headers="id,CAI section,difficulty,time,km,ascent"
csv.write(headers)

# Opening up connection, grab the content
uClient = uReq(cai_url)
page_html = uClient.read()

# Close connection
uClient.close

# HTML parsing
page_soup = soup(page_html,"html.parser")

# Get the table
table_row = page_soup.find_all("tr")

# Index for cycling the table
trIndex=0

# Cycle all the rows in the table
for tr in table_row:
    # Get the first column and check if it's the header
    td_table = tr.td
    if td_table.text == "Sentiero":
        print("Header found")
    else:
        cont = 0
        # Cycle all the column
        for td in tr.findAll("td"):
            # Find br tag and remove it
            for br_tag in td.findAll('br'):
                br_tag.replace_with('|')
            # Get the text from the column and save it
            text=td.text
            text = text.replace('\n','')

            cont=cont+1
            # Set the id
            if cont==1:
                text=text.replace(' ','_')
                id=text
            # Get the data from the second column
            elif cont==2:
                listaTesto=list(text)
                # Replace comma
                characterIndex=0
                for character in listaTesto:
                    if character==',':
                        asciiCharacterOfTheNextCharacter=ord(listaTesto[characterIndex+1])
                        if (not asciiCharacterOfTheNextCharacter<58) or asciiCharacterOfTheNextCharacter==32:
                            listaTesto[characterIndex]=''
                    characterIndex+=1
                text=''.join(listaTesto)
                # Cancel text
                if text[text.find("Sentiero vecchio: ")] == 'S':
                    text=text[18:]

                # Cancel text
                difficultyIndex=text.find("Difficoltà: ")
                if difficultyIndex > 0:
                    text=text[:difficultyIndex]+text[difficultyIndex+12:]

                # Cancel text
                timeIndex=text.find("Tempo: ")
                if timeIndex > 0:
                    text=text[:timeIndex]+text[timeIndex+7:]
                    textList=list(text)
                    textList[timeIndex-1]='|'
                    textList[timeIndex+4]='|'
                    text="".join(textList)

                # Cancel text
                kmIndex=text.find("Km: ")
                if kmIndex > 0:
                    text=text[:kmIndex]+text[kmIndex+4:]

                # Cancel text
                ascentIndex=text.find("Ascesa m: ")
                if ascentIndex > 0:
                    text=text[:ascentIndex]+text[ascentIndex+10:]
                    textList=list(text)
                    textList[ascentIndex-1]='|'
                    text=''.join(textList)

                # Cancel text
                sezIndex=text.find("Sez.CAI")
                if sezIndex > 0:
                    text=text[sezIndex+23:]

                # Replace comma for km
                text=text.replace(',','^')
                # Replace | with commas for setting the string as a csv
                text=text.replace('|',',')
                information=text
            elif cont==3:
                # Leave empty for now and set only the url
                #description=text

                # Get download link
                for a in td.div.find_all('a', href=True):
                    downloadLink=a['href']
                # Download gpx files
                filedata = uReq(downloadLink)
                dataToWrite=filedata.read()
                with open('route_gpx/'+id+".gpx",'wb') as f:
                    f.write(dataToWrite)
                    f.close()
        # Write data inside csv
        csv.write(id + ',' + information + '\n')
        # Print formatted data
        print("\nID: "+id+"\nINFORMATION: "+information+"\nLink download: "+downloadLink)
        # Change row to check
        trIndex+=1
# Close csv file
csv.close()