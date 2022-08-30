require 'finite_machine'

class Call
  attr_accessor :digits

  def initialize
    @digits = []
  end

  def dial
    puts "Dialling #{digits.join}"
  end
end

call = Call.new

phone = FiniteMachine.define do
  initial :on_hook

  target call

  events {
    # On Hook
    event :digit,         :on_hook => :dialing
    event :incoming_call, :on_hook => :ringing

    # Dialing
    event :digit,    :dialing => :dialing
    event :off_hook, :dialing => :alerting
    event :on_hook,  :dialing => :on_hook

    # Alerting
    event :connected, :alerting => :connected
    event :busy,      :alerting => :busy
    event :on_hook,   :alerting => :on_hook

    # Connected
    event :on_hook, :connected => :on_hook

    # Ringing
    event :off_hook, :ringing => :connected
    event :on_hook,  :ringing => :on_hook
  }

  callbacks {
    on_before(:on_hook)  { digits = [] }
    on_before(:digit)    { |_, digit| digits << digit }
    on_before(:off_hook) { dial }

    on_exit { |event|
      puts "%s [ %s -> %s ]" %
        [event.name, event.from.capitalize, event.to.capitalize]
    }
  }
end

phone.digit(9)
phone.digit(1)
phone.digit(1)
phone.off_hook
phone.connected
phone.on_hook
