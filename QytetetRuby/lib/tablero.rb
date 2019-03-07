#encoding: utf-8

require_relative "casilla"
require_relative "calle"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"

module ModeloQytetet
  class Tablero
    attr_reader :casillas, :carcel
    
    def initialize
      @carcel = Casilla.new(7, 0, TipoCasilla::CARCEL)
      @casillas = []
      
      inicializar
    end
    
    def inicializar
      
      @casillas = Array.new
    @casillas << Casilla.new(0,0,TipoCasilla::SALIDA)
     @casillas << Casilla.new(1,100,TipoCasilla::PARKING)
     @casillas << Casilla.new(2,100,TipoCasilla::IMPUESTO)
     @casillas << Casilla.new(3,100,TipoCasilla::JUEZ)
     @casillas << Casilla.new(4,0,TipoCasilla::SORPRESA)
     @casillas << Casilla.new(5,0,TipoCasilla::SORPRESA)
     @casillas << Casilla.new(6,0,TipoCasilla::SORPRESA)
     @casillas << Casilla.new(7,0,TipoCasilla::CARCEL)
    
     
  
      
      
      @casillas << Calle.new(8,TituloPropiedad.new("Calle Finisterre",600,50,0.2, 200, 250))
        @casillas << Calle.new(9,TituloPropiedad.new("Calle Loteria", 700,100,0.15, 150, 750))
        @casillas << Calle.new(10,TituloPropiedad.new("Calle Killismo",500, 70,0.1, 220, 650))
        @casillas << Calle.new(11,TituloPropiedad.new("Calle Penitencia", 550,80,0.2, 250, 550))
        @casillas << Calle.new(12, TituloPropiedad.new("Calle Maria Antonieta",750, 60,0.1, 600, 350))
        @casillas << Calle.new(13, TituloPropiedad.new("Calle Cacha",630, 75,0.15, 1000, 450))
        @casillas << Calle.new(14, TituloPropiedad.new("Calle ACDC",550, 90,0.17, 900, 300))
        @casillas << Calle.new(15, TituloPropiedad.new("Calle Lucrecia",600, 55,0.2, 500, 500))
        @casillas << Calle.new(16, TituloPropiedad.new("Calle Orgullo",700, 85,0.2, 400, 400))
        @casillas << Calle.new(17, TituloPropiedad.new("Calle Capilla Ardiente",700, 95,0.1, 600, 350))
        @casillas << Calle.new(18, TituloPropiedad.new("Calle Melancolía",600, 65,0.18, 750, 250))
        @casillas << Calle.new(19, TituloPropiedad.new("Calle Crazy",600, 70,0.1, 500, 600))
     @carcel=@casillas.at(7);
    end
    
    def esCasillaCarcel(numeroCasilla)
      return if numeroCasilla == @carcel.numeroCasilla;
    end
    
    def obtenerCasillaFinal(casilla,desplazamiento)
      return @casillas.at((casilla.numeroCasilla + desplazamiento)%@casillas.size)      
    end
    
    def obtenerCasillaNumero(numeroCasilla)
      
      return @casillas.at(numeroCasilla)
      
    end
    
    def to_s
      puts "************************************ TABLERO QYTETET ************************************\n" 
      
      for i in 0..@casillas.length
        puts @casillas[i]
      end
      
      "Carcel:\n #{@carcel} \n"
    end
    
    private :inicializar
  end
end
