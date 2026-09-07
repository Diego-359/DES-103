# Práctica Tema 2: Funciones, argumentos y retorno

## Nombre: DIEGO ESTEBAN ARANCIBIA LEON

## Descripcion
El script audita una ruta del sistema como un archivo, directorio o enlace simbólico,
identificando su tipo y los permisos de lectura, escritura y ejecución.

## Forma de ejecucion
./auditoria_modular.sh <al ruta>

## Ejemplos de uso
./auditoria_modular.sh /etc/passw
./auditoria_modular.sh /var/log
./auditoria_modular.sh /ruta/fake

## Funciones implementadas
mostrar_uso()
mostrar_error()
validar_argumentos()
validar_ruta()
identificar_tipo()
verificar_permisos()
main()

## Explicación del uso de return
Función validar_argumentos: return 0 indica que se recibió al menos un argumento, return 1 si no.
Función validar_ruta: return 0 si la ruta existe, return 1 si no existe.
Se usa return porque solo se necesita saber exito o error, no un valor de texto.

## Explicación del uso de local
Todas las funciones que reciben una ruta la guardan en una variable local
(en el scrpit: local ruta="$1") para que ese valor no se filtre ni choque con otras
variables del script, evitando efectos secundarios
