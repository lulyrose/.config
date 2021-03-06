#!/bin/bash

#xrandr --output HDMI-0 --auto --output eDP --off
#xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode Virtual-1 1920x1080
#xrandr -s 1920x1080

xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keycode 9 = Caps_Lock'
xmodmap -e 'keycode 66 = Escape'
xmodmap -e 'remove Lock = Caps_Lock'

flameshot &
picom -b
#feh --bg-fill ~/Pictures/Arch-1.jpg
feh --bg-fill ~/Pictures/Nord.png

show_date(){
				date="$(date +"%a, %b %d %R")"
				echo "  $date "
}

show_mem(){
				memUse="$(free -m | awk '/Mem:/ {print $3}')"	
				memTotal="$(free -m | awk '/Mem:/ {print $2}')"
				mem="$(echo "$memUse $memTotal" | awk '{printf ("%.2f\n",$1/$2*100)}')"
				echo "  $mem%"
}

kernel(){
      	kernel="$(uname -sr | sed "s/-arch2-1//g")"
	      echo $kernel
}

status_wifi(){
	wifiStatus="$(nmcli device | grep "wifi" |awk 'NR==1{print $3}')"
	if [[ $wifiStatus == "connected" ]]; then
		icon="直"
		wifiName="$(nmcli device | grep "wifi" |awk 'NR==1{print $4}')"
		echo "$icon $wifiName"
	else
		icon="睊"
		echo "$icon"
	fi
}

show_battery(){
	batt="$(acpi -b | awk '{ print $4 }' | tr -d ',' | tr -d '%')"
	charging="$(acpi -b | awk '{ print $3 }' | tr -d ',')"

	if [[ $charging == "Charging" ]]; then
		if [[ "$batt" -le "5" ]]; then
			icon=""
		elif [[ "$batt" -gt "5" && "$batt" -le "20" ]]; then
			icon=""
		elif [[ "$batt" -gt "20" && "$batt" -le "50" ]]; then
			icon=""
		elif [[ "$batt" -gt "50" && "$batt" -le "80" ]]; then
			icon=""
		elif [[ "$batt" -gt "80" && "$batt" -le "99" ]]; then
			icon=""
		else
			icon=""
		fi
	else
		if [[ "$batt" -le "5" ]]; then
			icon=""
		elif [[ "$batt" -gt "5" && "$batt" -le "20" ]]; then
			icon=""
		elif [[ "$batt" -gt "20" && "$batt" -le "50" ]]; then
			icon=""
		elif [[ "$batt" -gt "50" && "$batt" -le "80" ]]; then
			icon=""
		elif [[ "$batt" -gt "80" && "$batt" -le "99" ]]; then
			icon=""
		else
			icon=""
		fi
	fi
	echo "$icon $batt%"
}

status_bar(){
	echo "  $(kernel) | $(show_mem) | $(show_volume) | $(show_battery) | $(status_wifi) | $(show_date)"
}

show_volume(){

	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"

	if [[ "$volume" -eq "0" ]]; then
		icon="ﱝ"
	elif [[ "$volume" -gt "70" ]]; then
			icon=""
	else
			icon=""
	fi

	echo "$icon  $volume%"
}

while true; do
				xsetroot -name "$(status_bar)"
				sleep 1
done
