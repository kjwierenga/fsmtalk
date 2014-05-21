require 'finite_machine'

class Bug
  def pending?
    puts "PENDING?"
    false
  end
end

bug = Bug.new

fsm = FiniteMachine.define do
  initial :initial

  target bug

  events {
    event :bump,  :initial => :low, if: :pending?
    event :bump,  :low     => :medium
  }

  callbacks {
    on_enter_event { |event| puts "#{event.name}\t#{event.from}\t=>\t#{event.to}" }
  }
end

fsm.bump
fsm.bump
