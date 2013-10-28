# reference: https://gist.github.com/sandro/1192557

require 'socket'

begin
  acceptor = TCPServer.new(2202)
  fds = [acceptor]
  
  while true
    puts 'Ready...'
    
    ready = IO.select(fds)
    readable = ready.first
    
    p readable
    
    readable.each do |client|
      if client == acceptor
        puts 'Someone connected to server. Adding socket to fds.'
        client, sockaddr = acceptor.accept
        fds << client
      elsif client.eof?
        puts 'Client disconnected'
        fds.delete(client)
        client.close()
      else
        puts 'Reading...'
        msg = client.gets("\n")
        p msg
      end
    end
  end
ensure
  puts 'Cleaning up...'
  fds.each(&close)
end