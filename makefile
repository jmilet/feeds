all: compile

compile:
	erlc -o ebin src/*.erl

clean:
	rm ebin/*.beam

run: compile
	erl -pa ebin -eval "application:start(feeds)"
