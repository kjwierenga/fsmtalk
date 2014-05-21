require 'finite_machine'

fsm = FiniteMachine.define do
  initial :previous

  events {
  	event :go, :previous => :next, if: -> { puts "checking condition"; true }
  }

  callbacks {
    on_exit_state  { |event| puts "exit_#{event.from}" }
  	on_enter_event { |event| puts "\tbefore_#{event.name}"    }
    on_enter(:any) { |event| puts "\t\ttransition: #{event.name}: #{event.from} -> #{event.to}" }
  	on_enter_state { |event| puts "\tenter_#{event.to}"  }
  	on_exit_event  { |event| puts "after_#{event.name}"     }
  }
end

fsm.go