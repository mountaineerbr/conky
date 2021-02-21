#!/bin/bash
# Restart conky regularly due to terrible memory leak with io ops
# `xscreensaver' may interfere with restarting conky properly
# v0.4.4  feb/2021  by mountaineerbr

# Alternatives: systemd timer, cron jobs
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

#period of time between restarts
RESTART=6
#unit of restart value (hour, min)
RESTART_UNIT=hour

#log file
LOGF="/tmp/conkykiller.sh.log"

#script path
SCRIPT_PATH="$0"
#script name
SCRIPT_NAME="${SCRIPT_PATH##*/}"


#demonise this script
if ((CDAEMON==0))
then
	export CDAEMON=1
	"$SCRIPT_PATH" & disown
	echo -e "$SCRIPT_NAME: warning: fork to background -- $!\n" >&2
	exit
fi

#kill other instances of this script
#either pid is own or send SIGTERM
for pid in $( pidof -x "$SCRIPT_NAME" )
do (( pid == $$ )) || pkill -P "$pid"
done
unset pid

#kill and restart loop
while true
do
	#check if `xscreensaver' has blanked the screen
	#while xscreensaver-command -time | grep -Fqi 'screen blanked'
	#do sleep 10
	#done
	if xscreensaver-command -time | grep -Fqi 'screen blanked'
	then
		while read
		do [[ "$REPLY" = UNBLANK* ]] && break
		done < <(xscreensaver-command -watch)
	fi

	#kill conky
	killall conky && sleep 2
	
	#launch conkies
	for c in "${CONFS[@]}"
	do conky --daemonize --pause=2 -X "${DISPLAY}" -c "$c" || break 2
	done
	#-d daemonises conky
	#-c configuration file
	#-p time to pause before actually starting conky
	#--display X11 display to use

	#feedback
	echo -e "\n$SCRIPT_NAME: conky restart in ${RESTART}${RESTART_UNIT}s ($( date -Isec -d${RESTART}${RESTART_UNIT} ))"

	#sleep
	sleep ${RESTART}${RESTART_UNIT:0:1}

done | tee -a "$LOGF" >&2
#done  2>&1 | tee -a "$LOGF" >&2

