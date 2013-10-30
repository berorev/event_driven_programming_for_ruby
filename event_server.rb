require 'socket'
require './event_handler.rb'

class EventServer
  def initialize(host, port)
    @server = TCPServer.new(host, port)
    @streams = [@server]
  end
  
  def start(&blk)
    evt_handler = EventHandler.new
    blk.call(evt_handler)
    
    while true
      puts 'Select...'
      
      ready = IO.select(@streams)
      r = ready.first
      
      r.each do |stream|
        if stream == @server
          stream, sockaddr = @server.accept
          @streams << stream
          
          evt_handler.emit(:connect, stream)
        elsif stream.eof?
          @streams.delete(stream)
          stream.close
          
          evt_handler.emit(:close)
        else
          msg = stream.gets("\n")
          
          evt_handler.emit(:msg, msg.strip)
        end
      end
      
    end
  end
end

EventServer.new('localhost', 2222).start do |h|
  h.on(:connect) do
    puts 'Someone connected to server.'
  end
  
  h.on(:msg) do |msg|
    puts "Server received '#{msg}'"
  end
  
  h.on(:close) do
    puts 'Client disconnected'
  end
end
