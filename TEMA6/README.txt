PRACTICA 6 - DES103
ASISTENTE INTERACTIVO DE DIAGNOSTICO PARA LINUX

ESTUDIANTE: ARANCIBIA LEON DIEGO ESTEBAN
CARRERA: INGENIERIA EN CIBERSEGURIDAD

DESCRIPCION:
Este proyecto permite consultar informacion del sistema Linux mediante un menu interactivo desarrollado en Bash.

ARCHIVOS:
	asistente.sh: Programa principal y menu.
	funciones.sh: Funciones de diagnostico y validacion.
	configuracion.sh: Variables de configuracion.
	registros/ejecucion.log: Registro de eventos.

EJECUCIÓN:
1. Abrir una terminal Linux o WSL.
2. Entrar a la carpeta del proyecto:
   cd proyecto_tema6
3. Dar permiso de ejecucion:
   chmod +x asistente.sh
4. Ejecutar:
   ./asistente.sh

VALIDACIONES:
Se valida que el archivo exista y tenga permiso de lectura.
Se valida que el número sea entero y este entre: 1 y 20
Se comprueban errores en las consultas y registros

CÓDIGOS DE RETORNO:

0: Todo correct.
2: Entrada inválida.
3: archivo inexistente.
4: Sin permiso de lectura.
5: Error de recursos o registro.
6: Archivos necesarios no disponibles.

El script utiliza read, select, case, source, export, unset y redirección de errores.
