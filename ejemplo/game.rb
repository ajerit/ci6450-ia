#!/usr/bin/env ruby
# https://github.com/gosu/gosu/wiki/Ruby-Tutorial
# Ejecutar: ./game.rb

require 'gosu'

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Game < Gosu::Window
  def initialize
    # Tamaño
    super 640, 480
    self.caption = "Test"

    # Cargar img fondo
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
     
    # Init jugador  
    @player = Player.new
    @player.warp(320, 240)

    # Init estrellas
    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = Array.new

    # Mostrar score
    @font = Gosu::Font.new(20)
  end

  # Game logic
  def update

    # Girar angulo si izq/der
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    end

    # Avanzar (acelerar) si arriba
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      @player.accelerate
    end

    # Hacer el movimiento
    @player.move

    # Verificar si se atrapó alguna estrella
    @player.collect_stars(@stars)

    # Crea estrellas de forma aleatoria
    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
  end

  # Dibujar escena, no logica
  def draw
    # Mostrar fondo
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    # Mostrar jugador
    @player.draw
    # Mostrar estrellas
    @stars.each { |star| star.draw }
    # Mostrar score
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def button_down(id)
    # Cerrar ventana con scape
    if id == Gosu::KB_ESCAPE
      close
    else
      # Herede del metodo original
      super
    end
  end
end

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
  end
end

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

# Iniciar juego
Game.new.show

