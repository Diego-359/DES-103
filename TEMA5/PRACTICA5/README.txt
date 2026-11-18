PRACTICA 5 - DES103

ESTUDIANTE: ARANCIBIA LEON DIEGO ESTEBAN
CARRERA: INGENIERIA EN CIBERSEGURIDAD

DESCRIPCION:
El script permite monitorear los procesos con mayor
consumo de CPU y memoria, realizar busquedas por nombre
y registrar los resultados en un archivo log.

EJECUCION:
chmod +x monitor_basico.sh
./monitor_basico.sh
./monitor_basico.sh bash

ARCHIVOS:
monitor_basico.sh: Script principal.
monitor_procesos.log: Registro de los resultados.

FUNCIONES:
limpiar: Elimina el temporal.
manejar_interrupcion: Captura SIGINT y SIGTERM.
mostrar_cpu: Consulta procesos por CPU.
mostrar_memoria: Consulta procesos por memoria.
buscar_proceso: Busca procesos con pgrep.
main: Controla la ejecucion.

Se utiliza & y wait para ejecutar dos consultas en segundo plano y esperar sus resultados.
