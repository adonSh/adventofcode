EXE = aoc23.exs
EBIN = ebin

all: $(wildcard */*.ex)
	elixirc -o $(EBIN) $^

run:
	elixir -pa $(EBIN) $(EXE) $(day)

clean:
	rm -rf $(EBIN)/*.beam
