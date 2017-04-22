require 'matrix'
class Agent
  attr_reader :x, :y

  def initialize
    @image = Gosu::Image.new("media/enemy.png")
    @x = rand * WIDTH
    @y = rand * HEIGHT
    @angle = @vel_x = @vel_y = 0.0
    @maxSpeed = 0.9
  end

  def draw  
    @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
  end

  # KinematicSeek pagina 50
  def seek target
    vel = Vector[target[:x] - @x, target[:y] - @y]
    vel = vel.normalize

    # Detenemos el movimiento si ya esta muy cerca
    vel *= (Gosu.distance(@x, @y, target[:x], target[:y]) < 35) ? 0 : @maxSpeed

    @vel_x = vel[0]
    @vel_y = vel[1]
  end

  def move
    @x = (@x + @vel_x) % WIDTH
    @y = (@y + @vel_y) % HEIGHT
  end
end