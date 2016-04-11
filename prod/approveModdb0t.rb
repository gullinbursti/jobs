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
  bot.handlers.dispatch(:monitor_msg, nil, "/mod moddboto", channel)
  sleep(1)
end


_CSVString = eat("http://beta.modd.live/api/viewer_moddbot.php", :timeout =>40)
lines = _CSVString.split("\n")

lines.each do |line|
  # Split on comma.
  values = line.split(",")
  value0 = "#" + values[0]
  puts value0
  puts values[0]

  bot = Cinch::Bot.new do
    configure do |c|
      c.nick            = values[0]
      c.realname        = values[0]
      c.user            = values[0]
      c.server          = "irc.twitch.tv"
      c.port            = 6667
      c.password        = "oauth:" + values[1]
      c.channels        = [value0]
      c.verbose         = false
      c.plugins.plugins = [MonitorBot]
    end
  end

  Thread.new { server(bot, value0) }

  puts "starting bot"
  bot.start
  sleep(19000)
  puts "killing thread"
end
