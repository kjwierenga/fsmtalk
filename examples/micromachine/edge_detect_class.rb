require 'micromachine'

# Remarks
# `micromachine` uses implicit state definition
# 

class EdgeDetect

  def zero!
    edge.trigger(:zero)
  end

  def one!
    edge.trigger(:one)
  end

  def edge
    @detector ||= begin
      fsm = MicroMachine.new(:zero) # Initial state

      fsm.when(:zero, :one  => :zero)
      fsm.when(:one,  :zero => :one)
      fsm.on
      fsm
    end
  end

end

detector = EdgeDetect.new

detector.fsm.states

detector.zero!
detector.zero!
detector.zero!
detector.one!
detector.one!
detector.one!
detector.zero!
detector.zero!
detector.zero!
detector.one!
detector.one!
detector.one!
