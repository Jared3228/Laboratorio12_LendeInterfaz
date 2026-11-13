; ----------------------------------------------------
; Semana 12 - Laboratorio (Parte 2): Animación básica
; ----------------------------------------------------
extrn GetStdHandle: proc
extrn SetConsoleCursorPosition: proc
extrn SetConsoleTextAttribute: proc
extrn WriteConsoleA: proc
extrn Sleep: proc
extrn ExitProcess: proc
extrn FillConsoleOutputCharacterA: proc
extrn FillConsoleOutputAttribute: proc
.data
 hConsole dq 0
 caracter db 'O', 0
 espacio db ' ', 0
 escritos dq 0
 pos_x dw 0
 pos_y dw 10
 ; Variables para la limpieza
 leidos dd 0
 homeCoord dd 0 ; X=0, Y=0 (Punto de inicio)
 numCeldas dd 2000 ; 80 columnas x 25 filas (tamaño estándar de consola)
.code
main proc
 ; Ajustamos a 30h para reservar espacio de sobra (parámetros en stack)
 ; y mantener la alineación de la pila (30h + 8 bytes de retorno = 38h, alinea a 16 bytes)
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
 ; Color: fondo negro, texto verde
 mov rcx, rbx
 mov rdx, 0x0A
 call SetConsoleTextAttribute
 ; Inicializar X en 0
 mov word ptr [pos_x], 70 ; modificamos para que inicie a la derecha
anim_loop:
 cmp word ptr [pos_x], 70
 je pintar_caracter ; Si es la primera posición, no hay nada que borrar atrás
 ; Borrar la posición anterior (escribir espacio)
 mov rcx, rbx
 movzx rdx, word ptr [pos_x]
 inc rdx ; Ahora uso inc porque el rastro queda a la derecha
 movzx rax, word ptr [pos_y]
 shl rax, 16
 or rdx, rax
 call SetConsoleCursorPosition
 mov rcx, rbx
 lea rdx, espacio
 mov r8, 1
 lea r9, escritos
 mov qword ptr [rsp + 20h], 0
 call WriteConsoleA
pintar_caracter:
 ; Mover el cursor a la nueva posición
 mov rcx, rbx
 movzx rdx, word ptr [pos_x]
 movzx rax, word ptr [pos_y]
 shl rax, 16
 or rdx, rax
 call SetConsoleCursorPosition
 ; Escribir el carácter 'X'
 mov rcx, rbx
 lea rdx, caracter
 mov r8, 1
 lea r9, escritos
 mov qword ptr [rsp + 20h], 0
 call WriteConsoleA
 ; Retardo de 50 ms
 mov rcx, 25
 call Sleep
 ; Incrementar X y evaluar bucle (Aqui modificamos tambien)
 dec word ptr [pos_x] 
 cmp word ptr [pos_x], 0 ; Comparamos para el borde izquierdo
 jge anim_loop ; Jump if Greater or Equal en lugar de jl
 ; Terminar
 xor ecx, ecx
 call ExitProcess
main endp
end