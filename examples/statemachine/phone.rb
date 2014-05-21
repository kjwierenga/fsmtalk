require 'statemachine'

class Call
  attr_accessor :digits

  def initialize
    @digits = []
  end

  def store_digit(digit)
    puts "Dialled #{digit}"
    @digits << digit
  end

  def dial
    puts "Dialling #{digits.join}"
  end
end

call = Call.new

phone = Statemachine.build do

  # On Hook
  trans :on_hook, :digit,         :dialing, :store_digit
  trans :on_hook, :incoming_call, :ringing

  # Dialing
  trans :dialing, :digit,    :dialing, :store_digit
  trans :dialing, :off_hook, :alerting, :dial
  trans :dialing, :on_hook,  :on_hook

  # Alerting
  trans :alerting, :connected, :connected
  trans :alerting, :busy,      :busy
  trans :alerting, :on_hook,   :on_hook

  # Connected
  trans :connected, :on_hook, :on_hook

  # Ringing
  trans :ringing, :off_hook, :connected
  trans :ringing, :on_hook,  :on_hook

  # on_enter(:on_hook)  { digits = [] }
  # on_enter(:digit)    { |_, digit| digits << digit }
  # on_enter(:off_hook) { dial }

  # on_exit_state { |event|
  #   puts "%s [ %s -> %s ]" %
  #     [event.name, event.from.capitalize, event.to.capitalize]
  # }

  context Call.new
end

phone.digit(9)
phone.digit(1)
phone.digit(1)
phone.off_hook
phone.connected
phone.on_hook
