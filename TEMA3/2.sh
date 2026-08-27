#!/bin/bash
ARCHIVO="$1"

function validar_parametros() {
    if [[ -z "$ARCHIVO" ]]; then
        echo "[ERROR] Debe proporcionar un archivo" >&2
        exit 1
    fi
}

function validar_archivo() {
  if [[ ! -r "$ARCHIVO" ]]; then
    echo "[ERROR] No se puede leer $1" >&2
    exit 1
  fi
}

function mostrar_usuarios() {
    awk -F: '{print "Usuario:", $1, "| Shell:", $7}' "$ARCHIVO" | sort
}

validar_parametros
validar_archivo "$ARCHIVO"
mostrar_usuarios

