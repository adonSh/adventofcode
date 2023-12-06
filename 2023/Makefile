EBIN  = ebin
SHELL = /bin/bash
OBJS  = $(shell echo $(EBIN)/Elixir.Day{01..05}.beam)

all: $(OBJS)

clean:
	rm -rf $(EBIN)/*.beam

run:
	elixir -pa $(EBIN) aoc23.exs $(day)

.SECONDEXPANSION:
$(EBIN)/Elixir.Day%.beam: $$*/day$$*.ex
	elixirc -o $(EBIN) $^
