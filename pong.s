.text
.globl _start

_start:
    # Configurar direcci�n base
    li t0, 0xf0000010       # t0 = LED_MATRIX_0_BASE
    li s10, 0xf0000004      # s10 tiene dpad down
    li s11, 0xf0000000      # s11 con dpad up
    li t5, 0xf0000008     # t5 con dpad left
    li t6, 0xf000000c    #t6 con dpad right
    
    
    li s2, 0                # x = 0 (posici�n vertical)

    # Calcular offset: offset = (y + x*HEIGHT) * 4

    li t1, 0            # offset inicial psj1
    li s0, 136           # offset inicial psj2 carga posici�n del led cada 4 cambia de izquierda a derecha
    li s5, 1750         # offset inicial de la bola
    add t2, t0, t1       # t2 = direcci�n absoluta del LED psj1(x, y) base matriz + offset
    add s1, t0, s0       # s1 direcci�n inicial absoluta de psj2
    add s6, t0, s5
    li t3, 255           # t3 = me lo prende en azul, acci�n necesaria para que prenda el led

    sb t3, 0(t2)         # guardo en memoria la posici�n del led (lo prendo) psj1
    sb t3, 0(s1)         # psj2
    sb t3, 0(s6)            # inicializo la bola en la mitad mas o menos de la pantalla
    j programa

programa:

    loop:
        # Leer el valor del dpad down y dpad up
        lbu a1, 0(s10)   # Traigo lo que est� almacenando el dpad down en memoria al registro a1
        lbu a2, 0(s11)   # Traigo lo que est� almacenando el dpad up en memoria al registro a2
        lbu a3, 0(t5)   # Traigo lo que est� almacenando el dpad left en memoria al registro a3
        lbu a4, 0(t6)   # Traigo lo que est� almacenando el dpad right en memoria al registro a4
        
        # Si dpad down est� presionado (a1 != 0), saltar a presionado_dpaddown
        bne a1, x0, presionado_dpaddown
        
        # Si dpad up est� presionado (a2 != 0), saltar a presionado_dpadup
        bne a2, x0, presionado_dpadup

         # Si dpad left est� presionado (a3 != 0), saltar a presionado_dpadleft
        bne a3, x0, presionado_dpadleft

        # Si dpad left est� presionado (a4 != 0), saltar a presionado_dpadleft
        bne a4, x0, presionado_dpadright
        
        
        # Si ninguno est� presionado, continuar esperando
        j skip_add

    presionado_dpaddown:
        # Borrar el LED anterior (escribir 0 en la direcci�n donde estaba el anterior LED)
        sb x0, 0(t2)       # Borro el LED anterior (t2 tiene la direcci�n del LED anterior)
        
        # Mover la posici�n del LED (por ejemplo, sumando 140 a t1)
        addi t1, t1, 140        ##offset m�s bajar hacia abajo  
        add t2, t0, t1      # Actualizar la direcci�n para el siguiente LED
        
        # Encender el nuevo LED
        sb t3, 0(t2)

        # Saltar a la etiqueta skip_add
        j skip_add

    presionado_dpadup:
        # Borrar el LED anterior (escribir 0 en la direcci�n donde estaba el anterior LED)
        sb x0, 0(t2)       # Borro el LED anterior (s1 tiene la direcci�n del LED anterior)
        
        # Mover la posici�n del LED (por ejemplo, sumando 140 a s0)
        addi t1, t1, -140        
        add t2, t0, t1      # Actualizar la direcci�n para el siguiente LED
        
        # Encender el nuevo LED
        sb t3, 0(t2)
        
        # Saltar a la etiqueta skip_add
        j skip_add
        
    presionado_dpadleft:
         sb x0, 0(s1)       # Borro el LED anterior (s1 tiene la direcci�n del LED anterior)
        addi s0, s0, -140
        add s1, t0, s0      # Actualizar la direcci�n para el siguiente LED
        
        sb t3, 0(s1)
        
        # Saltar a la etiqueta skip_add
        j skip_add
        
    presionado_dpadright:
         sb x0, 0(s1)       # Borro el LED anterior (s1 tiene la direcci�n del LED anterior)
        addi s0, s0, 140
        add s1, t0, s0      # Actualizar la direcci�n para el siguiente LED
        
        sb t3, 0(s1)
        
        # Saltar a la etiqueta skip_add
        j skip_add
                
        
        
    skip_add:
        # Continuar esperando por una nueva entrada
        ## Y tambi�n aqui empieza logica de mover pelota
        
      # Guardar la direcci�n anterior de la pelota en s8
    add s8, t0, s5      # s8 = direcci�n actual de la pelota (antes de moverla) el offset + memoria

    # Mover la pelota: actualizamos la direcci�n de la pelota
    add s9, t0, s5
    addi s9, s9, 144     # Desplazar la pelota a la nueva posici�n (diagonal)
    
    # Borrar el LED en la posici�n anterior de la pelota (guardar antes y poner en 0)
    sb x0, 0(s8)         # Borrar el LED anterior (s8 tiene la direcci�n de la pelota anterior)
    
    # Actualizar la posici�n de la pelota en la nueva direcci�n y encender el LED
    sb t3, 0(s9)         # Encender el LED en la nueva posici�n (s9 tiene la nueva direcci�n)
    
    # Actualizar la posici�n de la pelota para el pr�ximo ciclo
    add s5, s9, x0       # Actualizar s5 con la nueva posici�n (para la siguiente iteraci�n)
     
        
        
        
        j loop

wait:
    j programa                 # Bucle infinito para mantener ejecuci�n
