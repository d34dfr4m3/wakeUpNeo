#!/bin/bash
#######################################- FUNCTIONS -###################################
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

function usage(){
	echo " Usage: $0 {options} 
		-u -> Do no check with hosts are online
		-H -> Define the host to send the magic packet, the host must exist in the config file
		
		Without options the script will check with the hosts are online and wake up all"
	exit 0
	
}
#######################################- MAIN -#####################################
UPDATEARP=true
while getopts "uH:" OPT
do
	case $OPT in
		u)
			UPDATEARP=false
		;;
		
		H) 	wakeup `grep ${OPTARG} config | cut -d '=' -f 2 ` 
			exit 0
		;;
		
		*) 	echo "[*] Usage Error"
			usage
		;;
	esac
done

if [ -f ./config ]
then
	echo "[-] Loading the configs"
	source ./config
	TARGETS=`sed  '0,/Hosts/ d' config | cut -d '=' -f 1`
	if [ -n "$TARGETS" ] 
	then
		if [ !  $UPDATEARP == 'false' ]
		then	
			echo "[*] Updating the arp table"
			updatearp
			sleep 2
		fi
		for LINE in `for x in $TARGETS; do grep $x config | cut -d '=' -f 2; done`
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
