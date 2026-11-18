#!/bin/bash
#ESTUDIANTE: ARANCIBIA LEON DIEGO ESTEBAN
#CARRERA: ING. EN CIBERSEGURIDAD

BASE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -r "$BASE/configuracion.sh" || ! -r "$BASE/funciones.sh" ]]; then
    echo "[ERROR] Faltan archivos de configuración o funciones" >&2
    exit 6
fi

source "$BASE/configuracion.sh"
source "$BASE/funciones.sh"

if ! mkdir -p "$DIRECTORIO_REGISTROS"; then
    echo "[ERROR] No se pudo crear el directorio" >&2
    exit 5

fi

if ! touch "$LOG_EJECUCION"; then
    echo "[ERROR] No se pudo crear el registro" >&2
    exit 5
fi

main() {
    local opcion
    local ruta
    local numero
    local codigo

    registrar_evento "Inicio del asistente"

    PS3="Seleccione una opcion: "

    echo "==================================================="
    echo "$NOMBRE_PROYECTO"
    echo "===================================================="

    select opcion in \
        "Consultar entorno" \
        "Validar archivo" \
        "Validar numero" \
        "Consultar sistema" \
        "Export y unset" \
        "Ver registros" \
        "Salir"
    do
        echo

        case "$REPLY" in
            1)
                consultar_entorno
                codigo=$?
                ;;
            2)
                read -r -p "Ingrese la ruta del archivo: " ruta
                validar_archivo "$ruta"
                codigo=$?
                ;;
            3)
                read -r -p "Ingrese número entre 1 y 20: " numero
                validar_numero "$numero"
                codigo=$?
                ;;

            4)
                consultar_sistema
                codigo=$?
                ;;
            5)
                demostrar_entorno
                codigo=$?
                ;;

            6)
                mostrar_registros
                codigo=$?
                ;;
            7)
                echo "Saliendo del asistente..."
                registrar_evento "Fin del asistente"
                return 0
                ;;

            *)
                mostrar_error "opción inválida"
                codigo=2
                ;;
        esac

        echo "Código de return: $codigo"
        echo
    done
}

main
exit $?
