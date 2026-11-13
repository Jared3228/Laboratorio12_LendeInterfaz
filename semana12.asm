; ------------------------------------------------------------
; Semana 12 - Laboratorio (Parte 1): Pintar un carácter en color
; ------------------------------------------------------------
extrn GetStdHandle: proc
extrn SetConsoleCursorPosition: proc
extrn SetConsoleTextAttribute: proc
extrn WriteConsoleA: proc
extrn FillConsoleOutputCharacterA: proc ; <--- Nueva función para limpiar texto
extrn FillConsoleOutputAttribute: proc ; <--- Nueva función para limpiar colores (opcional)
extrn ExitProcess: proc
.data
 hConsole dq 0
 caracter db 'X', 0
 escritos dq 0
 coord dw 15, 10 ; COORD: X=10, Y=5

 ; Variables para la limpieza
 leidos dd 0
 homeCoord dd 0 ; X=0, Y=0 (Punto de inicio)
 numCeldas dd 2000 ; 80 columnas x 25 filas (tamaño estándar de consola)
.code
main proc
 ; Reservamos 30h (48 bytes) en el stack porque FillConsoleOutput tiene 5 parámetros.
 ; El 5to parámetro va en el espacio de la pila [rsp + 20h].
 sub rsp, 30h
 ; Obtener handle de la consola
 mov rcx, -11
 call GetStdHandle
 mov [hConsole], rax
 mov rbx, rax
 ; ========================================================
 ; LIMPIAR LA PANTALLA (Llenar con espacios en blanco)
 ; ========================================================
 mov rcx, rbx ; 1° hConsole
 mov rdx, 20h ; 2° Carácter espacio ' ' (0x20)
 mov r8d, [numCeldas] ; 3° Cuántas celdas limpiar
 mov r9d, [homeCoord] ; 4° Coordenada de inicio (0,0)
 lea rax, leidos
 mov qword ptr [rsp + 20h], rax ; 5° Puntero a caracteres escritos (en el Shadow Space)
 call FillConsoleOutputCharacterA
 ; (Opcional) Limpiar los atributos/colores viejos de la pantalla a negro por defecto (0x07)
 mov rcx, rbx
 mov rdx, 07h ; Atributo por defecto (texto blanco, fondo negro)
 mov r8d, [numCeldas]
 mov r9d, [homeCoord]
 lea rax, leidos
 mov qword ptr [rsp + 20h], rax
 call FillConsoleOutputAttribute
 ; ========================================================
 ; Mover el cursor a (10, 5)
 mov rcx, rbx
 mov rdx, 0x00070005 ; X=10, Y=5
 call SetConsoleCursorPosition
 ; Cambiar color: fondo azul, texto amarillo
 mov rcx, rbx
 mov rdx, 0x0C
 call SetConsoleTextAttribute
 ; Escribir el carácter 'X'
 mov rcx, rbx
 lea rdx, caracter
 mov r8, 1
 lea r9, escritos
 mov qword ptr [rsp + 20h], 0
 call WriteConsoleA
 ; Terminar
 xor ecx, ecx
 call ExitProcess
main endp
end