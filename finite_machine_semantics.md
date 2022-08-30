I'm getting pretty confused now. There seems to be a combinatorial explosion of options to specify the initial transition (singular) to initialize the state machine and trigger or prevent callbacks. And in my opinion there is still a mixup of semantics and behavior.

If I understand correctly the following possibilities are provided:

* No `initial` clause. First state is `:none` and the state machine needs to be set off explicitly by firing an (application specified) event. Callbacks **are** triggered on the transition from `:none` to the first application state. Specifying `silent: true` will **not** trigger callbacks.

```ruby
fsm = FiniteMachine.define do
  events {
  	event :start, :none => :first
  }
end
fsm.start # triggers callbacks
```

Note that nothing prevents us from specifying multiple (different) events to enter any of the states of our machine resulting in a state machine with _multiple initial states_:

```ruby
fsm = FiniteMachine.define do
  events {
  	event :first_start,   :none => :first
  	event :another_start, :none => :another_first
  }
end
fsm.first_start

fsm.another_start # on another run
```
![Two Initial States](http://www.gliffy.com/go/publish/image/5897986/L.png)

According to 'UML state machine' semantics this is not a valid state machine because:

> The **initial transition** originates from the solid circle and specifies the default state when the system first begins. Every state diagram should have such a transition, which **should not be labeled, since it is not triggered by an event**.
> [Wikipedia on UML State Machines](http://en.wikipedia.org/wiki/UML_state_machine#Basic_UML_state_diagrams)

The equivalent correct state machine is:

![One Initial State](http://www.gliffy.com/go/publish/image/5898066/L.png)

* Explicit initial state using the `initial` clause. Initial state is `:first_applic

```ruby
fsm = FiniteMachine.define do
  initial :state => :first, :defer => true
end

  events {
  	event :start, :first => :second
  }

  callbacks {
    on_enter(:any) { |event| puts "Callback transitioning on #{event.name} from #{event.from} to #{event.to}" }
  }
end
```

* `initial` is not the (UML semantic) initial state; `none` is the initial state.
* A transition from `none` to the first (application) state (denoted with `

What is the rationale for deferring initial transition (from `none` to first application state)? If it is to be able to set the state without triggering callbacks then that can be achieved by the (new) `restore!` method (which simply sets the state without triggering callbacks).

References
* State Machine Diagrams, http://www.uml-diagrams.org/state-machine-diagrams.html
* Wikipedia: UML state machine, http://en.wikipedia.org/wiki/UML_state_machine#Basic_UML_state_diagrams
* UML Tutorial: Finite State Machines, Robert, C. Martin, http://www.objectmentor.com/resources/articles/umlfsm.pdf