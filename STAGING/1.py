import pymssql
import pandas as pd
#import csv file to dataframe
data = pd.read_csv('/Users/b00merz/Desktop/WhatDoYouKnow/transformed_cat.csv')
df = pd.DataFrame(data)

# connect to database
conn = pymssql.connect(server='localhost', user='sa', password='Bongthoi12', database='test')
cursor = conn.cursor()

cursor.execute(''' drop table STG.TRAINING ''')

conn.commit()
conn.close()
