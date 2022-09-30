import pymssql
import pandas as pd
#import csv file to dataframe
data = pd.read_csv('/Users/b00merz/Desktop/WhatDoYouKnow/transformed_training.csv')
df = pd.DataFrame(data)

# connect to database
conn = pymssql.connect(server='localhost', user='sa', password='Bongthoi12', database='test')
cursor = conn.cursor()

# Create Table
cursor.execute('''
                CREATE TABLE STG.TRAINING(
                    correct             INT,
                    outcome             INT,
                    user_id             INT,
                    question_id         INT,
                    question_type       INT,
                    group_name          INT,
                    track_name          INT,
                    subtrack_name       INT,
                    tag_string          NVARCHAR(70),
                    answer_id           INT,
                    game_type           INT,
                    num_players         INT,
                    question_set_id     INT,
                    round_started_date  DATE,
                    round_started_time  TIME,
                    answered_date       DATE,
                    answered_time       TIME,
                    deactivated_date    DATE,
                    deactivated_time    TIME,

                )
''')

# Insert DataFrame to Table

cursor.execute('''
                BULK INSERT STG.TRAINING
                FROM '/transformed_training.csv'
                WITH(
                    FORMAT = 'CSV',
                    FIRSTROW = 2,
                    FIELDTERMINATOR = ';',
                    ROWTERMINATOR = '0x0a'
                )
                ''')

conn.commit()
conn.close()
