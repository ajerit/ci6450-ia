#!/usr/bin/env ruby
# https://github.com/gosu/gosu/wiki/Ruby-Tutorial
# Ejecutar: ./game.rb

require 'gosu'
require 'chipmunk'
require_relative 'agent_chip'
require_relative 'player_chip'

module ZOrder
  BACKGROUND, PLAYER, AGENT, UI = *0..3
end

WIDTH, HEIGHT = 720, 540
SUBSTEPS = 6

class Game < Gosu::Window
  def initialize
    # Tamaño
    super WIDTH, HEIGHT
    self.caption = "Seek"

    # Cargar img fondo
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
    @score = 0 
    # Step
    @dt = (1.0/60.0)

    # Space
    @space = CP::Space.new
    # Its like... fricción del ambiente
    # 1.0 es como si no hay. 0.0 es total
    @space.damping = 0.8

    # Init jugador
    body = CP::Body.new(10.0, 150.0)
    shape_array = [CP::Vec2.new(-18.5, -25.0), CP::Vec2.new(-18.5, 25.0), CP::Vec2.new(18.5, 5.0), CP::Vec2.new(18.5, -5.0)]  
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0.0, 0.0))
    shape.collision_type = :ship
    
    @space.add_body(body)
    @space.add_shape(shape)

    @player = Player.new(shape)
    @player.warp(CP::Vec2.new(320, 240))

    # Init agentes
    @agent_array = Array.new

    5.times do
      body = CP::Body.new(30.0, CP.moment_for_circle(30.0, 0.0, 40.0, CP::Vec2.new(0.0, 0.0)))
      shape = CP::Shape::Circle.new(body, 20.0, CP::Vec2.new(0.0, 0.0))
      shape.collision_type = :agent
      
      @space.add_body(body)
      @space.add_shape(shape)
      
      @agent_array.push(Agent.new(shape))
    end

    # manejar colision
    @space.add_collision_func(:ship, :agent) do |ship_shape, agent_shape|
    # NO PUEDO MODIFCAR SPACE
    # TENGO QUE HACER LISTA DE CAMBIOS Y EJECUTARLOS EN UPDATE
      @score = 0
    end

    #@space.add_collision_func(:agent, :agent, &nil)

    # Mostrar score
    @font = Gosu::Font.new(20)
  end

  # Game logic
  def update
    SUBSTEPS.times do
      @player.shape.body.reset_forces
      @player.validate_position
      @agent_array.each { |agent| agent.shape.body.reset_forces }
      @agent_array.each { |agent| agent.validate_position }

      ################ Moverse con las tecla Up ##################
      if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
        @player.turn_left
      end

      if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
        @player.turn_right
      end

      # Avanzar (acelerar) si arriba
      if Gosu.button_down? Gosu::KB_UP
        if Gosu.button_down?(Gosu::KB_RIGHT_SHIFT) or Gosu.button_down?(Gosu::KB_LEFT_SHIFT)
          @player.boost
        else
          @player.accelerate
        end
      elsif Gosu.button_down? Gosu::KB_DOWN
        @player.reverse
      end
      #############################################################

      #@agent_array.each { |agent| agent.arrive(@player.pos) }
      #@agent_array.each { |agent| agent.seek(@player.pos) }
      #@agent_array.each { |agent| agent.flee(@player.pos) }
      #@agent_array.each { |agent| agent.wander }
      @agent_array.each { |agent| agent.seek_dyn(@player.pos) }

      @space.step(@dt)
    end
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
    #@font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
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
Game.new.show if __FILE__ == $0

