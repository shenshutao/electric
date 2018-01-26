import sqlite3
from datetime import datetime
import random
import os

os.system("pwd")
os.system("cp ../db/production.sqlite3 ../db/production_correct.sqlite3")
conn = sqlite3.connect('../db/production.sqlite3')
conn2 = sqlite3.connect('../db/production_correct.sqlite3')
c = conn.cursor()
c2 = conn2.cursor()
c2.execute("delete from usages where 1;");
def convert(s):
    return s[:4] + '-' + s[4:6] + '-' + s[6:8] + s[8:]
for row in c.execute("select * from usages;"):
    datetimeObj = datetime.strptime(row[2], '%Y%m%d %H:%M:%S')
    
    c2.execute("INSERT INTO usages (feedId, timestamp, power, created_at, updated_at) VALUES ('{0}', '{1}', {2}, '{3}', '{4}')".format(row[1], datetimeObj.strftime('%Y-%m-%d %H:%M:%S'), row[3], convert(row[4]), convert(row[5])))


conn.commit()
conn.close()

conn2.commit()
conn2.close()
