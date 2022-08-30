require 'finite_machine'

phone = FiniteMachine.define do
  initial :on_hook

  digits = []

  events {
    # On Hook
    event :digit, :on_hook => :dialing

    # Dialing
    event :digit,    :dialing => :dialing
    event :off_hook, :dialing => :off_hook
  }

  callbacks {
    on_before(:digit)   { |event, digit| digits << digit; puts "digit: #{digit}" }
    on_after(:off_hook) { |event| puts "Dialed #{digits.join}" }

    on_transition { |event|
      puts "%s [ %s -> %s ]" %
        [event.name, event.from.capitalize, event.to.capitalize]
    }
  }
end

phone.digit(9)
phone.digit(1)
phone.digit(1)
phone.off_hook
