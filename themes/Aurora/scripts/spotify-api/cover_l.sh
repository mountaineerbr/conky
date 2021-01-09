#!/bin/bash
# Based on the source : https://github.com/Madh93/conky-spotify/tree/master/scripts
# Rewritten by Erik Dubois  http://www.erikdubois.be
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.
# path="~/.conky/Aurora/scripts/spotify-api" - Path will not work
# make use of the api from spotify for developers

#get the current song and put in varible
new_trackid=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "trackid" | grep variant | awk {'print $NF'} | cut -d ':' -f3 | cut -d '"' -f 1`
first_trackid=$(cat ~/.conky/Aurora/scripts/spotify-api/first_trackid)
#if the old song and the new song are the same - do nothing
#or if the old song and the new song are not the same 
#then the song has changed - get a new album cover	
		if [ "$new_trackid" != "$first_trackid" ];  then
			#different sizes
			#we get the imgcurl by chopping the response of the api to the specific new_trackid
			#xxl size 640x640
			#imgurl=`curl -X GET https://api.spotify.com/v1/tracks/$new_trackid | grep '"url" : ' | sed '1q;d' | cut -d '"' -f4`
			#xl size 320x320
			#imgurl=`curl -X GET https://api.spotify.com/v1/tracks/$new_trackid | grep '"url" : ' | sed '2q;d' | cut -d '"' -f4`
			#l size 64x64
			imgurl=`curl -X GET https://api.spotify.com/v1/tracks/$new_trackid | grep '"url" : ' | sed '3q;d' | cut -d '"' -f4`
			wget -O   ~/.conky/Aurora/scripts/spotify-api/lastpic_l $imgurl
			first_trackid=$new_trackid
			echo $first_trackid > ~/.conky/Aurora/scripts/spotify-api/first_trackid
		fi