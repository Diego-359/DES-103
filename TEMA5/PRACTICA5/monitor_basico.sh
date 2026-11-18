#!/bin/bash

#ESTUDIANTE: ARANCIBIA LEON DIEGO ESTEBAN
#CARRERA: ING. EN CIBERSEGURIDAD

LOG="monitor_procesos.log"
TEMP="/tmp/monitor_$$.tmp"

#Limpiar el archivo temporal
limpiar() {
    rm -f "$TEMP"
    echo "[INFO] Limpieza ejecutada: $(date)" >> "$LOG"
}

#Avisar si se interrumpe el programa
manejar_interrupcion() {
    echo "[WARN] Interrupcion recibida: $(date)" >> "$LOG"
    echo "[WARN] Se interrumpio el monitoreo" >&2
    exit 1
}


#Mostrar los procesos que consumen mas CPU
mostrar_cpu() {
    echo "=== TOP 5 PROCESOS POR CPU ===" >> "$LOG"

    if ! ps aux --sort=-%cpu | head -6 >> "$LOG"; then
        echo "[ERROR] No se pudo consultar CPU" >> "$LOG"
        return 1
    fi

    echo >> "$LOG"

    return 0
}

#Mostrar los procesos que consumen mas memoria
mostrar_memoria() {
    echo "=== TOP 5 PROCESOS POR MEMORIA ===" >> "$LOG"

    if ! ps aux --sort=-%mem | head -6 >> "$LOG"; then
        echo "[ERROR] No se pudo consultar memoria" >> "$LOG"
        return 1
    fi

    echo >> "$LOG"
    return 0

}

#Buscar un proceso por su nombre
buscar_proceso() {
    local proceso="$1"
    local resultado

    if resultado=$(pgrep -a -- "$proceso"); then
        echo "[OK] Proceso encontrado: $proceso"
        echo "$resultado"
        echo "Busqueda: $proceso" >> "$LOG"
        echo "$resultado" >> "$LOG"
    else
        echo "[INFO] No se encontro el proceso: $proceso"
        echo "[INFO] Proceso no encontrado: $proceso" >> "$LOG"
    fi
}

#Funcion principal
main() {
    local pid_cpu pid_memoria
    local error=0

    trap limpiar EXIT
    trap manejar_interrupcion SIGINT SIGTERM

    if ! touch "$LOG"; then
        echo "[ERROR] No se pudo crear el log" >&2
        return 2
    fi

    if ! echo "Datos temporales" > "$TEMP"; then
        echo "[ERROR] No se pudo crear el temporal" >&2
        return 2
    fi

    echo "=================================="
    echo "MONITOR BASICO DE PROCESOS"
    echo "=================================="

    echo "[INFO] Inicio: $(date)" >> "$LOG"

    #Ejecutar las consultas en segundo plano
    mostrar_cpu &
    pid_cpu=$!

    mostrar_memoria &
    pid_memoria=$!

    #Esperar que terminen las dos consultas
    wait "$pid_cpu" || error=1
    wait "$pid_memoria" || error=1

    if [[ "$error" -ne 0 ]]; then
        echo "[ERROR] Fallo el monitoreo" >&2
        return 3
    fi

    #Buscar el proceso si se ingreso un argumento
    if [[ -n "${1:-}" ]]; then
        buscar_proceso "$1"
    fi

    echo "[OK] Monitoreo finalizado"
    echo "[INFO] Fin: $(date)" >> "$LOG"
    echo "Reporte generado: $LOG"

    return 0
}

main "$@"
