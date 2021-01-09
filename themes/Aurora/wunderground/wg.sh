#!/bin/bash
#version : v2.6.2

#EDIT
#put your hemisphere here: n for north, s for south
hemisphere=n
#STOP EDIT

#put your Weather Underground address API here
#ask your api at http://api.wunderground.com/
#it is free for a limited amount of calls PLEASE DO NOT KEEP USING MINE!!
#    2d1607634da9eeff    is my personal API

address="http://api.wunderground.com/api/2d1607634da9eeff/conditions/forecast10day/astronomy/hourly/satellite/q/Belgium/antwerp.json"

wun_icon_to_svg () {
    if [[ $1 == day ]]; then
        case $2 in
            chanceflurries)
                echo 21
            ;;
            chancerain)
                echo 14
            ;;
            chancesleet)
                echo 26
            ;;
            chancesnow)
                echo 20
            ;;
            chancetstorms)
                echo 17
            ;;
            clear)
                echo 1
            ;;
            cloudy)
                echo 7
            ;;
            flurries)
                echo 23
            ;;
            fog)
                echo 11
            ;;
            hazy)
                echo 5
            ;;
            mostlycloudy)
                echo 6
            ;;
            mostlysunny)
                echo 4
            ;;
            partlycloudy)
                echo 4
            ;;
            partlysunny)
                echo 6
            ;;
            sleet)
                echo 26
            ;;
            rain)
                echo 18
            ;;
            snow)
                echo 22
            ;;
            sunny)
                echo 1
            ;;
            tstorms)
                echo 15
            ;;
            unknown)
                echo 0
            ;;
        esac
    elif [[ $1 == night ]]; then
        case $2 in
            chanceflurries)
                echo 43
            ;;
            chancerain)
                echo 39
            ;;
            chancesleet)
                echo 40
            ;;
            chancesnow)
                echo 43
            ;;
            chancetstorms)
                echo 41
            ;;
            clear)
                echo 33
            ;;
            cloudy)
                echo 38
            ;;
            flurries)
                echo 45
            ;;
            fog)
                echo 46
            ;;
            hazy)
                echo 37
            ;;
            mostlycloudy)
                echo 36
            ;;
            mostlysunny)
                echo 35
            ;;
            partlycloudy)
                echo 47
            ;;
            partlysunny)
                echo 48
            ;;
            sleet)
                echo 50
            ;;
            rain)
                echo 49
            ;;
            snow)
                echo 44
            ;;
            sunny)
                echo 33
            ;;
            tstorms)
                echo 51
            ;;
            unknown)
                echo 0
            ;;
        esac
    fi
    }

rm $HOME/.conky/Aurora/wunderground/cache/*.png

killall -STOP conky
killall wget

wget -O $HOME/.conky/Aurora/wunderground/raw_data $address

#Conditions feature
sed -n '/,	"current_observation": {/,/,	"satellite": {/p' $HOME/.conky/Aurora/wunderground/raw_data > $HOME/.conky/Aurora/wunderground/Conditions
sed -i 's/^[ \t]*"//g' $HOME/.conky/Aurora/wunderground/Conditions
sed -i '/current_observation\|image":\|logo_\|title":\|link":\|^[ \t]*},$\|^[ \t]*}$\|temperature_string\|forecast_url\|history_url\|ob_url\|satellite":/d' $HOME/.conky/Aurora/wunderground/Conditions
sed -i -e 's/":"/\n/g' -e 's/",\|": {$//g' -e 's/"precip_1hr_string/\nprecip_1hr_string/g' -e 's/":/\n/g' -e 's/,$//g' $HOME/.conky/Aurora/wunderground/Conditions
sed -i -e 's/^http.*\/c\/k\///g' -e '/gif/s/_.*$//g' $HOME/.conky/Aurora/wunderground/Conditions
day_or_night=$(sed -n 137p $HOME/.conky/Aurora/wunderground/Conditions)
if [[ $day_or_night == nt ]]; then
	cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg night $(sed -n 135p $HOME/.conky/Aurora/wunderground/Conditions)).png $HOME/.conky/Aurora/wunderground/cache/Now.png
else 
	cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg day $(sed -n 135p $HOME/.conky/Aurora/wunderground/Conditions)).png $HOME/.conky/Aurora/wunderground/cache/Now.png
fi

#Forecast feature: Forecast
sed -n '/"forecast":{/,/"simpleforecast": {/p' $HOME/.conky/Aurora/wunderground/raw_data > $HOME/.conky/Aurora/wunderground/Forecast
sed -i -e '/"period":\|icon_url/d' $HOME/.conky/Aurora/wunderground/Forecast
sed -i 's/^[ \t]*"//g' $HOME/.conky/Aurora/wunderground/Forecast
sed -i -e '/period\|icon\|title\|fcttext/!d' -e 's/":"/\n/g' -e 's/":/\n/g' -e 's/",//g' -e 's/,$//g' -e 's/nt_//g' $HOME/.conky/Aurora/wunderground/Forecast

#Forecast feature: Simple Forecast
sed -n '/"simpleforecast": {/,/"hourly_forecast": \[/p' $HOME/.conky/Aurora/wunderground/raw_data > $HOME/.conky/Aurora/wunderground/Simple_Forecast
sed -i 's/^[ \t]*"//g' $HOME/.conky/Aurora/wunderground/Simple_Forecast
sed -i '/hourly_forecast\|simpleforecast\|forecastday\|{"date"\|period\|icon_url\|^[ \t]*},$\|^[ \t]*}$\|^[ \t]*,$\|^[ \t]*\]$/d' $HOME/.conky/Aurora/wunderground/Simple_Forecast
sed -i -e 's/":"/\n/g' -e 's/":/\n/g' -e 's/",$//g' -e 's/,$//g' -e 's/"$//g' $HOME/.conky/Aurora/wunderground/Simple_Forecast
sed -i '/^[ \t]*{/d' $HOME/.conky/Aurora/wunderground/Simple_Forecast
sed -i -e 's/^[ \t]*"//g' -e 's/^[ \t]*//g' $HOME/.conky/Aurora/wunderground/Simple_Forecast
for (( i=2; i<=146; i+=16 ))
    do
        cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg day $(sed -n ${i}p $HOME/.conky/Aurora/wunderground/Forecast)).png $HOME/.conky/Aurora/wunderground/cache/d$(( 1+(i-2)/16 )).png
        j=$(( i+8 ))
        cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg night $(sed -n ${j}p $HOME/.conky/Aurora/wunderground/Forecast)).png $HOME/.conky/Aurora/wunderground/cache/n$(( 1+(i-2)/16 )).png
    done

#Forecast feature: Hourly
sed -n '/"hourly_forecast": \[/,/"moon_phase": {/p' $HOME/.conky/Aurora/wunderground/raw_data > $HOME/.conky/Aurora/wunderground/Hourly
sed -i -e 's/^[ \t]*"//g' -e 's/^[ \t]*//g' $HOME/.conky/Aurora/wunderground/Hourly
sed -i '/hourly_forecast\|FCTTIME\|^{$\|^},$\|^}$\|^,$\|^]$\|moon_phase/d' $HOME/.conky/Aurora/wunderground/Hourly
sed -i -e 's/": /\n/g' -e 's/","/\n/g' -e 's/", "/\n/g' $HOME/.conky/Aurora/wunderground/Hourly
sed -i -e 's/^""//g' -e 's/^"//g' -e 's/^{"//g' -e 's/"},$//g' -e 's/",$//g' $HOME/.conky/Aurora/wunderground/Hourly 
sed -i -e 's/^},//g' -e 's/"}$//g' -e 's/^,//g' $HOME/.conky/Aurora/wunderground/Hourly
sed -i -e 's/^icon_url.*\/c\/k\///g' -e '/gif/s/_.*$//g' $HOME/.conky/Aurora/wunderground/Hourly
sed -i -e '/min_unpadded\|UTCDATE/,+1d' $HOME/.conky/Aurora/wunderground/Hourly
for (( i=64; i<=4212; i+=117 ))
    do
		j=$(( i+1 ))
		day_or_night=$(sed -n ${j}p $HOME/.conky/Aurora/wunderground/Hourly)
		if [[ $day_or_night == nt ]]; then
			cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg night $(sed -n ${i}p $HOME/.conky/Aurora/wunderground/Hourly)).png $HOME/.conky/Aurora/wunderground/cache/h$(( 1+(i-64)/117 )).png
		else 
			cp $HOME/.conky/Aurora/wunderground/Forecast_Images/$(wun_icon_to_svg day $(sed -n ${i}p $HOME/.conky/Aurora/wunderground/Hourly)).png $HOME/.conky/Aurora/wunderground/cache/h$(( 1+(i-64)/117 )).png
		fi
    done
    
#Forecast feature: Moon_Sun
sed -n '/"moon_phase": {/,/"sun_phase": {/p' $HOME/.conky/Aurora/wunderground/raw_data > $HOME/.conky/Aurora/wunderground/Moon_Sun
sed -i 's/^[ \t]*"//g' $HOME/.conky/Aurora/wunderground/Moon_Sun
sed -i '/moon_phase\|^[ \t]*},$\|sun_phase\|^[ \t]*}$/d' $HOME/.conky/Aurora/wunderground/Moon_Sun
sed -i -e 's/":"/\n/g' -e 's/".*$//g' $HOME/.conky/Aurora/wunderground/Moon_Sun
moon_phase=$(sed -n 6p $HOME/.conky/Aurora/wunderground/Moon_Sun)
if [[ $moon_phase == "Waning Crescent" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"21.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "Waxing Crescent" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"04.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "Waning Gibbous" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"17.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "Waxing Gibbous" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"09.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "First Quarter" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"07.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "Last Quarter" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"19.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "New Moon" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"24.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
elif [[ $moon_phase == "Full Moon" ]]; then
	cp $HOME/.conky/Aurora/wunderground/moonicons/$hemisphere"13.png" $HOME/.conky/Aurora/wunderground/cache/Moon_phase.png
fi

killall -CONT conky
