all: compile run

compile:
	erlc -o ebin src/*.erl

clean:
	rm ebin/*.beam

run:
	erl -pa ebin
