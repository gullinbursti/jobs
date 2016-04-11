require 'eat'

require 'cinch'




class MonitorBot 
  include Cinch::Plugin

  listen_to :monitor_msg, :method => :send_msg

  def send_msg(m, msg, channel)
     
	Channel(channel).send "#{msg}"
  end

end



def server(bot, channel)
  	print "Thread Start\n"
	sleep(4)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, "Going live on MODD.", channel)
	sleep(1)

 end




def server1(bot, channel, subscribeMessage)
	sleep(60)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
end

def server2(bot, channel, subscribeMessage)
	sleep(3600)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
end

def server3(bot, channel, subscribeMessage)
	sleep(7200)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
end

def server4(bot, channel, subscribeMessage)
	sleep(10800)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
end

def server5(bot, channel, subscribeMessage)
	sleep(14400)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
end

def server6(bot, channel, subscribeMessage)
	sleep(18000)
	puts "sending message"
	bot.handlers.dispatch(:monitor_msg, nil, subscribeMessage, channel)
	sleep(1)
	bot.quit()

end


_CSVString = eat("http://beta.modd.live/api/stream_notify.php", :timeout =>40)

#puts "#{_CSVString}"

lines = _CSVString.split("\n")

# Remove trailing whitespace.

   lines.each do |line|


    # Split on comma.
	values = line.split(",")
	value0 = "#" + values[0]
puts value0
puts values[0]



bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = "moddboto"
    c.realname        = "MODDBOTO"
    c.user            = values[0]
    c.server          = "irc.twitch.tv"
    c.port            = 6667
    c.password        = "oauth:zfcxrlmcbtok82iismmtpplevxkxx9"
    c.channels        = [value0]
    c.verbose         = false
    c.plugins.plugins = [MonitorBot]
  end
end



subMessage = "To be notified each time this streamer goes live click here s.00m.co/" + values[0]


	Thread.new { server1(bot, value0, subMessage) }
	Thread.new { server2(bot, value0, subMessage) }	
	Thread.new { server3(bot, value0, subMessage) }
	Thread.new { server4(bot, value0, subMessage) }
	Thread.new { server5(bot, value0, subMessage) }
	Thread.new { server6(bot, value0, subMessage) }


	Thread.new { server(bot, value0) }

puts "starting bot"
bot.start

puts "killing thread"



end
