require 'finite_machine'

none = FiniteMachine.define do
  events {
  	event :start,   :none => :first_application_state
  	event :restart, :none => :another_application_state
  }

  callbacks {
    on_enter(:any) { |event| puts "Callback transitioning on #{event.name} from #{event.from} to #{event.to}" }
  }
end

puts "States: #{none.states}"
puts "Starting in state: #{none.state}"
none.restart
puts "After explicit start: #{none.state}"

puts "\nNEXT\n\n"

a_machine = FiniteMachine.define do
  initial :state => :first #, :defer => true

  events {
  	event :start, :first => :second
  }

  callbacks {
    on_enter(:any) { |event| puts "Callback transitioning on #{event.name} from #{event.from} to #{event.to}" }
  }
end

puts "States: #{a_machine.states}"
puts "Starting in state: #{a_machine.state}"
a_machine.start
puts "After explicit start: #{a_machine.state}"
a_machine = nil

puts "\nNEXT\n\n"

c_machine = FiniteMachine.define do
  initial :state => :first, :defer => true

  events {
  	event :start, :first => :second
  }

  callbacks {
    on_enter(:any) { |event| puts "Callback transitioning on #{event.name} from #{event.from} to #{event.to}" }
  }
end

puts "States: #{c_machine.states}"
puts "Starting in state: #{c_machine.state}"
c_machine.init
c_machine.start
puts "After explicit start: #{c_machine.state}"
c_machine = nil
