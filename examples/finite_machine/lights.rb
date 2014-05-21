require 'finite_machine'
require 'timers'

timers = Timers.new

def cars_go?
	false
	FiniteMachine::CANCELLED
end

lights = FiniteMachine.define do
  initial :people_go

  events {
    event :timeout,  :cars_go     => :cars_slow
    event :timeout,  :cars_slow   => :cars_stop
    event :timeout,  :cars_stop   => :people_go
    event :timeout,  :people_go   => :people_slow, if: :cars_go?
    event :timeout,  :people_slow => :cars_go
  }

  callbacks {
    on_enter_event { |event| puts "#{event.name}\t#{event.from}\t=>\t#{event.to}" }

    on_enter(:cars_go)     {
    	puts "\t\t\t\t\t\tGREEN"
    	timers.after(10) { timeout }
    }
    on_enter(:cars_slow)   {
    	puts "\t\t\t\t\t\tYELLOW"
    	timers.after(2) { timeout }
    }
    on_enter(:cars_stop)   {
    	puts "\t\t\t\t\t\tRED"
    	timers.after(5) { timeout }
    }
    on_enter(:people_go)   {
    	puts "\t\t\t\t\t\tWALK"
    	timers.after(10) { timeout }
    }
    on_enter(:people_slow) {
    	puts "\t\t\t\t\t\tDON'T WALK"
    	timers.after(10) { timeout }
    }
  }
end

lights.timeout

loop { timers.wait }

# puts 'Hello, world!'
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# lights.timeout
# puts 'Hello, robot!'
