# Proyecto Corto 1 

---

## *Integrantes del grupo👩‍💻👨‍💻*
- **Dennis Arce Álvarez**
- **Josué Arce Soto**
- **Galilea González Méndez**
- **Fabián Parreaguirre Hidalgo**

---
## *Juego Pong en Ripes-ensamblador 🕹️*

- El objetivo de este proyecto es escribir un programa utilizando lenguaje de ensamblador en el simulador ripes que permita visualizar el juego **pong**. La visualización del juego se realiza mediante una matriz de LED's, donde se presenta tanto la bola, como los jugadores 1 y 2 los cuales se controlan con el D-Pad.

---

## *¿Cómo cargar el juego en su computadora? ⚙️*
1. Abrir el simulador *ripes*
<p align="center">
  <img src="ripes.png" width="150"/>
</p>

2. Descargar el código del juego del repositorio  [Código pong_juego.s](https://github.com/fabianparrea/ProyectoDigitales/blob/main/pong_juego.s)

3. Cargar en ripes el archivo del ensamblador descargado previamente
<p align="center">
  <img src="load.png" width="150"/>
</p>

4. Asegurarse que *LED Matrix 0* y *D-Pad 0* se encuentren visibles en *I/O*
<p align="center">
  <img src="Matrix_dpad.png" width="500"/>
</p>

5. Iniciar el juego con el botón verde ubicado en la parte superior izquierda
<p align="center">
  <img src="run.png" width="250"/>
</p>

---

## *LED Matrix 0 🟨🟦*
-Lugar se desarrolla el juego 
- Al presionar el botón **run** abrá 3 led's encendidos, dos azules, que representan a los 2 jugadores y uno amarillo, que es la bola
- Cuando los jugadores empiezan a sumar puntos, aparecerán led's que llevan el conteo de los puntos 

<p align="center">
  <img src="matrix_inicial.png" width="250"/>
</p>

---

## *Jugadores y D_Pad 0 🎮*
El juego *pong* está diseñado para 2 jugadores 
- **Jugador 1:** led azul ubicado a la izquierda de la pantalla
  - **Arriba 🔼:** el jugador 1 sube 
  - **Izquierda ◀️:** el jugador 1 baja
    
<p align="center">
  <img src="dpad1.png" width="150"/>
</p>

- **Jugador 2:**  led azul ubicado a la derecha de la pantalla
  - **Derecha ▶️:** el jugador 2 sube
  - **Abajo 🔽:** el jugador 2 baja

<p align="center">
  <img src="dpad2.png" width="150"/>
</p>

---

## *Bola y sistema de puntuación 🟡*
La bola está representada por un led amarillo que se desplaza en la matriz simulando el movimiento de la bola en el *juego Pong*
- La bola se mueve automáticamente al iniciar el juego, cambiando su dirección al rebotar con los jugadores o los bordes superior e inferior de la matriz.
- Si un jugador no logra hacer contacto con la bola y esta llega al borde izquierdo o derecho, el otro jugador gana un punto.
  
Cada vez que un jugador anota, se enciende un led adicional en su respectiva columna de puntuación:

- **Jugador 1:** columna 1
- **Jugador 2:** columna 35

---
