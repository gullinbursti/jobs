import pymysql
import pycurl
import sys
import cStringIO
import json
import time

previousStreamerSet = null
currentStreamerSet = null

viewersForStream

while true
	conn = pymysql.connect(host='external-db.s4086.gridserver.com', unix_socket='/tmp/mysql.sock', user='db4086_modd_usr', passwd='f4zeHUga.age', db='db4086_modd')
	cur = conn.cursor()
	cur.execute("SELECT `username` FROM `users` WHERE `type` = 'streamer';")

	for r in cur:
		buf = cStringIO.StringIO()
		#print(r)
		c = pycurl.Curl()
		c.setopt(c.URL, "https://api.twitch.tv/kraken/streams/" + r[0])
		c.setopt(c.WRITEFUNCTION, buf.write)
		c.perform()
		#print(buf.getvalue())
		j = json.loads(buf.getvalue())
		buf.close()
		c.close()
		try:
			if j['stream']:
				chatterBuf = cStringIO.StringIO()
				chatterCurl = pycurl.Curl()
				chatterCurl.setopt(chatterCurl.URL, "https://tmi.twitch.tv/group/user/" + r[0] + "/chatters")
				chatterCurl.setopt(chatterCurl.WRITEFUNCTION, chatterBuf.write)
				chatterCurl.perform()
				chatterJ = json.loads(chatterBuf.getvalue())	
				chatterBuf.close()	
				chatterCurl.close()
				viewerArray = chatterJ['chatters']['moderators'] + chatterJ['chatters']['viewers']
				print len(viewerArray)
				if !previousStreamerSet:
					viewerArray
				if len
		except:
			print 'fuck ada you'
	
	cur.close()
	conn.close()
