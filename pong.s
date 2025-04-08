.text
.globl _start

_start:
    # Configurar dirección base
    li t0, 0xf0000010       # t0 = LED_MATRIX_0_BASE
    li s10, 0xf0000004      # s10 tiene dpad down
    li s11, 0xf0000000      # s11 con dpad up
    li t5, 0xf0000008     # t5 con dpad left
    li t6, 0xf000000c    #t6 con dpad right
    
    
    li s2, 0                # x = 0 (posición vertical)

    # Calcular offset: offset = (y + x*HEIGHT) * 4

    li t1, 0            # offset inicial psj1
    li s0, 136           # offset inicial psj2 carga posición del led cada 4 cambia de izquierda a derecha
    li s5, 1750         # offset inicial de la bola
    add t2, t0, t1       # t2 = dirección absoluta del LED psj1(x, y) base matriz + offset
    add s1, t0, s0       # s1 dirección inicial absoluta de psj2
    add s6, t0, s5
    li t3, 255           # t3 = me lo prende en azul, acción necesaria para que prenda el led

    sb t3, 0(t2)         # guardo en memoria la posición del led (lo prendo) psj1
    sb t3, 0(s1)         # psj2
    sb t3, 0(s6)            # inicializo la bola en la mitad mas o menos de la pantalla
    j programa

programa:

    loop:
        # Leer el valor del dpad down y dpad up
        lbu a1, 0(s10)   # Traigo lo que está almacenando el dpad down en memoria al registro a1
        lbu a2, 0(s11)   # Traigo lo que está almacenando el dpad up en memoria al registro a2
        lbu a3, 0(t5)   # Traigo lo que está almacenando el dpad left en memoria al registro a3
        lbu a4, 0(t6)   # Traigo lo que está almacenando el dpad right en memoria al registro a4
        
        # Si dpad down está presionado (a1 != 0), saltar a presionado_dpaddown
        bne a1, x0, presionado_dpaddown
        
        # Si dpad up está presionado (a2 != 0), saltar a presionado_dpadup
        bne a2, x0, presionado_dpadup

         # Si dpad left está presionado (a3 != 0), saltar a presionado_dpadleft
        bne a3, x0, presionado_dpadleft

        # Si dpad left está presionado (a4 != 0), saltar a presionado_dpadleft
        bne a4, x0, presionado_dpadright
        
        
        # Si ninguno está presionado, continuar esperando
        j skip_add

    presionado_dpaddown:
        # Borrar el LED anterior (escribir 0 en la dirección donde estaba el anterior LED)
        sb x0, 0(t2)       # Borro el LED anterior (t2 tiene la dirección del LED anterior)
        
        # Mover la posición del LED (por ejemplo, sumando 140 a t1)
        addi t1, t1, 140        ##offset más bajar hacia abajo  
        add t2, t0, t1      # Actualizar la dirección para el siguiente LED
        
        # Encender el nuevo LED
        sb t3, 0(t2)

        # Saltar a la etiqueta skip_add
        j skip_add

    presionado_dpadup:
        # Borrar el LED anterior (escribir 0 en la dirección donde estaba el anterior LED)
        sb x0, 0(t2)       # Borro el LED anterior (s1 tiene la dirección del LED anterior)
        
        # Mover la posición del LED (por ejemplo, sumando 140 a s0)
        addi t1, t1, -140        
        add t2, t0, t1      # Actualizar la dirección para el siguiente LED
        
        # Encender el nuevo LED
        sb t3, 0(t2)
        
        # Saltar a la etiqueta skip_add
        j skip_add
        
    presionado_dpadleft:
         sb x0, 0(s1)       # Borro el LED anterior (s1 tiene la dirección del LED anterior)
        addi s0, s0, -140
        add s1, t0, s0      # Actualizar la dirección para el siguiente LED
        
        sb t3, 0(s1)
        
        # Saltar a la etiqueta skip_add
        j skip_add
        
    presionado_dpadright:
         sb x0, 0(s1)       # Borro el LED anterior (s1 tiene la dirección del LED anterior)
        addi s0, s0, 140
        add s1, t0, s0      # Actualizar la dirección para el siguiente LED
        
        sb t3, 0(s1)
        
        # Saltar a la etiqueta skip_add
        j skip_add
                
        
        
    skip_add:
        # Continuar esperando por una nueva entrada
        ## Y también aqui empieza logica de mover pelota
        
      # Guardar la dirección anterior de la pelota en s8
    add s8, t0, s5      # s8 = dirección actual de la pelota (antes de moverla) el offset + memoria

    # Mover la pelota: actualizamos la dirección de la pelota
    add s9, t0, s5
    addi s9, s9, 144     # Desplazar la pelota a la nueva posición (diagonal)
    
    # Borrar el LED en la posición anterior de la pelota (guardar antes y poner en 0)
    sb x0, 0(s8)         # Borrar el LED anterior (s8 tiene la dirección de la pelota anterior)
    
    # Actualizar la posición de la pelota en la nueva dirección y encender el LED
    sb t3, 0(s9)         # Encender el LED en la nueva posición (s9 tiene la nueva dirección)
    
    # Actualizar la posición de la pelota para el próximo ciclo
    add s5, s9, x0       # Actualizar s5 con la nueva posición (para la siguiente iteración)
     
        
        
        
        j loop

wait:
    j programa                 # Bucle infinito para mantener ejecución
