require 'finite_machine'

fsm = FiniteMachine.define do
  initial :previous

  events {
  	event :go, :previous => :next, if: -> { puts "\tchecking condition"; true }
  }

  callbacks {
    on_before     { |event| puts "before :#{event.name}"    }
    on_exit       { |event| puts "\texit :#{event.from}" }
    on_transition { |event| puts "\t\ttransition :#{event.name} :#{event.from} -> :#{event.to}" }
  	on_enter      { |event| puts "\tenter :#{event.to}"  }
  	on_after      { |event| puts "after :#{event.name}"     }
  }
end

fsm.go