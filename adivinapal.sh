!/bin/bash
export PGPASSWORD=root
DECLARE usuario

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
		3) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
while true
do
 
	mostrarMenu
	leerOpcion
done
