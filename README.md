# Animación en consola usando ensamblador y la api de windows
Nombre del alumno: Ley Gomez Leonardo Jared

# Descripción

El primer código "semana12.asm" dibuja un carácter X en la posición de la consola indicada, también le indicamos el color del fondo y el del texto. 
El segundo código "semana12_anim.asm" también dibuja un caracter O, pero lo mueve en la consola, modificado para que en lugar de izquierda a derecha, sea de derecha a izquierda.

# Funcionamiento 

semana12.asm

<img width="388" height="112" alt="image" src="https://github.com/user-attachments/assets/b94bae46-a360-4bec-a9b4-7c79ef18702b" />


semana12_anim.asm

<img width="575" height="263" alt="image" src="https://github.com/user-attachments/assets/887c3b2d-c408-4d10-b536-2db19591625f" />

<img width="555" height="228" alt="image" src="https://github.com/user-attachments/assets/1f16ff69-1cbd-49a7-91db-40c06ade1da1" />

# Instrucciones de compilación 
Funciona igual para ambos
Ensamble:
```
uasm64 -win64 [nombre_del_archivo].asm
```
Enlace:
```
golink.exe [nombre_del_archivo].obj kernel32.dll /fo [nombre_del_archivo].exe /console /entry main
```
