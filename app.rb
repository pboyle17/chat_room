require 'bundler'
# require 'sinatra/base'

Bundler.require


EventMachine.run do
  class App < Sinatra::Base
    get '/' do
      erb :home
    end
  end
  App.run! :port => 3000
end

@clients = []

EM:WebSocket.start(:host => '0.0.0.0', :port '3001') do |ws|
  ws.onopen do |handshake|
    @clients $lt;&lt; ws
    ws.send 'Connected to #{handshake.path}.'
  end

  ws.onclose do
    ws.send 'closed'
    @clients.delete ws
  end

  ws.onmessage do |msg|
    puts "recieved message: #{msg}"
    @clients.each do |socket|
      socket.send msg
    end
  end
end
