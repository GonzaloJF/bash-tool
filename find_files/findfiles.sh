#!/bin/bash

function ctrl_c (){
	echo -e "\n\n [!] Saliendo...!! \n\n"
	exit 1
}

#ctrl + c 
trap ctrl_c INT

function helpPanel(){
	echo -e "[+] Usos: "
	echo -e "\t\n -g -> Busqueda global de un archivo"
	echo -e "\t\n -d -> Buscar dentro del directorio"
	echo -e "\t\n -s -> Busca archivos con permisos suid"
	echo -e "\t\n -h -> Panel de ayuda"
}

function searchGlobal(){
	FindFile="$1"
	echo -e "\n\n [+] Buscando $FindFile en el sistema"
	find / -name  $FindFile 2>/dev/null
}

function searchDirectori(){
	FindFile="$1"
	echo -e "\n\n [+] Buscando $FindFile en el directorio"
        find . -name $FindFile 2>/dev/null
}

function searchSuidPerm(){
	echo -e "\n\n [+] Buscando archivos con el permiso SUID en el sistema"
	find / -perm /4000  2>/dev/null
}

function searchSgidPerm(){
	echo -e "\n\n [+] Buscando archivos con el permiso SGID en el sistema"
	find / -perm /2000 2>/dev/null
}

# Indicadores 

declare -i parameter=0

while getopts "g:d:sbh" arg; do
	case $arg in
		g) fileName=$OPTARG; let parameter+=1;;
		d) fileName=$OPTARG; let parameter+=2;;
		s) let parameter+=3;;
		b) let parameter+=4;; 
		h) helpPanel;;
	esac
done

if [ $parameter -eq 1 ]; then
	searchGlobal $fileName
elif [ $parameter -eq 2 ]; then
	searchDirectori $fileName
elif [ $parameter -eq 3 ]; then
	searchSuidPerm
elif [ $parameter -eq 4 ]; then
	searchSgidPerm
else
	helpPanel
fi



