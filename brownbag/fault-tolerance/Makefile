APP_NAME := ch_app

all: compile
	
compile: clear
	@cp src/$(APP_NAME).app ebin/
	@erlc -pa ebin/ -o ebin/ src/*.erl
	
compile_test: compile
	@erlc -pa ebin/ -o ebin/ test/*.erl

shell:
	@erl -pa ebin/

start_a:
	@erl -name a@127.0.0.1 -config config/a -pa ebin -eval 'application:start(ch_app)'

start_b:
	@erl -name b@127.0.0.1 -config config/b -pa ebin -eval 'application:start(ch_app)'

start_c:
	@erl -name c@127.0.0.1 -config config/c -pa ebin -eval 'application:start(ch_app)'
run:
	@erl -pa ebin/ deps/**/ebin/ -sname $(APP_NAME) -s $(APP_NAME) \
	     -config priv/config/production

run_dev:
	@erl -pa ebin/ deps/**/ebin/ -sname $(APP_NAME) \
	     -boot start_sasl -s $(APP_NAME) \
	     -config priv/config/development

run_test: compile_test
	@erl -noshell -pa ebin/ deps/**/ebin/ -s $(APP_NAME) \
	     -run $(MODULE) test -run init stop \
	     -config priv/config/test

run_all_tests: compile_test
	@for fullfilename in `find ./test -name "*_test.erl"`; do \
		filename=$$(basename $$fullfilename); \
		module=$${filename%%.*}; \
		echo ; \
		echo running: $$module; \
		erl -noshell -pa ebin/ deps/**/ebin/ -s $(APP_NAME) \
		    -run $$module test -run init stop \
		    -config priv/config/test; \
	done

clear:
	@rm -f ebin/*.beam
	@rm -f erl_crash.dump
