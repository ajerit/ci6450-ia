# CI6450-IA
Proyectos CI6450

Instalar para correr el ejemplo:
```
gem install gosu      # lib juego
gem install chipmunk  # lib de efectos fisicos
gem install opengl    # lib de efectos 3d
```

Imágenes para juegos
```
https://opengameart.org/
```

23/04
******
+ Implementado el mismo juego y algoritmos pero usando Chipmunk para manejar las colisiones.
+ Los sprites no se pegan encima como antes ya que ahora tiene cuerpo y forma.

22/04
******
+ Implementados: Seek, Flee, Arrive, Wander
+ Nuevas imagenes

+ Implementado el Kinematic Seek (pagina 50) en la carpeta de movimiento
Los enemigos te persiguen, lo que no me gusta es que después de cierto tiempo
todos terminan pegados, porque usan el mismo vector para perseguir me imagino.
También porque los personajes no tienen 'cuerpo' ni 'forma' (para esto deberíamos usar chipmunk)
