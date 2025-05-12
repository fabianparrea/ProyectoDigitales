.text
.globl _start

#Configurar direccion base
li t0, LED_MATRIX_0_BASE    ## Direccion LED_MATRIX_0_BASE (t0)
li s1, D_PAD_0_DOWN         ## Direccion dpad down (s1)
li s2, D_PAD_0_UP           ## Direccion dpad up (s2)
li s3, D_PAD_0_LEFT         ## Direccion dpad left (s3)
li s4, D_PAD_0_RIGHT        ## Direccion dpad right (s4)

_start:
    # Calcular offset: offset = (y + x*HEIGHT) * 4
    ## Cada posicion del led cambia 4 de izquierda a derecha
    ## LED1 = 0, LED2 = 4, LED3 = 8, etc.
    li s5, 12               ## offset inicial psj1 (s5)
    li s6, 124              ## offset inicial psj2 (s6)
    li s7, 1750             ## offset inicial de la bola (s7)
    
    ## Introduce el offset
    add t1, t0, s5          ## Direccion inicial absoluta del LED psj1 (t1)
    add t2, t0, s6          ## Direccion inicial absoluta del LED psj2 (t2)
    add t3, t0, s7          ## Direccion inicial absoluta del LED bola (t3)

    ## Accion necesaria para que prenda el led
    li s8, 255              ## Enciende el LED en color azul (s8)
    li s9, 16776960        ## Enciende el LED en color amarillo (s11)
    
    ## Guardo en memoria la posicion del led (lo prendo)
    sb s8, 0(t1)            ## Enciende LED psj1
    sb s8, 0(t2)            ## Enciende LED psj2
    sb s9, 0(t3)            ## Enciende LED bola (aprox. mitad pantalla)
    
    ## Direccion de la bola
    li s10, 4                ## Direccion horizontal de la bola
    li s11, 140              ## Direcccion vertical de la bola
    ## Salta al tag loop
    j loop
    
loop:
    # Leer el valor del DPAD
    ## Traigo lo que este almacenando en DPAD en memoria a un registro a[1-4]
    lbu a1, 0(s1)           ## Lee DPAD Down en memoria, al registro a1
    lbu a2, 0(s2)           ## Lee DPAD Up en memoria, al registro a2
    lbu a3, 0(s3)           ## Lee DPAD Left en memoria, al registro a3
    lbu a4, 0(s4)           ## Lee DPAD Right en memoria, al registro a4
        
    ## Si DPAD esta PRESIONADO (a[1-4] != 0), saltar a presionado_dpad
    bne a1, x0, presionado_dpaddown    ### DPAD Down       
    bne a2, x0, presionado_dpadup      ### DPAD Up
    bne a3, x0, presionado_dpadleft    ### DPAD Left
    bne a4, x0, presionado_dpadright   ### DPAD Right
        
mov_bola:
    add t4, t0, s7          ## Dirección actual de la pelota
    sb x0, 0(t4)            ## Borrar LED anterior

    ## Actualizar posición de la bola
    add a5, s7, s10         ## Agregar la dirección horizontal a la bola
    add a5, a5, s11         ## Agregar la dirección vertical a la bola (para futuras comparaciones, si es necesario)
    
    addi s6, s6, 2
    addi s5, s5, 2
    ## Comparar si la bola choca con psj1 o psj2 (solo en dirección horizontal)
    beq a5, s5, rebote_h    ## Si la bola choca con psj1, su dirección cambia
    beq a5, s6, rebote_h    ## Si la bola choca con psj2, su dirección cambia
    addi s6, s6, -2
    addi s5, s5, -2
    ## Lógica de puntaje
    li a6, 140
    rem a7, a5, a6
   ## blt a7, x4, punto_psj2
    li a6, 132
    bgt a7, a6, punto_psj1

    li a6, 0              ## Limite superior
    blt a5, a6, rebote_v    ## Si choca con límite superior, su dirección cambia hacia abajo
    li a6, 3500             ## Limite inferior
    bgt a5, a6, rebote_v    ## Si choca con límite inferior, su dirección cambia hacia abajo
    
    mv s7, a5               ## Copiar la nueva dirección
    add t5, t0, s7          ## Dirección nueva
    sb s9, 0(t5)            ## Encender LED nuevo
    j loop
presionado_dpaddown:
    li t6, 3360             ## Limite Inferior de la paleta del psj1
    bgt s5, t6, mov_bola    ## Si intenta bajar mas que el limite, no hace ningun movimiento
    # Borrar el LED anterior (escribir 0 en la direccion donde estaba el anterior LED)
    sb x0, 0(t1)            ## Borro el LED anterior (t1 tiene la direccion del LED anterior)
    # Mover la posicion del LED (por ejemplo, sumando 140 a s5)
    addi s5, s5, 140        ##offset mas bajar hacia abajo
    add t1, t0, s5          ## Actualizar la direccion para el siguiente LED
    sb s8, 0(t1)            ## Encender el nuevo LED
    j mov_bola              ## Saltar a la etiqueta mov_bola

presionado_dpadup:
    li t6, 140              ## Limite superior de la paleta del psj1
    blt s5, t6, mov_bola    ## Si intenta subir mas que el limite, no hace ningun movimiento
    # Borrar el LED anterior (escribir 0 en la direccion donde estaba el anterior LED)
    sb x0, 0(t1)            ## Borro el LED anterior (t1 tiene la direccion del LED anterior)
    addi s5, s5, -140       ## Mover la posicion del LED (por ejemplo, sumando 140 a s5)   
    add t1, t0, s5          ## Actualizar la direccion para el siguiente LED
    sb s8, 0(t1)            ## Encender el nuevo LED
    j mov_bola              ## Saltar a la etiqueta mov_bola
        
presionado_dpadleft:
    li t6, 140              ## Limite superior de la paleta del psj2
    blt s6, t6, mov_bola    ## Si intenta suir mas que el limite, no hace ningun movimiento
    sb x0, 0(t2)            ## Borro el LED anterior (t2 tiene la direccion del LED anterior)
    addi s6, s6, -140
    add t2, t0, s6          ## Actualizar la direccion para el siguiente LED
    sb s8, 0(t2)
    j mov_bola              ## Saltar a la etiqueta mov_bola
        
presionado_dpadright:
    li t6, 3360             ## Limite inferior de la paleta de psj2
    bgt s6, t6, mov_bola    ## Si intenta bajar mas que el limite, no hace ningun movimiento
    sb x0, 0(t2)            ## Borro el LED anterior (t2 tiene la direccion del LED anterior)
    addi s6, s6, 140
    add t2, t0, s6          ## Actualizar la direccion para el siguiente LED
    sb s8, 0(t2)
    j mov_bola              ## Saltar a la etiqueta mov_bola

rebote_h:
    # Invierte la direccion horizontal de la bola
    neg s10, s10
    sb s10, 0(s4)     # Guarda la nueva direccion horizon
    addi s6, s6, -2
    addi s5, s5, -2
    j mov_bola

rebote_v:
    # Invierte la direccion vertical de la bola
    neg s11, s11
    j mov_bola

punto_psj1:
    # Enciendo un LED en la colunma 1 por cada punto
    # Agrega un punto al psj1
    j reset_bola

punto_psj2:
    # Enciendo un LED en la colunma 35 por cada punto
    # Agrega un punto al psj2
    j reset_bola

reset_bola:
    li s7, 1750            ## Posicion inicial de la bola
    li s10, 4               ## Direccion inicial horizontal
    li s11, 140            ## Direccion inicial vertical
    j mov_bola