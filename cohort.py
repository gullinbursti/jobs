import pymysql
import pycurl
import sys
import cStringIO
import json
import time


def getStreamersWithLogs():
	conn = pymysql.connect(host='external-db.s4086.gridserver.com', unix_socket='/tmp/mysql.sock', user='db4086_modd_usr', passwd='f4zeHUga.age', db='db4086_modd')
	cur = conn.cursor()
	cur.execute("SELECT DISTINCT channel_name from stream_chatters")
	streamerList = []
	for r in cur:
		streamerList.append(r[0])
	return streamerList	

def retrieveStreamerPercent(streamer):
	conn = pymysql.connect(host='external-db.s4086.gridserver.com', unix_socket='/tmp/mysql.sock', user='db4086_modd_usr', passwd='f4zeHUga.age', db='db4086_modd')
        cur=conn.cursor()
        cur.execute("SELECT chatters FROM stream_chatters WHERE channel_name  = \'" + streamer + "\' ORDER BY added DESC LIMIT 2")
	table = []
	for r in cur:
		table.append(set(r[0].split(",")))
		
	if len(table) > 1:
		cur.close()
		conn.close()
		return len(table[1]) / len( table[1] & table[0])
	cur.close()
	conn.close()
	return 1	


def logRetention(streamerName, percent):
	conn = pymysql.connect(host='external-db.s4086.gridserver.com', unix_socket='/tmp/mysql.sock', user='db4086_modd_usr', passwd='f4zeHUga.age', db='db4086_modd')

	cur = conn.cursor()
	cur.execute("SELECT COUNT(*) from retention where channel_name=\'"+streamerName + "\' AND type = \'chatters\'")
	result = cur.fetchone()
	number_of_rows = result[0]
	if number_of_rows == 0:
	#insert
		cur.execute("INSERT INTO `retention` (`id`, `channel_name`, `type`, `value`, `updated`) VALUES (NULL, \'" + streamerName + "\', \'chatters\', " +  str(percent) + ", NOW())")
	else:
		cur.execute("UPDATE retention SET value = " + str(percent) + " WHERE channel_name=\'" + streamerName + "\' AND type = \'chatters\' LIMIT 1")
	#update
	cur.close()
	conn.close()


streamers = getStreamersWithLogs()
for s in streamers:
	logRetention(s, retrieveStreamerPercent(s))


#channel_name stream_id chatter added

