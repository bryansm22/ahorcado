!/bin/bash

EDITOR=nano
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
pause(){
  read -p "Presione enter para continuar" pausa
}

one(){
	echo "----Login----"
	echo "Por favor ingrese su usario"
	read usario
	echo "Por favor digite su contraseña"
	read contra
	PGPASSWORD=root psql -U postgres -h LocalHost -d ahorcado -c "SELECT * FROM login WHERE usr ='$usuario' and pwd = '$contra'"
	#if []
	#then
	#	echo "Usuario encontrado"
	#else
	#	echo "Datos de ingreso inválidos"
	#fi
	pause
}
 
# do something in two()
two(){
	echo "Usted está en el formulario de registro, por favor digite el nombre de usuario"
	read usuario
	echo "Por favor digite su contraseña"
	read contra
	PGPASSWORD=root psql -U postgres -h LocalHost -d ahorcado -c "INSERT into login values ('$usuario','$contra')" > prueba.txt
	pause
}
 
# function to display menus
show_menus() {
	clear
	echo "-------------------"	
	echo "     Ahorcado      "
	echo "-------------------"
	echo "1. Logearse"
	echo "2. Registrarse"
	echo "3. Salir"
	echo "4. Manual de usuario"
}

read_options(){
	local choice
	read -p "Digite la opción entre 1 y 4 " choice
	case $choice in
		1) one ;;
		2) two ;;
		3) exit 0;;
		4) four ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
#trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
do
 
	show_menus
	read_options
done
