#encoding: utf-8

require_relative "casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"

module ModeloQytetet
  class Tablero
    attr_reader :casillas, :carcel
    
    def initialize
      @carcel = nil;
      @casillas = nil;
      
      inicializar
    end
    
    def inicializar
      @casillas = Array.new
      @casillas << Casilla.crearCartaSinCalle(0, TipoCasilla::SALIDA)
      @casillas << Casilla.crearCartaCalle(1, TituloPropiedad.new("Calle de las teterías", 500, 50, 20, 150, 250))
      @casillas << Casilla.crearCartaSinCalle(2, TipoCasilla::IMPUESTO)
      @casillas << Casilla.crearCartaCalle(3, TituloPropiedad.new("Acera del Darro", 550, 50, 20, 150, 300))
      @casillas << Casilla.crearCartaCalle(4, TituloPropiedad.new("Paseo de los Tristes",550,50,20,150,300))
      @casillas << Casilla.crearCartaSinCalle(5, TipoCasilla::CARCEL)
      @casillas << Casilla.crearCartaCalle(6, TituloPropiedad.new("Cuesta de Gomérez", 600, 60, 10, 400, 400))
      @casillas << Casilla.crearCartaSinCalle(7, TipoCasilla::SORPRESA)
      @casillas << Casilla.crearCartaCalle(8, TituloPropiedad.new("Camino del Sacromonte", 650, 60, 10, 400, 400))
      @casillas << Casilla.crearCartaCalle(9, TituloPropiedad.new("Calle Real de la Alhambra",650,60,10,400,400))
      @casillas << Casilla.crearCartaSinCalle(10, TipoCasilla::PARKING)
      @casillas << Casilla.crearCartaSinCalle(11, TipoCasilla::SORPRESA)
      @casillas << Casilla.crearCartaCalle(12, TituloPropiedad.new("Pedro Antonio de Alarcón", 750, 75, -10, 700, 450))
      @casillas << Casilla.crearCartaCalle(13, TituloPropiedad.new("Gran Vía de Colón",750,75,-10,700,450))
      @casillas << Casilla.crearCartaCalle(14, TituloPropiedad.new("Cuesta de los Chinos",800,75,-10,700,500))
      @casillas << Casilla.crearCartaSinCalle(15, TipoCasilla::JUEZ)
      @casillas << Casilla.crearCartaCalle(16, TituloPropiedad.new("Calle Recogidas", 850, 100, -20, 1000, 600))
      @casillas << Casilla.crearCartaCalle(17, TituloPropiedad.new("Cuesta del Rey Chico", 900, 100, -20, 1000, 700))
      @casillas << Casilla.crearCartaSinCalle(18, TipoCasilla::SORPRESA)
      @casillas << Casilla.crearCartaCalle(19, TituloPropiedad.new("Calle Elvira", 1000, 100, -20, 1000, 750))
      
      @carcel = @casillas.at(5)
    end
    
    def esCasillaCarcel(numeroCasilla)
      return if numeroCasilla == carcel.numeroCasilla;
    end
    
    def obtenerCasillaFinal(casilla,desplazamiento)
      return casillas.casilla.numeroCasilla+desplazamiento%casillas.size
      
    end
    
    def obtenerCasillaNumero(numeroCasilla)
      
      return casillas.numeroCasilla
      
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
