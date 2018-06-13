!/bin/bash
export PGPASSWORD=root
DECLARE usuario
DECLARE palabra
DELCARE longitud
DELCARE puntaje
#EDITOR=nano
#PASSWD=/etc/passwd
#RED='\033[0;41;30m'
#STD='\033[0;0;39m'

#select palabra from palabra order by random() limit 1

pause(){
  read -p "Presione enter para continuar" pausa
}

uno(){
	echo "----Login----"
	echo "Por favor ingrese su usario"
	read usuario
	echo "Por favor digite su contraseña"
	read contra
	resul=`psql -X -A -U postgres -h LocalHost -d ahorcado -t -c "SELECT 1 FROM login WHERE usr ='$usuario' and pwd = '$contra'"`
	#echo $resul
	if [[ $resul -eq 1 ]]
	then
		echo "Datos de usuario correctos"
		mostrarMenuLogged
		palabra=`psql -X -A -U postgres -h LocalHost -d ahorcado -t -c "SELECT palabra from palabra order by random() limit 1"`
		longitud=`expr length $palabra`
		puntaje=$(echo $(($longitud*20)))
		echo $puntaje
	else
		echo "Datos de usuario inválidos"
	fi
	pause
}
 
# do something in dos()
dos(){
	echo "Usted está en el formulario de registro, por favor digite el nombre de usuario"
	read usuario
	echo "Por favor digite su contraseña"
	read contra
	#PGPASSWORD=root 
	psql -U postgres -h LocalHost -d ahorcado -c "INSERT into login values ('$usuario','$contra')" > prueba.txt
	pause
}

unoL(){
	echo "Ingrese la palabra"
	read palabra
	longitud=`expr length $palabra`
	puntaje=$(echo $(($longitud*20)))
	#echo $puntaje
	palabraIngresada=`psql -U postgres -h LocalHost -d ahorcado -c "INSERT into palabra (palabra, puntos, usr) values ('$palabra','$puntaje','$usuario')"` >prueba
	palabraIngresada=${palabraIngresada: -1:8}
	if [[ $palabraIngresada = 1 ]]
	then
		echo "La palabra ha sido ingresada correctamente"
	else
		echo "Error al ingresar la palabra"
	fi
}	


dosL(){
	echo "Ingrese la palabra que desea eliminar"
	read palabra
	delete=`psql -U postgres -h LocalHost -d ahorcado -t -c "delete from palabra where usr = '$usuario' and palabra = '$palabra' "` >prueba1.txt
	resultadoDelete=${delete: -1:8}
	if [[ $resultadoDelete = 1 ]]
	then
		echo "La palabra ha sido eliminada correctamente"
	else
		echo "Usted no tiene permiso para eliminar esta palabra, 
ya que ha sido ingresada por otro usuario O la palabra no existe"
	fi
}	
 
mostrarMenu() {
	clear
	echo "-------------------"	
	echo "     Ahorcado      "
	echo "-------------------"
	echo "1. Logearse"
	echo "2. Registrarse"
	echo "3. Salir"
	echo "4. Manual de usuario"
}

mostrarMenuLogged() {
	echo "-------------------"	
	echo "     Bienvenido  "
	echo "-------------------"
	echo "Seleccione su opción"
	echo "1. Agregar Palabras"
	echo "2. Eliminar Palabras"
	echo "4. Jugar"
	echo "3. Salir"
	leerOpcionLogged
	mostrarMenuLogged
}

leerOpcion(){
	local choice
	read -p "Digite la opción entre 1 y 4 " choice
	case $choice in
		1) uno ;;
		2) dos ;;
		3) exit 0;;
		4) cuatro ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

leerOpcionLogged(){
	local choice
	read -p "Digite la opción" choice
	case $choice in
		1) unoL ;;
		2) dosL ;;
		3) jugar $palabra $puntaje ;;
		4) exit 0 ;;
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
	echo ${#aux}
	echo ${#palabra}
        if [ "$aux" == "$palabra" ]
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
	else
	read -p "Deseas continuar jugando? (y/n)" continuar
	if [ "$continuar" == "y" ] 
	then
	#Aqui mandas a llamar de nuevo la funcion......
	jugar "nuevapalabradelabd" $puntos
	fi
    fi
    return $puntos
}

while true
do
 
	mostrarMenu
	leerOpcion
done



