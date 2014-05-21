#require 'micromachine'

# Patched MicroMachine
# Add event parameters to callback
# Allow repeated `when` for same event by adding to the @transitions_for hash
class MicroMachine
  InvalidEvent = Class.new(NoMethodError)

  attr :transitions_for
  attr :state

  def initialize initial_state
    @state = initial_state
    @transitions_for = Hash.new { |hash, key| hash[key] = {} }
    @callbacks       = Hash.new { |hash, key| hash[key] = [] }
  end

  def on key, &block
    @callbacks[key] << block
  end

  def when(event, transitions)
    transitions_for[event].merge!(transitions)
  end

  def trigger event
    if trigger?(event)
      from, @state = @state, transitions_for[event][@state]
      callbacks = @callbacks[@state] + @callbacks[:any]
      callbacks.each { |callback| callback.call(event, from) }
      true
    else
      false
    end
  end

  def trigger?(event)
    raise InvalidEvent unless transitions_for.has_key?(event)
    transitions_for[event][state] ? true : false
  end

  def events
    transitions_for.keys
  end

  def states
    events.map { |e| transitions_for[e].to_a }.flatten.uniq
  end

  def ==(some_state)
    state == some_state
  end
end

# Remarks
# `micromachine` uses implicit state definition
# 

phone = MicroMachine.new(:on_hook) # Initial state OnHook

def phone.trigger!(event)
  self.trigger(event) || abort("Unhandled event '#{event}' in state '#{self.state.capitalize}'")
end

# State On Hook
phone.when(:digit,         :on_hook => :dialing)
phone.when(:incoming_call, :on_hook => :ringing)

# State Dialing
phone.when(:digit,    :dialing => :dialing)
phone.when(:off_hook, :dialing => :alerting)
phone.when(:on_hook,  :dialing => :on_hook)

# State Alerting
phone.when(:connected, :alerting => :connected)
phone.when(:busy,      :alerting => :busy)
phone.when(:on_hook,   :alerting => :on_hook)

# State Connected
phone.when(:on_hook, :connected => :on_hook)

# State Ringing
phone.when(:off_hook, :ringing => :connected)
phone.when(:on_hook,  :ringing => :on_hook)

# Transitions
phone.on(:any) do |event, from|
  puts "%s [ %s -> %s ]" %
    [ event, from.capitalize, phone.state.capitalize ]
end

# Behaviour
i, number = 0, [9,1,1]
digits = []
phone.on(:dialing)   { digits << number[i]; i += 1 }
phone.on(:alerting)  { |event, from| puts "Dial number #{digits.join}" }
phone.on(:connected) { puts "Say: Happy Mothersday!" }

# Sequence
phone.trigger!(:digit)
phone.trigger!(:digit)
phone.trigger!(:digit)
phone.trigger!(:off_hook)
phone.trigger!(:connected)
phone.trigger!(:on_hook)
