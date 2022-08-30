require 'finite_machine'

phone = FiniteMachine.define do
  initial :on_hook

  events {
    event :off_hook, :on_hook  => :off_hook
    event :on_hook,  :off_hook => :on_hook
  }

  callbacks {
    on_before(:on_hook) { puts "receive on_hook event"  }
    on_enter(:on_hook)  { puts "entering on_hook state" }
  }
end

phone.off_hook
phone.on_hook
