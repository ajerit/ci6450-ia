require 'matrix'

class Agent
  attr_reader :shape
  def initialize shape
    #@sprites = ["media/meteor1.png", "media/meteor2.png", "media/meteor3.png", "media/meteor4.png"]
    @sprites = ["media/meteor1.png", "media/meteor2.png"]
    @image = Gosu::Image.new(@sprites[(rand*2).to_i])
    @shape = shape
    @shape.body.p = CP::Vec2.new(rand * WIDTH, rand * HEIGHT)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    @shape.body.a = (rand*360).degrees_to_radians
    # ?
    @maxSpeed = rand*0.2
  end

  def move
    @x = (@x + @vel_x) % WIDTH
    @y = (@y + @vel_y) % HEIGHT
    @angle = (@angle + @rot)
  end

  def draw
    # Hacer que el sprite gire hacia el movimiento  
    #@image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::PLAYER, @shape.body.a.radians_to_gosu)
    
    # Sprite no cambia su giro
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::PLAYER, 0.0)
  end

  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % WIDTH, @shape.body.p.y % HEIGHT)
    @shape.body.p = l_position
  end

  # KinematicWander pagina 53
  def wander
    maxRot = 6

    vel = CP::Vec2.new(-Math.sin(@shape.body.a), Math.cos(@shape.body.a))
    vel *= @maxSpeed

    @shape.body.a += ((rand - rand) * maxRot).degrees_to_radians

    @shape.body.p += vel
  end

  # KinematicArrive pagina 52
  def arrive target
    r = 40
    t = 100.0

    vel = target - @shape.body.p

    if vel.length < r
      vel = CP::Vec2::ZERO
    end

    vel /= t

    if vel.length > @maxSpeed
      vel = vel.normalize
      vel *= @maxSpeed
    end

    @shape.body.a = Math.atan2(-vel.x, vel.y) if vel.length > 0
    @shape.body.p += vel
  end

  # KinematicSeek pagina 50
  def seek target
    vel = target - @shape.body.p
    vel = vel.normalize
    vel *= @maxSpeed

    @shape.body.a = Math.atan2(-vel.x, vel.y) if vel.length > 0

    @shape.body.p += vel
  end

  # KinematicFlee pagina 51
  def flee target
    vel = @shape.body.p - target
    vel = vel.normalize
    vel *= @maxSpeed

    @shape.body.a = Math.atan2(-vel.x, vel.y) if vel.length > 0

    @shape.body.p += vel
  end
end