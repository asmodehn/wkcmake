#!/bin/bash
set -x
TMP_FILE=/tmp/jekyll_test_run
touch $TMP_FILE
( bundle exec jekyll server & echo $! >&3 ) 3>JEKYLL_PID | tee $TMP_FILE &
#runnin jekyll server for test 
#give time to ruby
sleep 1
#and waiting for the proper message to start browser
jekyll_result="KO"
while read line; do
	if [[ $line =~ "Server running" ]]; then
		jekyll_result="OK"
		break
	#TODO : put error string from jekyll server here to break
	#and not launch the browser
	elif [[ $line == "ERROR" ]]; then
		break
	fi
done < $TMP_FILE
#running browser in terminal and wait for it to be closed
if [[ $jekyll_result == "OK" ]]; then
	w3m "http://127.0.0.1:4000"
fi

#cleanup
rm $TMP_FILE
kill $(<JEKYLL_PID) 
