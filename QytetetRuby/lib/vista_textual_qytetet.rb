#encoding: utf-8
require_relative "controlador_qytetet"
require_relative "qytetet"


module VistaTextualQytetet 
  class Vista_Textual_Qytetet
    include ControladorQytetet
    include ModeloQytetet
    
    
    def initialize
      @@modelo = Qytetet.instance
      @@controlador = Controlador_Qytetet.instance
    
    end
  

def obtenerNombreJugadores
      nombres = Array.new
      n = 0
      
      puts "Introduzca número de jugadores: "
      n=gets.chomp.to_i
      
      if n <= Qytetet.getMaxJugadores and n >= 2
        for i in 0...n
          puts "Escribe el nombre del jugador #{i}: "
          cadena = gets
          nombres << cadena
        end
      end
      nombres
    end
    def elegirCasilla(opcionMenu)
      lista = @@controlador.obtenerCasillasValidas(opcionMenu)
      
      if(!lista.empty?)
        puts lista.to_s 
        
        valido = false
        
        begin
          puts "Introduzca la casilla a elegir: "
          lectura = gets.chomp.to_i
          
          for i in lista
            if lectura == i
              valido = true
            end
          end
          
          if(valido)
            return lectura
          end
        end while(!valido)
      else
        return -1
      end
    
    end
    def leerValorCorrecto(valoresCorrectos)
      valido = false
      begin 
        puts "Introduzca un valor valido: "
        lectura = gets.chomp
        
        for i in valoresCorrectos
          if lectura == i
            valido = true
          end
        end
        
        if !valido
          puts "ERROR! Seleccion erronea \n"
        end
        
      end while(!valido)
      return lectura
    
    end
    def elegirOperacion
      
      op = @@controlador.obtenerOperacionesJuegoValidas
      ops = []
      puts "\nOrdenes disponibles"
      
      op.each do |num|  
        puts "#{OpcionMenu.at(num)}(#{num})"
        ops << num.to_s
      end
      return Integer(leerValorCorrecto(ops))
    
    end

    def self.main
      ui = Vista_Textual_Qytetet.new
      
      @@controlador.nombreJugadores = ui.obtenerNombreJugadores
      
      operacionElegida = 0
      casillaElegida = 0
      
      while(true)
        puts "Estado juego: #{@@modelo.estadoJuego}"
        
        operacionElegida = ui.elegirOperacion
        
        necesitaElegirCasilla = @@controlador.necesitaElegirCasilla(operacionElegida)
        
        
        if necesitaElegirCasilla == true
          casillaElegida = ui.elegirCasilla(operacionElegida)
        end
        if necesitaElegirCasilla==false || casillaElegida >= 0
          puts @@controlador.realizarOperacion(operacionElegida,casillaElegida)
          
        end
        
        end 
      
    end
    
    
  end
  Vista_Textual_Qytetet.main
end
