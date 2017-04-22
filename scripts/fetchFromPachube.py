import sqlite3
import datetime
import random
import time
import urllib, urllib2
import json

url = 'http://api.pachube.com/v2/feeds/458165108.json?key=FkKmAX3afWITYmCEVcVG6mBopu5fdCoXZNbXC5pE8lppIEDR'

conn = sqlite3.connect('../db/development.sqlite3')
c = conn.cursor()

last = datetime.datetime(2000, 1, 6, 13, 1, 1)
while 1:
    # GET 
    req = urllib2.Request(url)
    # Response
    rsp = urllib2.urlopen(req)
    # Parse
    content = rsp.read()
    parsed = json.loads(content)
    timestamp = parsed['datastreams'][0]['at']
    current_value = parsed['datastreams'][0]['current_value']
    year = int(timestamp[:4])
    month = int(timestamp[5:7])
    day = int(timestamp[8:10])
    hour = int(timestamp[11:13])
    minute = int(timestamp[14:16])
    second = int(timestamp[17:19])

    d = datetime.datetime(year, month, day, hour, minute, second)
    if d != last:
        print d, current_value
        c.execute("INSERT INTO usages (feedId, timestamp, power, created_at, updated_at) VALUES ('458165108', '" + d.strftime('%Y%m%d %H:%M:%S') + "', " + current_value + ", '20170406 12:45:32', '20170406 12:45:32')")
        conn.commit()
    last = d
    time.sleep(60)

conn.close()
