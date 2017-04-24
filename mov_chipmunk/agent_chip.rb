require 'matrix'

class Datos
  attr_accessor :p, :v, :rot, :linear, :angular

  def initialize
    @p = CP::Vec2::ZERO
    @v = CP::Vec2::ZERO
    @linear = CP::Vec2::ZERO
    @angular = 0.0
    @rot = (0.0).degrees_to_radians
  end
end

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
    @maxSpeed = rand*0.1
  end

  # Funcion 'update' del libro
  def move data 
    @shape.body.v += data.v
    @shape.body.a += data.rot
  end

    # Funcion 'update' del libro
  def move_dyn data 
    @shape.body.p += @shape.body.v
    @shape.body.a += data.rot

    @shape.body.v += data.linear
    @shape.body.a += data.angular

    if @shape.body.v.length > @maxSpeed
      @shape.body.v = @shape.body.v.normalize
      @shape.body.v *= @maxSpeed
    end

  end

    # Dynamic Seek pag 57
  def seek_dyn target
    output = Datos.new
    maxAcc = 10

    output.linear = target - @shape.body.p
    output.linear = output.linear.normalize
    output.linear *= maxAcc

    output.angular = 0
    move_dyn(output)
  end

    # Dynamic Flee pag 59
  def flee_dyn target
    output = Datos.new
    maxAcc = 2

    output.linear = @shape.body.p - target
    output.linear = output.linear.normalize
    output.linear *= maxAcc

    if output.linear.length > @maxSpeed
      output.linear = output.linear.normalize
      output.linear *= @maxSpeed
    end

    output.angular = 0
    @shape.body.apply_force(@shape.body.rot, output.linear)
    #move_dyn(output)
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
    output = Datos.new()
    maxRot = 6

    vel = CP::Vec2.new(-Math.sin(@shape.body.a), Math.cos(@shape.body.a))
    output.v = vel*@maxSpeed

    output.rot = ((rand - rand) * maxRot).degrees_to_radians

    move(output)
  end

  # KinematicArrive pagina 52
  def arrive target
    output = Datos.new()
    r = 50
    t = 30.0

    vel = target - @shape.body.p

    if Gosu.distance(@shape.body.p.x, @shape.body.p.y, target.x, target.y) < r
      vel = CP::Vec2::ZERO
    end

    vel /= t

    if vel.length > @maxSpeed
      vel = vel.normalize
      vel *= @maxSpeed
    end

    output.rot = Math.atan2(-vel.x, vel.y) if vel.length > 0
    output.v = vel

    move(output)
  end
  
  # KinematicSeek pagina 50
  def seek target
    output = Datos.new()

    vel = target - @shape.body.p
    vel = vel.normalize
    vel *= @maxSpeed

    output.rot = Math.atan2(-vel.x, vel.y) if vel.length > 0
    output.v = vel
    move(output)
  end

  # KinematicFlee pagina 51
  def flee target
    output = Datos.new()

    vel = @shape.body.p - target
    vel = vel.normalize
    vel *= @maxSpeed

    output.rot = Math.atan2(-vel.x, vel.y) if vel.length > 0
    output.v = vel
    move(output)
  end
end