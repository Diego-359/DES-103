#!/bin/bash
# =====================================================
# Script: analizador_automatizado_logs.sh
# Descripción: Analiza un archivo de log y genera un reporte.
# Uso: ./analizador_automatizado_logs.sh <archivo_log> <directorio_salida>
# =====================================================
#ESTUDIANTE: ARANCIBIA LEON DIEGO ESTEBAN 	CARRERA: ING. EN CIBERSEGURIDAD


ARCHIVO_LOG="$1"
DIRECTORIO_SALIDA="$2"
FECHA="$(date +%F_%H-%M-%S)"
LOG_EJECUCION="$DIRECTORIO_SALIDA/ejecucion_analizador.log"

mostrar_uso() {
    echo "Uso: $0 <archivo_log> <directorio_salida>"
}

registrar_info() {
    local mensaje="$1"
    echo "[INFO] $(date '+%F %T') - $mensaje" >> "$LOG_EJECUCION"
}

registrar_error() {
    local mensaje="$1"
    echo "[ERROR] $(date '+%F %T') - $mensaje" >> "$LOG_EJECUCION"
    echo "[ERROR] $mensaje" >&2
}

validar_argumentos() {
    if [[ $# -lt 2 ]]; then
        mostrar_uso
        exit 1
    fi
}

preparar_directorio() {
    if [[ ! -d "$DIRECTORIO_SALIDA" ]]; then
        if ! mkdir -p "$DIRECTORIO_SALIDA"; then
            echo "No se pudo crear el directorio: $DIRECTORIO_SALIDA" >&2
            exit 4
        fi
    fi
}

validar_log() {
    local archivo="$1"
    if [[ ! -f "$archivo" ]]; then
        registrar_error "El archivo de log no existe: $archivo"
        exit 2
    fi
    if [[ ! -r "$archivo" ]]; then
        registrar_error "El archivo de log no tiene permisos de lectura: $archivo"
        exit 3
    fi
}

total_lineas() {
    local archivo="$1"
    wc -l < "$archivo"
}

contar_palabra() {
    local palabra="$1"
    local archivo="$2"
    grep -ci "$palabra" "$archivo"
}

top_ips() {
    local archivo="$1"
    grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$archivo" | sort | uniq -c | sort -nr | head -10
}

top_palabras() {
    local archivo="$1"
    sed 's/[^a-zA-Z0-9._-]/ /g' "$archivo" | tr ' ' '\n' | grep -v '^$' | sort | uniq -c | sort -nr | head -10
}

eventos_por_nivel() {
    local archivo="$1"
    awk '{print $3}' "$archivo" | sort | uniq -c | sort -nr
}

eventos_por_fecha() {
    local archivo="$1"
    cut -d' ' -f1 "$archivo" | sort | uniq -c
}

generar_reporte() {
    local archivo="$1"
    local reporte="$2"
    {
        echo "======================================"
        echo " REPORTE DE ANÁLISIS DE LOG"
        echo "======================================"
        echo "Archivo analizado: $archivo"
        echo "Fecha de análisis: $(date '+%F %T')"
        echo
        echo "1. Cantidad total de líneas: $(total_lineas "$archivo")"
        echo "2. Líneas con 'error': $(contar_palabra "error" "$archivo")"
        echo "3. Líneas con 'failed': $(contar_palabra "failed" "$archivo")"
        echo "4. Líneas con 'warning': $(contar_palabra "warning" "$archivo")"
        echo
        echo "5. Top 10 direcciones IP más repetidas:"
        top_ips "$archivo"
        echo
        echo "6. Top 10 palabras más frecuentes:"
        top_palabras "$archivo"
        echo
        echo "7. Eventos por nivel:"
        eventos_por_nivel "$archivo"
        echo
        echo "8. Eventos por fecha:"
        eventos_por_fecha "$archivo"
    } > "$reporte" 2>> "$LOG_EJECUCION"
}

resumen() {
    local archivo="$1"
    local reporte="$2"
    local total errores fallidos
    total=$(total_lineas "$archivo")
    errores=$(contar_palabra "error" "$archivo")
    fallidos=$(contar_palabra "failed" "$archivo")
    {
        echo
        echo "9. Resumen final:"
        echo "Se analizaron $total líneas del archivo $archivo."
        echo "Se encontraron $errores líneas con error y $fallidos con failed."
        if [[ "$fallidos" -ge 2 ]]; then
            echo "cuidao hay accesos fallidos repetidos, revisa las ip."
        else
            echo "No se detectaron indicios relevantes de accesos fallidos."
        fi
    } >> "$reporte" 2>> "$LOG_EJECUCION"
}

main() {
    validar_argumentos "$@"
    preparar_directorio
    validar_log "$ARCHIVO_LOG"

    local reporte="$DIRECTORIO_SALIDA/reporte_log_$FECHA.txt"

    registrar_info "Inicio de análisis"
    registrar_info "Archivo procesado: $ARCHIVO_LOG"

    if ! generar_reporte "$ARCHIVO_LOG" "$reporte"; then
        registrar_error "Ocurrió un error al generar el reporte"
        exit 5
    fi
    resumen "$ARCHIVO_LOG" "$reporte"

    registrar_info "Reporte generado: $reporte"
    registrar_info "Fin de análisis"
    echo "[OK] Reporte generado: $reporte"
}

main "$@"
