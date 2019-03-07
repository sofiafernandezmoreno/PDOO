#encoding: utf-8

require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "jugador"
require "singleton"

module ModeloQytetet
  class Qytetet
    include Singleton
    
    MAX_JUGADORES = 4
    NUM_SORPRESAS = 10
    NUM_CASILLAS = 20
    PRECIO_LIBERTAD = 200
    SALDO_SALIDA = 1000
    
    attr_accessor :cartaActual
    attr_reader :mazo, :tablero, :dado, :jugadorActual, :jugadores
    
    
    def initialize
      @mazo = Array.new
      @cartaActual = nil
      @jugadores = Array.new
      @jugadorActual = nil
      @dado = nil
    end
    
    def actuarSiEnCasillaEdificable
      raise NotImplementedError
    end
    
    def actuarSiEnCasillaNoEdificable
      raise NotImplementedError
    end
    
    def aplicarSorpresa
      raise NotImplementedError
    end
    
    def cancelarHipoteca(numeroCasilla)
      raise NotImplementedError
    end
    
    def comprarTituloPropiedad
      raise NotImplementedError
    end
    
    def edificarCasa(numeroCasilla)
      raise NotImplementedError
    end
    
    def edificarHotel(numeroCasilla)
      raise NotImplementedError
    end
    
    def encarcelarJugador
      raise NotImplementedError
    end
    
    def getValorDado
      raise NotImplementedError
    end
    
    def hipotecarPropiedad(numeroCasilla)
      raise NotImplementedError
    end
    
    def inicializarCartasSorpresa
      raise NotImplementedError
    end
    
    def inicializarJuego(nombres)
      inicializarJugadores(nombres)
      inicializarTablero()
      inicializarCartasSorpresa()
    end
    
    def inicializarJugadores(nombres)
      nombres.each do |i|
        @jugadores << Jugador.new(i)
      end
    end
    
    def inicializarTablero
      @tablero = Tablero.new
    end
    
    def intentarSalirCarcel(metodo)
      raise NotImplementedError
    end
    
    def jugar
      raise NotImplementedError
    end
    
    def mover(numCasillaDestino)
      raise NotImplementedError
    end
    
    def obtenerCasillaJugadorActual
      raise NotImplementedError
    end
    
    def obtenerCasillasTablero
      raise NotImplementedError
    end
    
    def obtenerPropiedadesJugador
      raise NotImplementedError
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      raise NotImplementedError
    end
    
    def obtenerRanking
      raise NotImplementedError
    end
    
    def salidaJugadores
      rand = 
    end
    
    def siguienteJugador
      for i in 0..jugadores.size
        if(jugadores.i == jugadorActual)
          jugadorActual = jugadores.i+1%jugadores.size
        end
      end
      if(jugadorActual.encarcelado)
        estado = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        estado = EstadoJuego::JA_PREPARADO
      end
    end
    
    def tirarDado
      raise NotImplementedError
    end
    
    def venderPropiedad(numeroCasilla)
      raise NotImplementedError
    end
   
    def inicializarCartasSorpresa
       inicializarTablero
       
       mazo<< Sorpresa.new("Han subido los impuestos sobre la luz y debes pagar 200 euros.",200,TipoSorpresa::PAGARCOBRAR)
       mazo<< Sorpresa.new("Te ha tocado la loteria y ganas 250 euros.",250,TipoSorpresa::PAGARCOBRAR)
       mazo<< Sorpresa.new("Se te acosa de un delito menor. Ve a la carcel.",tablero.carcel.numeroCasilla,TipoSorpresa::IRACASILLA)
       mazo<< Sorpresa.new("Ve a la casilla 5",5,TipoSorpresa::IRACASILLA)
       mazo<< Sorpresa.new("Ve a la casilla 6",6,TipoSorpresa::IRACASILLA)
       mazo<< Sorpresa.new("Por cada casa y hotel en tu propiedad cobras 200 euros.",200,TipoSorpresa::PORCASAHOTEL)
       mazo<< Sorpresa.new("Por cada casa y hotel en tu propiedad pagas 200 euros.",200,TipoSorpresa::PORCASAHOTEL)
       mazo<< Sorpresa.new("Por cada jugador en la partida cobras 500 euros.",500,TipoSorpresa::PORJUGADOR)
       mazo<< Sorpresa.new("Por cada jugador en la partida pagas 500 euros.",500,TipoSorpresa::PORJUGADOR)
       mazo<< Sorpresa.new("Se puede utilizar en cualquier momento para salir de la carcel.",-1,TipoSorpresa::SALIRCARCEL)
    end 
    
    def to_s
      puts "--------------------- Juego Qytetet --------------------- \ncartaActual: #{@cartaActual} \nDado: #{@dado} \nJugador Actual: #{@jugadorActual}" 
      
      puts "\nJugadores:"
      
      @jugadores.each do |j|
        puts j
      end
      
      puts "\nMazo:" 
      @mazo.each do |m|
        puts m
      end
      
      
      "\nTablero #{@tablero}"  
    end
    
    private :encarcelarJugador, :inicializarCartasSorpresa, :inicializarJugadores, :inicializarTablero, :salidaJugadores
    
  end
end
