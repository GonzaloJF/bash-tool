#!/bin/bash

echo -e "**************************************"
echo -e "*                                    *"
echo -e "*          Network  Scanner          *"
echo -e "*                                    *"
echo -e "**************************************"

function ctrl_c(){
	echo -e "\n\n [+] Saliendo... \n\n"
	exit 1 && tput cnorm
}

tput civis

#ctrl + c
trap ctrl_c INT


usuario=$(whoami)

echo -e "[+] Estas usando el usuario: $usuario"

#nombre de la interfaz acritiva
interfaz=$(ip -br a | grep -w 'UP' | awk '$3 ~ /^[0-9]+\./ {print $1}')

Ip=$(ip -br a | awk -v iface="$interfaz" '$1 == iface {print $3}')

echo "my IP_address is: $Ip"

echo -e "La interfaz es: $interfaz"
#segmento para descubrir ips ocupadas: 

segmento_red=$(ip -br a | awk -v iface="$interfaz" '$1 == iface {print $3}' | cut -d'/' -f1 | awk -F'.' '{print $1"."$2"."$3"."}')

echo -e "el segmento de red es: $segmento_red"

function helpPanel(){
	echo -e "\n [+] Uso: "
	echo -e "-h => Para desplegar el menu de ayuda."
	echo -e "-p => Para poder desplegar el escaneo a traves de ping"
	echo -e "-a => Para poder desplegar el escaneo con la aplicacion arp-scan"
	echo -e "-n => Para poder desplegar el escaneo con netdiscover"
}

#indicadores: 
declare -i parameter_counter=0

function pingScanning(){
	segmento=$segmento_red
	for i in $( seq 1 254 ); do
		timeout 1 bash -c "ping -c 1 $segmento$i" &>/dev/null && echo "[+] HOST $segmento$i - ACTIVE"
	done
	wait
	tput cnorm
}

function arpScanning(){
	iface=$interfaz
	arp-scan -I $iface --localnet --ignoredups 
}

function netScanning(){
	iface=$interfaz
	netdiscover -i $iface
}

while getopts "panh" arg; do
	case $arg in
		p) let parameter_counter+=1;;
		a) let parameter_counter+=2;;
		n) let parameter_counter+=3;;
		h) helpPanel;;
	esac
done

if [ $usuario == "root" ]; then
	echo -e "estas usando el usuario $usuario"
	if [ $parameter_counter -eq 1 ]; then
		pingScanning
	elif [ $parameter_counter -eq 2 ]; then
		arpScanning
	elif [ $parameter_counter -eq 3 ]; then
		netScanning
	else
		helpPanel
	fi
	tput cnorm
else 
	echo -e "Vuelve a intenterlo cuando estes con el usuario ROOT"
	helpPanel
	tput cnorm
fi
