require 'matrix'

class Agent
  attr_reader :x, :y

  def initialize
    @sprites = ["media/meteor1.png", "media/meteor2.png", "media/meteor3.png", "media/meteor4.png"]
    @image = Gosu::Image.new(@sprites[(rand*4).to_i])
    @x = rand * WIDTH
    @y = rand * HEIGHT
    @angle = rand*360
    @vel_x = @vel_y = @rot = 0.0
    @maxSpeed = rand*0.8
  end

  def move
    @x = (@x + @vel_x) % WIDTH
    @y = (@y + @vel_y) % HEIGHT
    @angle = (@angle + @rot)
  end

  def draw  
    @image.draw_rot(@x, @y, ZOrder::PLAYER, 0.0)
  end

  # KinematicWander pagina 53
  def wander
    maxRot = 7

    vel = Vector[-Math.sin(Gosu.degrees_to_radians(@angle)), Math.cos(Gosu.degrees_to_radians(@angle))]
    vel *= @maxSpeed

    @rot = (rand - rand) * maxRot

    @vel_x, @vel_y = vel[0], vel[1]
  end

  # KinematicArrive pagina 52
  def arrive target
    r = 35
    t = 2

    vel = Vector[target[:x] - @x, target[:y] - @y]

    if (Gosu.distance(@x, @y, target[:x], target[:y]) < r)
      vel = Vector[0, 0]
    end

    vel /= t

    if vel.magnitude > @maxSpeed
      vel = vel.normalize
      vel *= @maxSpeed
    end

    @vel_x = vel[0]
    @vel_y = vel[1]
  end

  # KinematicSeek pagina 50
  def seek target
    vel = Vector[target[:x] - @x, target[:y] - @y]
    vel = vel.normalize

    vel *= @maxSpeed

    @vel_x = vel[0]
    @vel_y = vel[1]

    @angle = Math.atan2(-@vel_x, @vel_y) if vel.magnitude > 0
  end

  # KinematicFlee pagina 51
  def flee target
    vel = Vector[@x - target[:x], @y - target[:y]]
    vel = vel.normalize

    # Detenemos el movimiento si ya esta muy cerca
    vel *= @maxSpeed

    @vel_x = vel[0]
    @vel_y = vel[1]
    
    @angle = Math.atan2(-@vel_x, @vel_y) if vel.magnitude > 0
  end
end