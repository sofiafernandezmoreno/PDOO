#encoding: utf-8

require_relative "sorpresa"
require_relative "qytetet"
require_relative "tablero"

# Este archivo actúa como "main" del proyecto

module ModeloQytetet
  class PruebaQytetet
    @@juego = Qytetet.instance
   
    def self.main
      # ------------------ SESION 2 ------------------------
      
      tablero = Tablero.new
      puts tablero
      
      puts @@juego.jugadores
      
      nombres = Array.new
      nombres << "Julian"
      nombres << "Victor"
      
      @@juego.inicializarJuego(nombres)
      puts @@juego
    end
    
    # Devuelve un Array que contiene cartas con valor mayor que 0
    def self.getSorpresasMayor0
      
      mayores = Array.new
     
      for i in @@juego.mazo
        if(i.valor > 0)
          mayores.push(i)
        end
      end 
      return mayores
    end 
    
    # Devuelve un Array que contiene las cartas sorpresa del mazo que sean del tipo IRACASILLA
    def self.getSorpresaCasilla
      
      casillas = Array.new
      
      for i in @@juego.mazo
        if(i.tipo == TipoSorpresa::IRACASILLA)
          casillas.push(i)
        end
      end
      
      return casillas
    end
    
    # Devuelve un Array que contiene cartas del tipo indicado en el parámetro
    def self.getSorpresasTipo(tipo)
      
      tipos = Array.new
      for i in @@juego.mazo
        if(i.tipo ==tipo)
          tipos.push(i)
        end
      end
      
      return tipos
    end   
    
    def self.getNombreJugadores
      puts "indica el número de jugadores de la partida:"
      n_jugadores = gets
      
      nombres = Array.new
      for i in 0..n_jugadores
        nombres << gets
      end
    end
    
  end
  
    
  PruebaQytetet.main
  
  # ------------------ SESION 1 ------------------------
  puts "**************** PRUEBA DE MÉTODOS DE LA SESIÓN 1 **********************"
  puts "MOSTRANDO SORPRESAS CON VALOR MAYOR QUE 0..."
  puts PruebaQytetet.getSorpresasMayor0
  puts "------------------------------------------------------------------------"
  
  puts "MOSTRANDO LAS CARTAS DE TIPO CASILLA..."
  puts PruebaQytetet.getSorpresaCasilla
  puts "------------------------------------------------------------------------"
  
  puts "MOSTRANDO LAS CARTAS DE TIPO PORJUGADOR..."
  puts PruebaQytetet.getSorpresasTipo(TipoSorpresa::PORJUGADOR)
  puts "------------------------------------------------------------------------"

end 





