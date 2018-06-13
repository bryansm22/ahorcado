!/bin/bash
export PGPASSWORD=root

EDITOR=nano
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

#select palabra from palabra order by random() limit 1

pause(){
  read -p "Presione enter para continuar" pausa
}

one(){
	echo "----Login----"
	echo "Por favor ingrese su usario"
	read usuario
	echo "Por favor digite su contraseña"
	read contra
	resul=`psql -X -A -U postgres -h LocalHost -d ahorcado -t -c "SELECT 1 FROM login WHERE usr ='$usuario' and pwd = '$contra'"`
	echo $resul
	if [ resul!=0 ]
	then
		echo "Usuario encontrado"
	else
		echo "Datos de usuario inválidos"
	fi
	pause
}
 
# do something in two()
two(){
	echo "Usted está en el formulario de registro, por favor digite el nombre de usuario"
	read usuario
	echo "Por favor digite su contraseña"
	read contra
	#PGPASSWORD=root 
	psql -U postgres -h LocalHost -d ahorcado -c "INSERT into login values ('$usuario','$contra')" > prueba.txt
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

#Funcion que contiene la logica del juego ahorcado.
#para llamarla se debera de incluir dos parametros la palabra y de existir un puntaje de la partida previa.
#ejemplo: jugar "palabra" 100
#!/bin/bash
# GNU bash, version 4.3.46

jugar () {
if [ ! -z $1 ] 
then
    palabra=$1
else
    palabra="palabra"
fi
preview_score=${2:-0}  
palabra_size=${#palabra}
aux=$(printf '%*s' $palabra_size '')
aux="${aux// /*}"
puntos=$(expr $palabra_size * 20)
echo $puntos
puntos=$(expr $puntos + $preview_score)
while [ $puntos != 0 ]
    do
        read -p "Ingrese la letra:" letra
        echo $letra
        coincidencias=0
         for i in $(seq 0 $(($palabra_size-1)))
             do
               
                 if [ ${palabra:$i:${i+1}} = $letra ] 
                 then
                    pre=${aux:0:${i}}
                    aux=${aux:0:${i}}${letra}${aux:$(($i+1)):${palabra_size-1}}
                    coincidencias=$(($coincidencias+1))
                 fi
             done
        if [$aux = $palabra]
        then
            echo "has adivinado la palabra!!!"
            break
        fi
             #echo $coincidencias
              if [ $coincidencias = 0 ] 
                 then
                 echo "La letra no es correcta"
                 echo "-10pts"
                    puntos=$((puntos-10))
                 fi
                 echo $aux
                 echo "score:"$puntos
    done
    if [ $puntos = 0 ]
    then
        echo "Has perdido el juego...."
    fi
    return $puntos
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



