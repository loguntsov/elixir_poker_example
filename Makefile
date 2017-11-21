all:
	mix

.PHONY: run
run:
	iex -S mix

.PHONY: test
test:
	mix test