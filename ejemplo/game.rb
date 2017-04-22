#!/usr/bin/env ruby
# https://github.com/gosu/gosu/wiki/Ruby-Tutorial
# Ejecutar: ./game.rb

require 'gosu'
require_relative 'star'
require_relative 'player'

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

# Iniciar juego
Game.new.show

