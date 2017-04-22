#!/usr/bin/env ruby
# https://github.com/gosu/gosu/wiki/Ruby-Tutorial
# Ejecutar: ./game.rb

require 'gosu'
require 'chipmunk'
require_relative 'agent'
require_relative 'player'

module ZOrder
  BACKGROUND, PLAYER, AGENT, UI = *0..3
end

WIDTH, HEIGHT = 720, 576

class Game < Gosu::Window
  def initialize
    # Tamaño
    super WIDTH, HEIGHT
    self.caption = "Seek"

    # Cargar img fondo
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
     
    # Init jugador  
    @player = Player.new
    @player.warp(320, 240)

    # Init estrellas
    @agent_array = Array.new

    3.times do
      @agent_array.push(Agent.new)
    end

    # Mostrar score
    @font = Gosu::Font.new(20)
  end

  # Game logic
  def update
################ Moverse con las 4 teclas ##################

    # if Gosu.button_down? Gosu::KB_LEFT  or Gosu.button_down? Gosu::GP_LEFT
    #   @player.move_left
    #   @agent_array.each { |agent| agent.seek(@player.pos) }  
    # end
    # if Gosu.button_down? Gosu::KB_RIGHT or Gosu.button_down? Gosu::GP_RIGHT
    #   @player.move_right
    #   @agent_array.each { |agent| agent.seek(@player.pos) }
    # end
    # if Gosu.button_down? Gosu::KB_UP    or Gosu.button_down? Gosu::GP_UP
    #   @player.accelerate 
    #   @agent_array.each { |agent| agent.seek(@player.pos) }
    # end
    # if Gosu.button_down? Gosu::KB_DOWN  or Gosu.button_down? Gosu::GP_DOWN
    #   @player.brake
    #   @agent_array.each { |agent| agent.seek(@player.pos) }
    # end
############################################################


################ Moverse con las tecla Up ##################
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

    @player.move
#############################################################

    @agent_array.each { |agent| agent.seek(@player.pos) }
    @agent_array.each { |agent| agent.move }
  end

  # Dibujar escena, no logica
  def draw
    # Mostrar fondo
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    # Mostrar jugador
    @player.draw
    # Mostrar estrellas
    @agent_array.each { |agent| agent.draw }
    # Mostrar score
    #@font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def button_down(id)
    # Cerrar ventana con scape
    if id == Gosu::KB_ESCAPE
      close
    else
      # Hereda del metodo original
      super
    end
  end
end

# Iniciar juego
Game.new.show

