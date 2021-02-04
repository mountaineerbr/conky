#!/bin/bash
# v0.2.6  feb/2021  by mountaineerbr
# restart conky regularly due to terrible memory leak with io ops

# alternatives: systemd timer or cron jobs
# https://forums.freebsd.org/threads/is-conky-leaking-memory.24197/
# https://unix.stackexchange.com/questions/213288/killing-the-previous-instances-of-a-script-before-running-the-same-unix-script


#load user confs (conkies)
CONFS=(
	"$HOME/.config/conky/confs/aurora_ds_sensors.conf"
	"$HOME/.config/conky/confs/rss_long1.conf"
	"$HOME/.config/conky/confs/rss_short1.conf"
	"$HOME/.config/conky/confs/rss_short2.conf"
	"$HOME/.config/conky/confs/calendar.conf"
	"$HOME/.config/conky/confs/todo.conf"
	"$HOME/.config/conky/confs/aurora_allinone.conf"
)

#restart every period of time
#integer, hours
RESTART=6

#log file
LOGF="/tmp/conkykiller.sh.log"

#script path
SCRIPT_PATH="$0"
#script name
SCRIPT_NAME="${SCRIPT_PATH##*/}"


#demonise this script
if (( KDAEMON == 0 ))
then
	KDAEMON=1
	export KDAEMON

	"$SCRIPT_PATH" &
	
	printf '%s: warning: forked to background -- %s\n\n' "${0##*/}" "$!" >&2
	disown
	
	exit 0
fi

#kill other instances of this script
for pid in $( pidof -x "$SCRIPT_NAME" )
do
	#either pid is own or send SIGTERM
	(( pid == $$ )) || kill -15 "$pid"
done
unset pid

#kill and restart loop
while true
do
	#kill conky
	killall conky
	
	#launch conkies
	for conf in "${CONFS[@]}"
	do
		#flag -d daemonises conky
		#flag -c configuration file
		conky -dc "$conf"  
		sleep 1
	done

	#log
	printf '%s: conky restart in %s hours (%s)\n' "$SCRIPT_NAME" "$RESTART" "$( date -Isec -d${RESTART}hours )"

	#sleep
	sleep ${RESTART}h

done | tee -a "$LOGF" >&2

