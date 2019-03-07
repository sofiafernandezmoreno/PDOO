#encoding: utf-8
require_relative "qytetet"
require_relative "opcion_menu"
require_relative "estado_juego"
require_relative "metodo_salir_carcel"
require "singleton"
module ControladorQytetet
  class Controlador_Qytetet
    include ModeloQytetet
    include Singleton
    attr_accessor :modelo, :nombreJugadores
   
    def initialize
      @nombreJugadores = []
      @modelo = Qytetet.instance
      
    end
    def obtenerOperacionesJuegoValidas
      
      operaciones_validas = Array.new
      estado = @modelo.estadoJuego
      
      operaciones_validas.clear
      
      if @modelo.jugadores.empty?
        operaciones_validas << OpcionMenu.index(:INICIARJUEGO)
      else
        case estado
        when ModeloQytetet::EstadoJuego::JA_CONSORPRESA
          operaciones_validas << OpcionMenu.index(:APLICARSORPRESA)
        when ModeloQytetet::EstadoJuego::ALGUNJUGADORENBANCARROTA
          operaciones_validas << OpcionMenu.index(:OBTENERRANKING)
        when ModeloQytetet::EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
          operaciones_validas << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:VENDERPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:CANCELARHIPOTECA)
          operaciones_validas << OpcionMenu.index(:EDIFICARCASA)
          operaciones_validas << OpcionMenu.index(:EDIFICARHOTEL)
          operaciones_validas << OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
        when ModeloQytetet::EstadoJuego::JA_PUEDEGESTIONAR
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
          operaciones_validas << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:VENDERPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:CANCELARHIPOTECA)
          operaciones_validas << OpcionMenu.index(:EDIFICARCASA)
          operaciones_validas << OpcionMenu.index(:EDIFICARHOTEL)
        when ModeloQytetet::EstadoJuego::JA_PREPARADO
          operaciones_validas << OpcionMenu.index(:JUGAR)
        when ModeloQytetet::EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
          operaciones_validas << OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
          operaciones_validas << OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
        when ModeloQytetet::EstadoJuego::JA_ENCARCELADO
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
        end
      end
      
      
      operaciones_validas << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
      operaciones_validas << OpcionMenu.index(:MOSTRARJUGADORES)
      operaciones_validas << OpcionMenu.index(:MOSTRARTABLERO)
      operaciones_validas << OpcionMenu.index(:TERMINARJUEGO)
      
      return operaciones_validas
    
    end
    
    
    
    def necesitaElegirCasilla(opcionMenu)
      opcion = OpcionMenu.at(opcionMenu)
      return opcion == OpcionMenu.at(OpcionMenu.index(:HIPOTECARPROPIEDAD)) || opcion == OpcionMenu.at(OpcionMenu.index(:CANCELARHIPOTECA)) ||
        opcion == OpcionMenu.at(OpcionMenu.index(:EDIFICARCASA)) || opcion == OpcionMenu.at(OpcionMenu.index(:EDIFICARHOTEL)) ||
        opcion == OpcionMenu.at(OpcionMenu.index(:VENDERPROPIEDAD))
    end
    def obtenerCasillasValidas(op_menu)
      lista_casillas = Array.new
     
      if(OpcionMenu.at(op_menu) == :EDIFICARCASA || OpcionMenu.at(op_menu) == :EDIFICARHOTEL ||
         OpcionMenu.at(op_menu) == :VENDERPROPIEDAD)
       lista_casillas = @modelo.obtenerPropiedadesJugador
      else
        case OpcionMenu.at(op_menu)
        when :HIPOTECARPROPIEDAD
          lista_casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
        when :CANCELARHIPOTECA
          lista_casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true)
        end
      end
      
      return lista_casillas
    end
    def realizarOperacion(opcionElegida,casillaElegida)
      opcion = OpcionMenu.at(opcionElegida)
      mensaje = ""
      if (opcion == OpcionMenu.at(OpcionMenu.index(:INICIARJUEGO)) )
        @modelo.inicializarJuego(@nombreJugadores)
            
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:JUGAR) ))
        @modelo.jugar
        mensaje = mostrar( "El dado ha sido tirado y ha salido un:  #{@modelo.dado} .\n#{@modelo.obtenerCasillaJugadorActual}")
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:APLICARSORPRESA)) )
        mensaje = mostrar("Sorpresa aplicada:  #{@modelo.cartaActual.to_s}")
        @modelo.aplicarSorpresa
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD))) 
        @modelo.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
        if (@modelo.jugadorActual.encarcelado) 
          mensaje = mostrar("No se pudo salir de la cárcel.")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO) ))
        @modelo.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
        if (@modelo.jugadorActual.encarcelado) 
          mensaje = mostrar("No se pudo salir de la cárcel.")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:COMPRARTITULOPROPIEDAD)) )
        comprado = @modelo.comprarTituloPropiedad

        mensaje = mostrar("Comprada propiedad")
        if (!comprado) 
          mensaje = mostrar("No se pudo comprar. ")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:CANCELARHIPOTECA)) )
        cancelada = @modelo.cancelarHipoteca(casillaElegida)
          
        if (!cancelada) 
          mensaje = mostrar("No se pudo cancelar. ")
            
        else
          mensaje = mostrar("Cancelada hipoteca")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:EDIFICARCASA)) )
        sepudo = @modelo.edificarCasa(casillaElegida)
        if (!sepudo) 
          mensaje = mostrar("No se pudo edificar la casa. ")
            
        else
          mensaje = mostrar("Edificada la casa. ")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:EDIFICARHOTEL)) )
        sepudo = @modelo.edificarHotel(casillaElegida)
        if (!sepudo) 
          mensaje = mostrar("No se pudo edificar el hotel. ")
            
        else
          mensaje = mostrar("Edificado el hotel. ")
        end
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:VENDERPROPIEDAD)) )
        @modelo.venderPropiedad(casillaElegida)
        mensaje = mostrar("Vendida propiedad. ")

      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:PASARTURNO)) )
        @modelo.siguienteJugador
        mensaje = mostrar("Siguiente jugador. ")
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:OBTENERRANKING)) )
        @modelo.obtenerRanking
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:TERMINARJUEGO)) )
        puts "FIN QYTETET"
        exit 
            
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:MOSTRARJUGADORACTUAL)) )
        
        mensaje = mostrar(@modelo.jugadorActual)
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:MOSTRARJUGADORES)) )
        mensaje = mostrar(@modelo.jugadores)
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:MOSTRARTABLERO)) )
        mensaje = mostrar(@modelo.tablero.to_s)
      elsif (opcion == OpcionMenu.at(OpcionMenu.index(:HIPOTECARPROPIEDAD)) )
        @modelo.hipotecarPropiedad(casillaElegida)
        mensaje = mostrar( "Hipotecada propiedad. ")
      end
        

      return mensaje
      
    end
    def mostrar(texto)
      puts texto
    end
    
  end
    
end




