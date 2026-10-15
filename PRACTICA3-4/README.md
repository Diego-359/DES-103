# Práctica conjunta Tema 3 y Tema 4

## Nombre del estudiante
DIEGO ESTEBAN ARANCIBIA LEON

## Descripción
El script analiza un archivo de log, extrae información relevante y genera
un reporte automatizado con fecha y hora en el nombre. También guarda un log
interno de ejecución (ejecucion_analizador.log).

## Forma de ejecución
./analizador_automatizado_logs.sh <archivo_log> <directorio_salida>

## Ejemplo
./analizador_automatizado_logs.sh ./logs/sistema.log ./reportes

## Comandos utilizados
- grep: busca líneas con error, failed, warning y extrae las IPs
- awk: extrae la columna del nivel del evento (INFO, ERROR, etc.)
- sed: limpia el texto para contar palabras
- cut: extrae la fecha de cada línea
- sort: ordena resultados
- uniq -c: cuenta repetidos
- wc -l: cuenta líneas
- head: limita los resultados al top 10
- > y >>: generan y agregan contenido al reporte y a los logs
- 2>>: registra errores en ejecucion_analizador.log
- cron: programa la ejecución diaria

## Reporte generado
reporte_log_AAAA-MM-DD_HH-MM-SS.txt (en la carpeta reportes/)

## Automatización
Se usó cron, programado todos los días a las 23:00 horas y la salida de cron se
guarda en logs/cron_analizador.log.

## Evidencias
Capturas en la carpeta evidencias/.
