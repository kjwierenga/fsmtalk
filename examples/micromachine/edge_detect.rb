require 'micromachine'

# Remarks
# `micromachine` uses implicit state definition
# 

fsm = MicroMachine.new(:zero) # Initial state

fsm.when(:zero, :one  => :zero)
fsm.when(:one,  :zero => :one)
fsm.on(:any) { puts fsm.state.capitalize }

puts fsm.states.map(&:capitalize).join('; ')

fsm.when(:zero, :inconclusive => :zero)

puts fsm.states.map(&:capitalize).join('; ')

fsm.trigger(:zero)
fsm.trigger(:zero)
fsm.trigger(:zero)
fsm.trigger(:one)
fsm.trigger(:one)
fsm.trigger(:one)
fsm.trigger(:zero)
fsm.trigger(:zero)
fsm.trigger(:zero)
fsm.trigger(:one)
fsm.trigger(:one)
fsm.trigger(:one)
