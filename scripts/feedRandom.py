import sqlite3
import datetime
import random

conn = sqlite3.connect('../db/development.sqlite3')
c = conn.cursor()

# Feed some random number into the database
d = datetime.datetime(2017, 1, 6, 12, 1, 1)
today = datetime.datetime(2017, 4, 7, 12, 1, 1)
while d < today:
    c.execute("INSERT INTO usages (feedId, timestamp, power, created_at, updated_at) VALUES ('458165108', '" + d.strftime('%Y%m%d %H:%M:%S') + "', " + str(random.randint(0, 500)) + ", '20170406 12:45:32', '20170406 12:45:32')")
    d = d + datetime.timedelta(0,300)
    #print d.strftime('%Y%m%d %H:%M:%S')
    #print random.randint(0, 500) 
print today.strftime('%Y%m%d %H:%M:%S')


#c.execute("INSERT INTO usages (feedId, timestamp, power, created_at, updated_at) VALUES ('458165108', '20170406 12:45:32', 276, '20170406 12:45:32', '20170406 12:45:32')")

conn.commit()
conn.close()
