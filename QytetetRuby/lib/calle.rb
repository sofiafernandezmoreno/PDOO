#encoding: utf-8
module ModeloQytetet
  require_relative "casilla"

  class Calle < Casilla
    attr_reader :titulo
    def initialize(numeroCasilla, titulo)
      super(numeroCasilla, titulo.precioCompra,TipoCasilla::CALLE) 
      @titulo = titulo
    end
    
    def asignarPropietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    def pagarAlquiler
      costeAlquiler = @titulo.pagarAlquiler

      return costeAlquiler
    end

    def soyEdificable
      return true
    end

    def tengoPropietario
      @titulo.tengoPropietario
    end
    
    def to_s
      texto = super.to_s
      texto += "Titulo: "
      
      unless @titulo == nil
        texto << "#{@titulo}"
      end
        
      texto
    end
  end
end
