import pymssql
import pandas as pd
#import csv file to dataframe
data = pd.read_csv('/Users/b00merz/Desktop/WhatDoYouKnow/transformed_cat.csv')
df = pd.DataFrame(data)

# connect to database
conn = pymssql.connect(server='localhost', user='sa', password='Bongthoi12', database='test')
cursor = conn.cursor()

# Create Table
cursor.execute('''
                CREATE TABLE STG.CATEGORY(
                    id      INT,
                    field   NVARCHAR(70),
                    label   NVARCHAR(70)
                )
''')

# Insert DataFrame to Table

cursor.execute('''
                BULK INSERT STG.CATEGORY
                FROM '/transformed_cat.csv'
                WITH(
                    FORMAT = 'CSV',
                    FIRSTROW = 2,
                    FIELDTERMINATOR = ';',
                    ROWTERMINATOR = '0x0a'
                )
                ''')

conn.commit()
conn.close()
