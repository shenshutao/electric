import os
import sys
import sqlite3
import datetime
import random
import time
import urllib, urllib2
import json
import traceback

#logfile = open('log-fetchfrompachube.txt', 'w')

def fetchOnePerson(feedId, apiKey, last, conn):
    c = conn.cursor()
    url = 'http://api.pachube.com/v2/feeds/' + feedId + '.json?key=' + apiKey
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
    now = datetime.datetime.now()

    if d != last:
        print feedId, d, current_value
        #logfile.write(feedId + " " + d.strftime('%Y%m%d %H:%M:%S') + " " + str(current_value) + "\n")
        c.execute("INSERT INTO usages (feedId, timestamp, power, created_at, updated_at) VALUES ('{0}', '{1}', {2}, '{3}', '{4}')".format(feedId, d.strftime('%Y%m%d %H:%M:%S'), current_value, now.strftime('%Y%m%d %H:%M:%S'), now.strftime('%Y%m%d %H:%M:%S')))
    last = d
    return last
    
def readUsers():
    users = []
    f = open('users.csv')
    lines = f.readlines()
    for line in lines[1:]:
        items = line.strip().split(',')
        users.append({'feedId':items[1], 'apiKey':items[2]})
    f.close()
    return users


if __name__=="__main__":
    users = readUsers()
    # record the last edit time of file 'users.csv'
    lasttimefilechange = os.path.getmtime('users.csv')
    conn = sqlite3.connect('../db/production.sqlite3')
    # the last time of data changed for a feedId
    last = {}
    #for each in users:
    #    last[each['feedId'] = datetime.datetime(2000, 1, 6, 13, 1, 1)
    while 1:
        # Check if the 'users.csv' has changed, if changed update the users array.
        if os.path.getmtime('users.csv') != lasttimefilechange:
            lasttimefilechange = os.path.getmtime('users.csv')
            users = readUsers()
        # For each user, check whether there is update
        for each in users:
            try:
                if each['feedId'] not in last:
                    last[each['feedId']] = datetime.datetime(2000, 1, 6, 13, 1, 1)
                last[each['feedId']] = fetchOnePerson(each['feedId'], each['apiKey'], last[each['feedId']], conn)
            except:
                print "Unexpected error when fetch feedId = " + each['feedId'] + ":", sys.exc_info()[0]
                #logfile.write("Unexpected error when fetch feedId = " + each['feedId'] + ": " + traceback.format_exc())

        conn.commit()
        time.sleep(10)
    
conn.close()
