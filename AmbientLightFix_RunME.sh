#!/bin/bash
SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
#echo $SOURCE;
while true; do
	read -p "
	-------------------------| About |--------------------------------
	This is a combinated install/update/uninstall -script.

	* If this is the first time it will copy Ambient Light Fix to
	/usr/bin and then add it to systemd so it will be started
	automatically after each reboot.

	* If you already have Ambient Light Fix this script will find it
	and either help you uninstall or update it.
	------------------------------------------------------------------

	Continue? (y/n) " yn
	case $yn in
	[Yy]*)
		echo
		echo "
		Great, let's do it!"
		echo
		break
		;;
	[Nn]*)
		echo
		echo "
		... ok, you were supposed to hit Y :-/"
		echo
		exit
		;;
	*)
		echo
		echo "
		! You must answer something I understand...  - Y or N"
		echo
		;;
	esac

done

if [ -f "/sys/bus/iio/devices/iio:device0/in_illuminance_raw" ]; then
	echo "
		--------------------------------------------
		*** Things are looking up - Found sensor ***
		--------------------------------------------"
	sleep 1
	echo
else
	echo "
		-------------------------------------------------
		| No sensors here... AmbientLightFix won't be	|
		| able to run on your machine :-(		|
		-------------------------------------------------"
	exit
fi

if [ -f "/sys/class/backlight/gmux_backlight/brightness" ]; then

	# Letar efter existerande lightfix och erbjuder avinstallation eller uppdatering
	if [ -f "/usr/bin/ambientLightFix_gmux" ]; then
		while true; do
			read -p "
		-------| Found existing Ambient Light Fix! |-------
		Do you want to Uninstall [1] Ambient Light Fix...
		... or do you want to Update [2] to a newer version?
		---------------------------------------------------
					" gmux
			case $gmux in
			[1]*)
				echo
				systemctl stop ambientLightFix_gmux.service
				sudo sh -c "rm /usr/bin/ambientLightFix_gmux"
				systemctl disable ambientLightFix_gmux.service
				sudo sh -c "rm /etc/systemd/system/ambientLightFix_gmux.service"
				echo "
		---------------| Uninstalled! |----------------"
				echo
				break
				;;
			[2]*)
				echo
				systemctl stop ambientLightFix_gmux.service
				sudo sh -c "rm /usr/bin/ambientLightFix_gmux"
				sudo sh -c "cp '$SOURCE'/ambientLightFix_gmux /usr/bin/ambientLightFix_gmux"
				systemctl start ambientLightFix_gmux.service
				echo "
		-----------------| Updated! |------------------"
				echo
				break
				;;
			*)
				echo
				echo "
		-------------
		! type 1 or 2
		-------------"
				echo
				;;
			esac
		done
	else

		echo "
		------------------
		*** found gmux ***
		------------------
				"

		echo "
		-> Will test changing brightness before installation...
				"
		echo
		sleep 1
		echo "
		-> Current brightness: "
		cat /sys/class/backlight/gmux_backlight/brightness
		sleep 1
		echo "
		-> Setting brightness to 50, then step up to 500...
				"
		sleep 3
		sudo sh -c "echo 50 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 100 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 150 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 200 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 250 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 300 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 350 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 400 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 450 > /sys/class/backlight/gmux_backlight/brightness"
		sleep 1
		sudo sh -c "echo 500 > /sys/class/backlight/gmux_backlight/brightness"
		echo "
				->Current brightness: "
		cat /sys/class/backlight/gmux_backlight/brightness
		sleep 1
		echo "
		---------------------------------
		... Everything good so far!
		Let's start setting things up :-)
		---------------------------------
				"
		echo
		echo
		echo "
		---------------------
		*** Copying files ***
		---------------------
				"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_gmux /usr/bin/ambientLightFix_gmux"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_gmux.service /etc/systemd/system/ambientLightFix_gmux.service"
		echo
		sleep 1
		echo "
		------------------
		*** Setting up ***
		------------------
				"
		systemctl enable ambientLightFix_gmux.service
		echo
		echo "
		------------
		*** Done ***
		------------
				"
		echo
		while true; do
			read -p "
		-----------------| All set! |---------------
		You wanna start Ambient Light Fix now? (y/n)
		--------------------------------------------
					" gmux_start
			case $gmux_start in
			[Yy]*)
				echo
				echo "
		--------------| Congratulations! |---------------
		You're all done! You can close this terminal now.
		-------------------------------------------------
						"
				systemctl start ambientLightFix_gmux.service
				break
				;;
			[Nn]*)
				echo
				echo "
		---------------------| OK |----------------------
		Ambient Light Fix will start next time you reboot
		-------------------------------------------------
						"
				echo
				exit
				;;
			esac
		done
		echo "Done :-)"
	fi

else
	echo "
		-------------------------------------------
		No hybrid graphics here - checking Radeon...
		-------------------------------------------
		"
	echo
	sleep 1
fi

if [ -f "/sys/class/backlight/radeon_bl0/brightness" ]; then

	# Letar efter existerande lightfix och erbjuder avinstallation eller uppdatering
	if [ -f "/usr/bin/ambientLightFix_radeon" ]; then
		while true; do
			read -p "
		-------| Found existing Ambient Light Fix! |-------
		Do you want to Uninstall [1] Ambient Light Fix...
		... or do you want to Update [2] to a newer version?
		---------------------------------------------------
					" radeon
			case $radeon in
			[1]*)
				echo
				systemctl stop ambientLightFix_radeon.service
				sudo sh -c "rm /usr/bin/ambientLightFix_radeon"
				systemctl disable ambientLightFix_radeon.service
				sudo sh -c "rm /etc/systemd/system/ambientLightFix_radeon.service"
				echo "
		---------------| Uninstalled! |----------------"
				echo
				break
				;;
			[2]*)
				echo
				systemctl stop ambientLightFix_radeon.service
				sudo sh -c "rm /usr/bin/ambientLightFix_radeon"
				sudo sh -c "cp '$SOURCE'/ambientLightFix_radeon /usr/bin/ambientLightFix_radeon"
				systemctl start ambientLightFix_radeon.service
				echo "
		-----------------| Updated! |------------------"
				echo
				break
				;;
			*)
				echo
				echo "
		-------------
		! type 1 or 2
		-------------"
				echo
				;;
			esac
		done
	else

		echo "
		------------------
		*** found radeon ***
		------------------
				"

		echo "
		-> Will test changing brightness before installation...
				"
		echo
		sleep 1
		echo "
		-> Current brightness: "
		cat /sys/class/backlight/radeon_bl0/brightness
		sleep 1
		echo "
		-> Setting brightness to 50, then step up to 500...
				"
		sleep 3
		sudo sh -c "echo 50 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 100 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 150 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 200 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 250 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 300 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 350 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 400 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 450 > /sys/class/backlight/radeon_bl0/brightness"
		sleep 1
		sudo sh -c "echo 500 > /sys/class/backlight/radeon_bl0/brightness"
		echo "
				->Current brightness: "
		cat /sys/class/backlight/radeon_bl0/brightness
		sleep 1
		echo "
		---------------------------------
		... Everything good so far!
		Let's start setting things up :-)
		---------------------------------
				"
		echo
		echo
		echo "
		---------------------
		*** Copying files ***
		---------------------
				"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_radeon /usr/bin/ambientLightFix_radeon"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_radeon.service /etc/systemd/system/ambientLightFix_radeon.service"
		echo
		sleep 1
		echo "
		------------------
		*** Setting up ***
		------------------
				"
		systemctl enable ambientLightFix_radeon.service
		echo
		echo "
		------------
		*** Done ***
		------------
				"
		echo
		while true; do
			read -p "
		-----------------| All set! |---------------
		You wanna start Ambient Light Fix now? (y/n)
		--------------------------------------------
					" radeon_start
			case $radeon_start in
			[Yy]*)
				echo
				echo "
		--------------| Congratulations! |---------------
		You're all done! You can close this terminal now.
		-------------------------------------------------
						"
				systemctl start ambientLightFix_radeon.service
				break
				;;
			[Nn]*)
				echo
				echo "
		---------------------| OK |----------------------
		Ambient Light Fix will start next time you reboot
		-------------------------------------------------
						"
				echo
				exit
				;;
			esac
		done
		echo "Done :-)"
	fi

else
	echo "
		-------------------------------------------
		No Radeon graphics here - checking Intel...
		-------------------------------------------
		"
	echo
	sleep 1
fi

if [ -f "/sys/class/backlight/intel_backlight/brightness" ]; then

	# Letar efter existerande lightfix och erbjuder avinstallation eller uppdatering
	if [ -f "/usr/bin/ambientLightFix_intel" ]; then
		while true; do
			read -p "
		--------| Found existing Ambient Light Fix! |-------
		Do you want to Uninstall [1] Ambient Light Fix...
		... or do you want to Update [2] to a newer version?
		----------------------------------------------------
					" intel
			case $intel in
			[1]*)
				echo
				systemctl stop ambientLightFix_intel.service
				sudo sh -c "rm /usr/bin/ambientLightFix_intel"
				systemctl disable ambientLightFix_intel.service
				sudo sh -c "rm /etc/systemd/system/ambientLightFix_intel.service"
				echo "
		------------|	Uninstalled! |------------
		"
				echo
				break
				;;
			[2]*)
				echo
				systemctl stop ambientLightFix_intel.service
				sudo sh -c "rm /usr/bin/ambientLightFix_intel"
				sudo sh -c "cp '$SOURCE'/ambientLightFix_intel /usr/bin/ambientLightFix_intel"
				systemctl start ambientLightFix_intel.service
				echo "
		--------|	Updated! |--------
		" echo
				break
				;;
			*)
				echo "
		-----------------
		! type one or two
		-----------------
						"
				echo
				;;
			esac
		done
	else

		echo "
		-------------------
		*** found intel ***
		-------------------
				"
		echo "
		-> Will test changing brightness before installation...
				"
		echo
		sleep 1
		echo "
		-> Current brightness: "
		cat /sys/class/backlight/intel_backlight/brightness
		sleep 1
		echo "
		-> Setting brightness to 50, then step up to 500...
				"
		sleep 3
		sudo sh -c "echo 50 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 100 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 150 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 200 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 250 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 300 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 350 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 400 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 450 > /sys/class/backlight/intel_backlight/brightness"
		sleep 1
		sudo sh -c "echo 500 > /sys/class/backlight/intel_backlight/brightness"
		echo "
		-> Current brightness: "
		cat /sys/class/backlight/intel_backlight/brightness
		sleep 1
		echo "
		---------------------------------
		... Everything good so far.
		Let's start setting things up :-)
		---------------------------------
				"
		echo
		echo
		echo "
		---------------------
		*** Copying files ***
		---------------------
				"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_intel /usr/bin/ambientLightFix_intel"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_intel.service /etc/systemd/system/ambientLightFix_intel.service"
		echo
		sleep 1
		echo "
		------------------
		*** Setting up ***
		------------------
				"
		systemctl enable ambientLightFix_intel.service
		echo
		echo "
		------------
		*** Done ***
		------------
				"
		echo
		while true; do
			read -p "
		------------------| All set |---------------
		You wanna start Ambient Light Fix now? (y/n)
		--------------------------------------------
					" intel_start
			case $intel_start in
			[Yy]*)
				echo
				echo "
		----------------| Congratulations |--------------
		You're all done! You can close this terminal now.
		-------------------------------------------------
						"
				systemctl start ambientLightFix_intel.service
				break
				;;
			[Nn]*)
				echo
				echo "
		----------------------| OK |---------------------
		Ambient Light Fix will start next time you reboot
		-------------------------------------------------
						"
				echo
				exit
				;;
			esac
		done
		echo "Done :-)"

	fi

else
	echo "
		-------------------------------------------
		No Intel graphics here - checking AMDgpu...
		-------------------------------------------
		"
	echo
	sleep 1
fi

if [ -f "/sys/class/backlight/amdgpu_bl1/brightness" ]; then

	# Letar efter existerande lightfix och erbjuder avinstallation eller uppdatering
	if [ -f "/usr/bin/ambientLightFix_amdgpu" ]; then
		while true; do
			read -p "
		--------| Found existing Ambient Light Fix! |-------
		Do you want to Uninstall [1] Ambient Light Fix...
		... or do you want to Update [2] to a newer version?
		----------------------------------------------------
					" amdgpu
			case $amdgpu in
			[1]*)
				echo
				systemctl disable --now ambientLightFix_amdgpu.service
				sudo sh -c "rm /usr/bin/ambientLightFix_amdgpu"
				sudo sh -c "rm /etc/systemd/system/ambientLightFix_amdgpu.service"
				echo "
		------------|	Uninstalled! |------------
		"
				echo
				break
				;;
			[2]*)
				echo
				systemctl stop ambientLightFix_amdgpu.service
				sudo sh -c "rm /usr/bin/ambientLightFix_amdgpu"
				sudo sh -c "cp '$SOURCE'/ambientLightFix_amdgpu /usr/bin/ambientLightFix_amdgpu"
				systemctl start ambientLightFix_amdgpu.service
				echo "
		--------|	Updated! |--------
		" echo
				break
				;;
			*)
				echo "
		-----------------
		! type one or two
		-----------------
						"
				echo
				;;
			esac
		done
	else

		echo "
		-------------------
		*** found intel ***
		-------------------
				"
		echo "
		-> Will test changing brightness before installation...
				"
		echo
		sleep 1
		echo -n "
		-> Current brightness: "
		cat /sys/class/backlight/amdgpu_bl1/brightness
		sleep 1
		echo "
		-> Setting brightness to 50, then step up to 500...
				"
		sleep 3
		sudo sh -c "echo 50 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 100 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 150 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 200 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 250 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 300 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 350 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 400 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 450 > /sys/class/backlight/amdgpu_bl1/brightness"
		sleep 1
		sudo sh -c "echo 500 > /sys/class/backlight/amdgpu_bl1/brightness"
		echo -n "
		-> Current brightness: "
		cat /sys/class/backlight/amdgpu_bl1/brightness
		sleep 1
		echo "
		---------------------------------
		... Everything good so far.
		Let's start setting things up :-)
		---------------------------------
				"
		echo
		echo
		echo "
		---------------------
		*** Copying files ***
		---------------------
				"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_amdgpu /usr/bin/ambientLightFix_amdgpu"
		sudo sh -c "cp '$SOURCE'/ambientLightFix_amdgpu.service /etc/systemd/system/ambientLightFix_amdgpu.service"
		echo
		sleep 1
		echo "
		------------------
		*** Setting up ***
		------------------
				"
		systemctl enable ambientLightFix_amdgpu.service
		echo
		echo "
		------------
		*** Done ***
		------------
				"
		echo

		while true; do
			read -p "
		------------------------| All set |------------------------
		You wanna configure Ambient Light Fix for AMDgpu now? (y/n)
		-----------------------------------------------------------
					" amdgpu_start
			case $amdgpu_start in
			[Yy]*)
				echo
				echo "
		----------------| Reminder |--------------
		Read out the help for configuration below.
		------------------------------------------
						"
				sh -c "bash '$SOURCE'/ambientLightFix_amdgpu --full-help"
				read -p "
		------------------| Reminder |----------------
		Change startup flags in service configuration.
		----------------------------------------------
						"
				sudo systemctl edit --full ambientLightFix_amdgpu.service
				break
				;;
			[Nn]*)
				echo
				echo "
		---------------------------| OK |---------------------------
		Ambient Light Fix for AMDgpu will work with default settings
		------------------------------------------------------------
						"
				echo
				exit
				;;
			esac
		done

		while true; do
			read -p "
		------------------| All set |---------------
		You wanna start Ambient Light Fix now? (y/n)
		--------------------------------------------
					" intel_start
			case $intel_start in
			[Yy]*)
				echo
				echo "
		----------------| Congratulations |--------------
		You're all done! You can close this terminal now.
		-------------------------------------------------
						"
				systemctl start ambientLightFix_amdgpu.service &
				break
				;;
			[Nn]*)
				echo
				echo "
		----------------------| OK |---------------------
		Ambient Light Fix will start next time you reboot
		-------------------------------------------------
						"
				echo
				exit
				;;
			esac
		done
		echo "Done :-)"

	fi

else
	echo "
		----------| Something didn't go as expected|--------
		... Ok, this is weird. Didn't find any AMDgpu either.
		Report this to hackan!
		----------------------------------------------------
		"
fi
