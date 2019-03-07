#encoding: utf-8

require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "jugador"
require_relative "dado"
require_relative "estado_juego"
require "singleton"
require_relative "especulador"
require_relative "calle"
require_relative "casilla"
require_relative "tablero"
require_relative "metodo_salir_carcel"

module ModeloQytetet
  class Qytetet
    include Singleton
    
    MAX_JUGADORES = 4
    NUM_SORPRESAS = 10 
    NUM_CASILLAS = 20
    PRECIO_LIBERTAD = 200
    SALDO_SALIDA = 1000
    
    attr_accessor :cartaActual,:estadoJuego
    attr_reader :mazo, :tablero, :dado, :jugadorActual, :jugadores
    
    
    def initialize
      @mazo = Array.new
      @cartaActual = nil
      @jugadores = Array.new
      @jugadorActual = nil
      @dado = Dado.instance
      @estadoJuego = nil
    end
    
    def actuarSiEnCasillaEdificable
      deboPagar = @jugadorActual.deboPagarAlquiler
      
      if(deboPagar)
        @jugadorActual.pagarAlquiler
        if(@jugadorActual.saldo <=0)
          @estadoJuego = (EstadoJuego::ALGUNJUGADORENBANCAROTA)
        end
      end
      
      casilla=obtenerCasillaJugadorActual
      tengoPropietario = casilla.tengoPropietario
      
      if(@estadoJuego != EstadoJuego::ALGUNJUGADORENBANCARROTA)
        if(tengoPropietario)
          @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
        else
          @estadoJuego =(EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
        end
      end
    end
    
    def actuarSiEnCasillaNoEdificable
      @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
      
      @casillaActual = @jugadorActual.casillaActual
      
      if(@casillaActual.tipo == TipoCasilla::IMPUESTO)
        @jugadorActual.pagarImpuesto
      else
        if (@casillaActual.tipo == TipoCasilla::JUEZ)
          encarcelarJugador
        else
          if(@casillaActual.tipo == TipoCasilla::SORPRESA)
            @cartaActual = @mazo.at(0)
            @mazo.delete(0)
            @estadoJuego =(EstadoJuego::JA_CONSORPRESA)
          end
        end
      end
    end
    def self.getMaxJugadores
      MAX_JUGADORES
    end
    def aplicarSorpresa
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      
      if(@cartaActual.tipo == TipoSorpresa::SALIRCARCEL)
        @jugadorActual.cartaLibertad = @cartaActual
      else
        @mazo<<@cartaActual
        
        if(@cartaActual.tipo == TipoSorpresa::PAGARCOBRAR)
          @jugadorActual.modificarSaldo(@cartaActual.valor)
          
          if(@jugadorActual.saldo < 0)
            @estadoJuego =(EstadoJuego::ALGUNJUGADORENBANCARROTA)
          end
        elsif (@cartaActual.tipo == TipoSorpresa::IRACASILLA)
          valor = @cartaActual.valor
          casillaCarcel = @tablero.esCasillaCarcel(valor)
          
          if(casillaCarcel)
            encarcelarJugador()
          else
            mover(valor)
          end
        elsif (@cartaActual.tipo == TipoSorpresa::PORCASAHOTEL)
          cantidad = @cartaActual.valor
          numeroTotal = @jugadorActual.cuantasCasasHotelesTengo
          @jugadorActual.modificarSaldo(cantidad*numeroTotal)
          
          if(@jugadorActual.saldo < 0)
            @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
        elsif (@cartaActual.tipo == TipoSorpresa::PORJUGADOR)
          @jugadores.each do |jugador|
            if(jugador != @jugadorActual)
              jugador.modificarSaldo(@cartaActual.valor)
              
              if(jugador.saldo < 0)
                @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
              
              jugador.modificarSaldo(-@cartaActual.valor)
              
              if(@jugadorActual.saldo < 0)
                @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
            end
          end
        elsif @cartaActual.tipo == TipoSorpresa::CONVERTIRME
          
          especulador = @jugadorActual.convertirme(@cartaActual.valor) 
          indice = @jugadores.index(@jugadorActual)
          @jugadores[indice] = especulador
          @jugadorActual = especulador
          
          
        
        end
      end
    end
    
    def cancelarHipoteca(numeroCasilla)
      cancelarHipoteca = false
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      estaHipotecada = titulo.hipotecada
      esDeMiPropiedad = @jugadorActual.esDeMiPropiedad(titulo);
      esEdificable = casilla.soyEdificable
      if (esEdificable && esDeMiPropiedad && estaHipotecada) 
        cancelarHipoteca = @jugadorActual.cancelarHipoteca(titulo);
      end

      
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      
      return cancelarHipoteca
    end
    
   
    
    def comprarTituloPropiedad
      comprado = @jugadorActual.comprarTituloPropiedad
      
      if(comprado)
        @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
      end
      
      return comprado
    end
    
    def edificarCasa(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarCasa(titulo)
      
      if(edificada)
        @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
      end
      
      return edificada
    end
    
    def edificarHotel(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificado = @jugadorActual.edificarHotel(titulo)
      
      if(edificado)
        @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
      end
      
      return edificado
    end
    
    def encarcelarJugador
      if !@jugadorActual.tengoCartaLibertad
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        @estadoJuego = EstadoJuego::JA_ENCARCELADO
        puts "Encarcelado"
      else
        carta = @jugadorActual.devolverCartaLibertad
        puts "Te libras de la carcel"
        @mazo << carta
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
    end
    
    def getValorDado
      return @dado.valor
    end
    
    def hipotecarPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
      @estadoJuego =(EstadoJuego::JA_PUEDEGESTIONAR)
    end
    
    def inicializarJuego(nombres)
      inicializarJugadores(nombres)
      inicializarTablero
      inicializarCartasSorpresa
      salidaJugadores
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
      if(metodo == MetodoSalirCarcel::TIRANDODADO)
        resultado = tirarDado
        if(resultado >= 5)
          @jugadorActual.encarcelado = false
        end
      elsif (metodo == MetodoSalirCarcel::PAGANDOLIBERTAD)
        @jugadorActual.pagarLibertad(PRECIO_LIBERTAD)   
      end
      
      encarcelado = @jugadorActual.encarcelado
      if(encarcelado)
        @estadoJuego =(EstadoJuego::JA_ENCARCELADO)
      else
        @estadoJuego =(EstadoJuego::JA_PREPARADO) 
      end
      return (!encarcelado)
    end
    
    def jugar
      tirarDado
      casillaFinal = @tablero.obtenerCasillaFinal(@jugadorActual.casillaActual, @dado.valor)
      mover(casillaFinal.numeroCasilla)
    end
    
    def mover(numCasillaDestino)
      casillaInicial = @jugadorActual.casillaActual
      casillaFinal   = @tablero.obtenerCasillaNumero(numCasillaDestino)
      
      @jugadorActual.casillaActual = casillaFinal

      if(numCasillaDestino < casillaInicial.numeroCasilla)
        @jugadorActual.modificarSaldo(SALDO_SALIDA)
      end

      if(casillaFinal.soyEdificable)
        actuarSiEnCasillaEdificable
      else
        actuarSiEnCasillaNoEdificable
      end
    end
    
    def obtenerCasillaJugadorActual
      return @jugadorActual.casillaActual
    end
    
    
    
    def obtenerPropiedadesJugador
      numero_casillas_propiedades_jugador = Array.new
      propiedades = @jugadorActual.propiedades
      casillas = @tablero.casillas
      
      casillas.each do |c|
        propiedades.each do |p|
          if(c.titulo == p)
            numero_casillas_propiedades_jugador << c.numeroCasilla
          end
        end
      end
      
      return numero_casillas_propiedades_jugador
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      n_casillas_jugador = Array.new
      propiedades = @jugadorActual.obtenerPropiedades(estadoHipoteca)
      
      @tablero.casillas.each do |c|
        propiedades.each do |p|
          if(c.titulo == p)
            n_casillas_jugador << c.numeroCasilla
          end
        end
      end
      
      return n_casillas_jugador
    end
    
    def obtenerRanking
      @jugadores=@jugadores.sort
    end
    
    def obtenerSaldoJugadorActual()
      return @jugadorActual.saldo
    end
    
    def salidaJugadores
      @jugadores.each do |j|
        j.casillaActual = @tablero.casillas.at(0)
      end
      primero = rand(0...@jugadores.length)
      @jugadorActual = @jugadores.at(primero)
      @estadoJuego = EstadoJuego::JA_PREPARADO
    end
    

    
   
    
    def siguienteJugador
      index = @jugadores.index(@jugadorActual)
      index = (index + 1)%@jugadores.size
      @jugadorActual = @jugadores.at(index)
      if (@jugadorActual.encarcelado)
        @estadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @estadoJuego = EstadoJuego::JA_PREPARADO
      end
    end
    def tirarDado
      return @dado.tirar 
    end
    
    def venderPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      @jugadorActual.venderPropiedad(casilla)
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
    end
   
    def inicializarCartasSorpresa
      @mazo.clear
      @mazo << Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel", 0, TipoSorpresa::SALIRCARCEL)
      @mazo << Sorpresa.new("Los killos te mandan de paseico", 1, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Lo siento, pero te quitamos un pizquito de tu saldo", 2, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Nos debes dinerico señor, ¡a pagar!", 3, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Killo que te toca pagar, $$$ , MALO MARIA", 4, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Killo que ahora si te llevas el pellizquito", 5, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Los killos te mandan de paseico un ratejo por si no te ha tocado", 6, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Fiuuuuuuu, que alegría que recibes dinerico", 7, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Alegria señora que nos llevamos dinerico", 8, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines, lo sentimos,¡debes ir a la carcel!", 9, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Convertirseee!", 3000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Convertirseee!", 5000, TipoSorpresa::CONVERTIRME)
      @mazo.shuffle
    
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
    def self.getMaxJugadores
      MAX_JUGADORES
    end
    private :encarcelarJugador, :inicializarCartasSorpresa, :inicializarJugadores, :inicializarTablero
    
  end
end
