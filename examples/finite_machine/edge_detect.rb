require 'finite_machine'

# Remarks
# `finite_machine` uses implicit state definition
# 

class EdgeDetect

  attr_accessor :signal

  def initialize
    context = self
    @signal = FiniteMachine.define do
      initial :zero

      target context

      events {
        event :zero, :one  => :zero
        event :zero, :zero => :zero
        event :one,  :zero => :one
        event :one,  :one  => :one
      }

      callbacks {
        on_enter_event { |event| puts "input : #{event.name}" }
        on_enter(:one) {         puts 'output: edge'     }
      }
    end
  end

end

detect = EdgeDetect.new

detect.signal.zero
detect.signal.one
detect.signal.zero
detect.signal.one
detect.signal.zero
detect.signal.one
detect.signal.zero
detect.signal.one

