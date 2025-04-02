	.globl _start

# Direcciones de memoria
DPAD_UP:      .word 0xf0000dac     # Botón Up
DPAD_DOWN:    .word 0xf0000db0     # Botón Down
DPAD_LEFT:    .word 0xf0000db4     # Botón Left
DPAD_RIGHT:   .word 0xf0000db8     # Botón Right
MATRIX_BASE:  .word 0xf0000000     # Base de la matriz de LEDs
MATRIX_WIDTH: .word 35             # Ancho de la matriz
MATRIX_HEIGHT:.word 25             # Alto de la matriz

_start:
    # Inicializar el primer personaje (columna izquierda)
    li t0, 0       # Fila inicial
    li t1, 0       # Columna izquierda
    
    # Inicializar el segundo personaje (columna derecha)
    li t2, 0       # Fila inicial
    li t3, 34      # Columna derecha
    
    call update_led

main_loop:
    # Leer entradas del DPAD
    lw t4, DPAD_UP     # Botón UP
    lw t5, DPAD_DOWN   # Botón DOWN
    lw t6, DPAD_LEFT   # Botón LEFT
    lw s11, DPAD_RIGHT  # Botón RIGHT

    # Mover personaje izquierdo (columna 0) con DPAD_UP y DPAD_DOWN
    beq t4, x0, no_up
    addi t0, t0, -1  # Mover arriba
no_up:
    beq t5, x0, no_down
    addi t0, t0, 1   # Mover abajo
no_down:
    
    # Mover personaje derecho (columna 34) con DPAD_LEFT y DPAD_RIGHT
    beq t6, x0, no_left
    addi t2, t2, -1  # Mover arriba
no_left:
    beq s11, x0, no_right
    addi t2, t2, 1   # Mover abajo
no_right:  # que siga con el codigo 

    # Asegurar que los personajes no salgan de la matriz
    lw a7, MATRIX_HEIGHT
    blt t0, x0, limit_up_1
    bge t0, a7, limit_down_1
    j check_second
    
limit_up_1:
    li t0, 0
    j check_second
limit_down_1:
    li t0, 24

check_second:
    blt t2, x0, limit_up_2
    bge t2, a7, limit_down_2
    j update_led
limit_up_2:
    li t2, 0
    j update_led
limit_down_2:
    li t2, 24

update_led:
    # Apagar matriz antes de actualizar
    lw s3, MATRIX_BASE
    li s9, 0
    sw s9, 0(s3)
    
    # Encender LED del primer personaje
    lw s3, MATRIX_BASE
    mul s9, t0, a7
    add s9, s9, t1
    slli s9, s9, 2
    add s3, s3, s9
    li s10, 1
    sw s10, 0(s3)
    
    # Encender LED del segundo personaje
    lw s3, MATRIX_BASE
    mul s9, t2, a7
    add s9, s9, t3
    slli s9, s9, 2
    add s3, s3, s9
    sw s10, 0(s3)
    
    # Volver al loop principal
    j main_loop
