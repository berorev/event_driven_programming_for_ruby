# reference: http://www.tutorialspoint.com/ruby/ruby_socket_programming.htm

require 'socket'

hostname = 'localhost'
port = 2222

s = TCPSocket.open(hostname, port)

s.puts 'hi'

s.close