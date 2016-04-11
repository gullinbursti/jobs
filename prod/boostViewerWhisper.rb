require 'eat'
require 'cinch'

class MonitorBot 
  include Cinch::Plugin

  listen_to :monitor_msg, :method => :send_msg

  def send_msg(m, msg, channel)
    Channel(channel).send "#{msg}"
  end
end

def quitServer(mybot)
	sleep(10)
	mybot.quit
end

def server(bot, channel, name, message, bquit)
  sleep(5)
  puts "-------- SENDING WHISPER"
  wsprmsg =  ("/w " + name + " " + message)
  bot.handlers.dispatch(:monitor_msg, nil, wsprmsg, channel)
  sleep(5)
  if bquit
    bot.quit()
    exit
  end
end


#-- convert to array of channels
channel_names = Array.new
whisper_array = Array.new
messages = Array.new
lines = eat("http://beta.modd.live/api/viewer_boost.php?type=whisper", :timeout =>40).split("\n")

if lines.length > 0
  lines.each do |line|
    whisper_array.insert(-1, line.split(','))
    messages.insert(-1, line.split(',')[1])
    channel_names.insert(-1, "#" + line.split(',')[0])
  end


  #-- config bot
  bot = Cinch::Bot.new do
    configure do |c|
      c.server          = "199.9.253.119"
      c.port            = 6667
      c.nick            = "moddboto"
      c.realname        = "moddboto"
      c.user            = "moddboto"
      c.password        = "oauth:zfcxrlmcbtok82iismmtpplevxkxx9"
      c.channels        = channel_names
      c.plugins.plugins = [MonitorBot]
    end
  end

  whisper_array.each do |channel, message|
    quitbot = false
    Thread.new { server(bot, "#" + channel, channel, message, quitbot) }
    sleep(3)
  end

  Thread.new{ quitServer(bot)}
  
  bot.start
  sleep 10
end
