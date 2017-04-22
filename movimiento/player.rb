class Player
  attr_reader :score
  SPEED = 4

  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  # Actualizar posición
  def warp(x, y)
    @x, @y = x, y
  end

  def pos
    {:x => @x, :y => @y, :a => @angle}
  end

################ Moverse con las tecla Up ##################
  def turn_left
    @angle -= 4.5
  end

  def turn_right 
    @angle += 4.5
  end

  def accelerate
    # offset_ funciona como senos y cosenos
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x = (@x + @vel_x) % WIDTH
    @y = (@y + @vel_y) % HEIGHT
    @vel_x *= 0.95
    @vel_y *= 0.95
  end
############################################################

################ Moverse con las 4 teclas ##################
  def move_left
    @x = (@x - SPEED) % WIDTH
  end

  def move_right 
    @x = (@x + SPEED) % WIDTH
  end

  # Calcula la posicion nueva hacia donde se va a mover
  #def accelerate
    # offset_ funciona como senos y cosenos
    #@y = (@y - SPEED) % HEIGHT
  #end

  # Efectua el movimiento hacia la posicion calculada
  def brake
    @y = (@y + SPEED) % HEIGHT
  end
############################################################

  def score
    @score
  end

  # Dibujar el sprite
  def draw
    @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
    ################ Moverse con las 4 teclas ##################
    #@image.draw(@x - @image.width / 2, @y - @image.height / 2, ZOrder::PLAYER)
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