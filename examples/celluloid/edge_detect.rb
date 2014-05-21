require 'celluloid/autostart'
require 'celluloid/fsm'
require 'celluloid/io'

# explicit state definition

class Ping
  include Celluloid::IO
  include Celluloid::FSM
  include Celluloid::Logger

  def dispatch(event)
    debug "PING: received #{event}"
    Actor[:pong].dispatch('ping')
  end

  def run
    Actor[:pong].dispatch('ping')
  end
end

class Pong
  include Celluloid::IO
  include Celluloid::FSM
  include Celluloid::Logger

  def dispatch(event)
    if 'ping' == event
      debug 'PONG: received ping'
      Actor[:ping].dispatch('pong')
    end
  end
end

ping = Celluloid::Actor[:ping] = Ping.new
pong = Celluloid::Actor[:pong] = Pong.new

ping.async.run

sleep

# Celluloid::Actor[:ping].async.run

# class EdgeDetect
#   include Celluloid::FSM

#   default_state :zero

#   state :zero, :to => :one do
#     transition :one if 1 == @input
#   end

#   state :one, :to => :zero do
#     transition :zero if 0 == @input
#   end
# end

