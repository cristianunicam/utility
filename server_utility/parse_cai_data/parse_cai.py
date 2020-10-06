from os import write
from urllib.request import urlopen as u_req
from bs4 import BeautifulSoup as soup

cai_url = 'https://www.caifabriano.it/wp/cpc/elenco-sentieri/'
csv_file='data.csv'
csv=open(csv_file,'w')
headers="id,cai_section,difficulty,time,km,ascent,download_link,description\n"
csv.write(headers)

# Opening up connection, grab the content
u_client = u_req(cai_url)
page_html = u_client.read()

# Close connection
u_client.close

# HTML parsing
page_soup = soup(page_html,"html.parser")

# Get the table
table_row = page_soup.find_all("tr")

# Index for cycling the table
tr_index=0

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
                text_list=list(text)
                # Replace comma
                character_index=0
                for character in text_list:
                    if character==',':
                        ascii_character_of_the_next_character=ord(text_list[character_index+1])
                        if (not ascii_character_of_the_next_character<58) or ascii_character_of_the_next_character==32:
                            text_list[character_index]=''
                    character_index+=1
                text=''.join(text_list)
                # Cancel text
                if text[text.find("Sentiero vecchio: ")] == 'S':
                    text=text[18:]

                # Cancel text
                difficulty_index=text.find("Difficoltà: ")
                if difficulty_index > 0:
                    text=text[:difficulty_index]+text[difficulty_index+12:]

                # Cancel text
                time_index=text.find("Tempo: ")
                if time_index > 0:
                    text=text[:time_index]+text[time_index+7:]
                    text_list=list(text)
                    text_list[time_index-1]='|'
                    if text_list[time_index+4] == ' ':
                        text_list[time_index+4]='|'
                    elif text_list[time_index+5] == ' ':
                        text_list[time_index+5] ='|'
                    text="".join(text_list)

                # Cancel text
                km_index=text.find("Km: ")
                if km_index > 0:
                    text=text[:km_index]+text[km_index+4:]

                # Cancel text
                ascent_index=text.find("Ascesa m: ")
                if ascent_index > 0:
                    text=text[:ascent_index]+text[ascent_index+10:]
                    text_list=list(text)
                    text_list[ascent_index-1]='|'
                    text=''.join(text_list)

                # Cancel text
                sez_index=text.find("Sez.CAI")
                if sez_index > 0:
                    text=text[sez_index+23:]

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
                    download_link=a['href']
                # Download gpx files
                file_data = u_req(download_link)
                data_to_write=file_data.read()
                with open('route_gpx/'+id+".gpx",'wb') as f:
                    f.write(data_to_write)
                    f.close()
        # Write data inside csv
        csv.write(id + ',' + information + ',' + download_link + ','+"dummy description"+'\n')
        # Print formatted data
        print("\nID: "+id+"\nINFORMATION: "+information+"\nLink download: "+download_link)
        # Change row to check
        tr_index+=1
# Close csv file
csv.close()