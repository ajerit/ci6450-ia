class Player
  attr_reader :score

  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  # Actualizar posición
  def warp(x, y)
    @x, @y = x, y
  end

  # Girar
  def turn_left
    @angle -= 4.5
  end

  def turn_right 
    @angle += 4.5
  end

  # Calcula la posicion nueva hacia donde se va a mover
  def accelerate
    # offset_ funciona como senos y cosenos
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  # Efectua el movimiento hacia la posicion calculada
  def move
    @x = (@x + @vel_x) % 640
    @y = (@y + @vel_y) % 480
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def score
    @score
  end

  # Dibujar el sprite
  def draw
    @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
  end

  # Si la estrella está a menos de 35px(?) se elimina del array ("se atrapa")
  def collect_stars(stars)
    stars.reject! do |star| 
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        true
      else
        false
      end
    end
  end
end