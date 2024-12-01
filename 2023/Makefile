EBIN  = ebin
SHELL = /bin/bash
OBJS  = $(shell echo $(EBIN)/Elixir.Day{01..19}.beam)

all: $(OBJS)

clean:
	rm -rf $(EBIN)/*.beam

run: $(OBJS)
	elixir -pa $(EBIN) aoc23.exs $(day)

.SECONDEXPANSION:
$(EBIN)/Elixir.Day%.beam: $$*/day$$*.ex
	elixirc -o $(EBIN) $^
