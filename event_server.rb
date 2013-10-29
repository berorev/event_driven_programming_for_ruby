require 'socket'
require './event_message_handler.rb'

class EventServer
  def initialize(host, port)
    @server = TCPServer.new(host, port)
    @streams = [@server]
  end
  
  def start(&blk)
    evt_msg_handler = EventMessageHandler.new
    blk.call(evt_msg_handler)
    
    while true
      puts 'Select...'
      
      ready = IO.select(@streams)
      r = ready.first
      
      r.each do |stream|
        if stream == @server
          puts 'Someone connected to server.'
          stream, sockaddr = @server.accept
          @streams << stream
        elsif stream.eof?
          puts 'Client disconnected'
          @streams.delete(stream)
          stream.close
        else
          puts 'Reading...'
          msg = stream.gets("\n")
          
          evt_msg_handler.handle(msg)
        end
      end
      
    end
  end
end

EventServer.new('localhost', 2222).start do |h|
  h.onmessage do |msg|
    puts "Server received '#{msg}'"
  end
end
