#!/bin/bash
function updatearp(){
	if [ -n "$NETWORK" ]
	then
		for SUFIX in {1..254}
		do 
			ping -w 1 -c 1 $NETWORK.$SUFIX &>/dev/null &
	     	done
	else
		echo "[!] Missing Network in config files"
		exit 1
	fi

}
function checkifup(){
	CHECK=`arp -a | grep -i $1 | cut -d \( -f 2 | cut -d \) -f 1`
	if [ $CHECK ]  
	then
		echo $CHECK
	else
		echo "off"
	fi
}

function wakeup(){
	echo -e "[*] Wake Up Neo -> $1"
	wakeonlan $1

}
if [ -f ./config ]
then
	echo "[-] Loading the configs"
	source ./config
	if [ -n "$TARGETS" ] 
	then
		echo "[*] Updating the arp table"
		updatearp
		sleep 2
		for LINE in $TARGETS
			do
				UP=$(checkifup $LINE)
				if [ $UP == 'off' ]
				then
					wakeup $LINE
				else
					echo -e "[!] Host $LINE are already ON.\nIPv4: $UP"
					read -p "[*] Want to send anyway?[y/N]"
					if [ "$REPLY" == "y" ]
					then
						wakeup $LINE
					else
						echo "[-] Alright, bye sir"
					fi
				
				fi
			done 
		exit 0
	else
		echo "[*] Missing Targets in config file"
		exit 1
	fi
else
	echo "[*] Missing config file"
	exit 1
fi
