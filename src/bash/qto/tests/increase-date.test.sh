# src/bash/qto/funcs/increase-date.test.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doTestIncreaseDate comments ...
# ---------------------------------------------------------
doTestIncreaseDate(){
   
   set -eu
	doLog "DEBUG START doTestIncreaseDate"
	
	cat doc/txt/qto/tests/increase-date.test.txt
	
	sleep "$sleep_interval"
   bash src/bash/qto/qto.sh -a increase-date
   test $exit_code -ne 0 && return
 
	# add your action implementation code here ... 
	# Action !!!
	doLog "DEBUG STOP  doTestIncreaseDate"
}
# eof func doTestIncreaseDate


# eof file: src/bash/qto/funcs/increase-date.test.sh