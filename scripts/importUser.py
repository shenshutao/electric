import sqlite3
import datetime
import random
import string

def randStr(N):
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(N))

#conn = sqlite3.connect('../db/development.sqlite3')
conn = sqlite3.connect('../db/production.sqlite3')
c = conn.cursor()

f = open('users.csv')
fout = open('user_assigned_password.csv', 'w')
lines = f.readlines()
for line in lines[1:]:
    items = line.strip().split(',')
    user = {'id':items[0], 'feedId':items[1], 'apiKey':items[2], 'passwordKey':randStr(10), 'price':items[3], 'group':items[4],
            'goal':items[5], 'lastname':items[6], 'whatsapp':items[7], 'email':items[8]}
    fout.write(user['id'] + "," + user['feedId'] + "," + user['apiKey'] + "," + user['passwordKey'] + "," + user['price'] + "\n")
    c.execute("INSERT INTO users (id, feedId, apiKey, passwordKey, price, groupNum, goal, lastname, whatsapp, email, created_at, updated_at) VALUES (" + user['id']+",\""+user['feedId']+"\",\""+user['apiKey']+"\",\""+user['passwordKey']+"\",\""+user['price']+"\",\""+user['group']+"\",\""+user['goal']+"\",\""+user['lastname']+"\",\""+user['whatsapp']+"\",\""+user['email']+"\", '2017-04-06 12:45:32', '2017-04-06 12:45:32')") 

fout.close()
f.close()
conn.commit()
conn.close()
