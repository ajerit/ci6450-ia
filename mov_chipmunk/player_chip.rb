require 'chipmunk'

class Player
  attr_reader :shape

  def initialize shape
    @image = Gosu::Image.new("media/ship1.png")
    #@x = @y = @vel_x = @vel_y = @angle = 0.0
    @shape = shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # Posicion
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # Velocidad
    @shape.body.a = (3*Math::PI/2.0) # Angulo en radianes
  end

  # Actualizar posición
  def warp vector
    @shape.body.p = vector
  end

  def pos
    @shape.body.p
  end

################ Moverse con las tecla Up ##################
  def turn_left
    @shape.body.t -= 400.0/SUBSTEPS
  end

  def turn_right 
    @shape.body.t += 400.0/SUBSTEPS
  end

  def accelerate
    @shape.body.apply_force(@shape.body.rot * (3000.0/SUBSTEPS), CP::Vec2.new(0.0, 0.0))
  end

  def boost
    @shape.body.apply_force(@shape.body.rot * 3000.0, CP::Vec2.new(0.0, 0.0))
  end

  def reverse
    @shape.body.apply_force(-@shape.body.rot * (1000.0/SUBSTEPS), CP::Vec2.new(0.0, 0.0))
  end

  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    @shape.body.p = l_position
  end

  # Dibujar el sprite
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::PLAYER, @shape.body.a.radians_to_gosu)
  end
end