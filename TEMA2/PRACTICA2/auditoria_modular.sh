#!/bin/bash

mostrar_uso() {
	echo "Uso: $0 <ruta>"
}
mostrar_error() {
	local mensaje="$1"
	echo "[Error] $mensaje" >&2
}

validar_argumentos() {
	if [[ $# -lt 1 ]]; then
        	mostrar_uso
        	 return 1
    	fi
    	return 0
}

validar_ruta() {
	local ruta="$1"
	if [[ -e "$ruta" ]]; then
    		return 0
    	else
        	return 1
	fi
}

identificar_tipo() {
	local ruta="$1"
	if [[ -f "$ruta" ]]; then
        	echo "Archivo regular"
    	elif [[ -d "$ruta" ]]; then
        	echo "Directorio"
   	elif [[ -L "$ruta" ]]; then
    	   	echo "Enlace simbólico"
   	else
	   	echo "Otro tipo de elemento"
    	fi
}
verificar_permisos() {
    	local ruta="$1"
    	echo "Permisos:"
    	if [[ -r "$ruta" ]]; then
        	echo "Lectura: SI"
    	else
        	echo "Lectura: NO"
    	fi
    	if [[ -w "$ruta" ]]; then
       		echo "Escritura: SI"
    	else
        	echo "Escritura: NO"
    	fi
    	if [[ -x "$ruta" ]]; then
        	echo "Ejecución: SI"
    	else
        	echo "Ejecución: NO"
    	fi
}

main() {
	local ruta="$1"

    	if ! validar_argumentos "$@"; then
        	exit 1
    	fi

    	if ! validar_ruta "$ruta"; then
        	mostrar_error "La ruta no existe: $ruta"
        	exit 2
    	fi

    	echo "==AUDITORÍA MODULAR DE RUTA=="
    	echo "Ruta analizada: $ruta"
    	echo

    	local tipo
    	tipo=$(identificar_tipo "$ruta")
    	echo "Tipo detectado: $tipo"
    	echo

    	verificar_permisos "$ruta"
    	echo
    	echo "Estado: análisis finalizado correctamente."
}

main "$@"
