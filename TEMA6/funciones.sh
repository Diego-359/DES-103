#!/bin/bash
#ESTUDIANTE:  ARANCIBIA LEON DIEGO ESTEBAN
#CARRERA: ING. EN CIBERSEGURIDAD

registrar_evento() {
    echo "[$(date '+%F %T')] $1" >> "$LOG_EJECUCION"
}

mostrar_error() {
    echo "[ERROR] $1" >&2
    registrar_evento "ERROR: $1"
}

consultar_entorno() {
    echo "VARIABLES DE ENTORNO"
    echo "Usuaro: $USER"
    echo "Home: $HOME"
    echo "Shell: $SHELL"
    echo "Path: $PATH"

    registrar_evento "Consulta de variables de entorno"
    return 0
}


validar_archivo() {
    local archivo="$1"

    if [[ -z "$archivo" ]]; then
        mostrar_error "Debe ingresar una ruta"
        return 2
    fi

    if [[ ! -f "$archivo" ]]; then
        mostrar_error "El archivo no existe: $archivo"
        return 3
    fi

    if [[ ! -r "$archivo" ]]; then
        mostrar_error "No tiene permiso de lectura"
        return 4
    fi

    echo "[OK] Archivo valido: $archivo"
    registrar_evento "Archivo validado: $archivo"
    return 0
}

validar_numero() {
    local numero="$1"
    if [[ ! "$numero" =~ ^[0-9]+$ ]]; then
        mostrar_error "Debe ingresar un numero entero:"
        return 2
    fi

    if [[ ${#numero} -gt 2 ]] || (( 10#$numero < 1 || 10#$numero > 20 )); then
        mostrar_error "El numero debe estar entre 1 y 20"
        return 2
    fi

    echo "[OK] Numero valido: $numero"
    registrar_evento "Numero validado: $numero"
    return 0
}

consultar_sistema() {
    echo "ESPACIO EN DISCO"

    if ! df -h /; then
        mostrar_error "No se pudo consultar el disco"
        return 5
    fi

    echo
    echo "MEMORIA RAM"

    if ! free -h; then
        mostrar_error "No se pudo consultar la memoria"
        return 5
    fi

    registrar_evento "Consulta de recursos del sistema"
    return 0
}

demostrar_entorno() {
    export VARIABLE_PRACTICA6="DES103"

    echo "Variable exportada: $VARIABLE_PRACTICA6"
    printenv VARIABLE_PRACTICA6

    unset VARIABLE_PRACTICA6

    if [[ -z "${VARIABLE_PRACTICA6+x}" ]]; then
        echo "[OK] Variable eliminada con unset"
    fi

    registrar_evento "Demostracion de export y unset"
    return 0
}

mostrar_registros() {
    if [[ ! -r "$LOG_EJECUCION" ]]; then
        mostrar_error "No se puede leer el registro"
        return 5
    fi

    echo "REGISTRO DE EJECUCION"
    cat "$LOG_EJECUCION"

    return 0
}
