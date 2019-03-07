#encoding: utf-8
require_relative "jugador.rb"
module ModeloQytetet
  class Especulador < Jugador
    attr_accessor :fianza
    def initialize(jugador,f)
      super(jugador)
      @fianza = f
    end
    def self.copia(unJugador,fianza)
      new(unJugador,fianza)
    end
    def convertirme(fianza)
      return self
    end
   
    def deboIrACarcel
      return super.deboIrACarcel && !pagarFianza
    end
    def pagarFianza
      pagada = super.tengoSaldo(@fianza)
      if(pagada)
        super.modificarSaldo(-@fianza)
      end
      return pagada
    
    end
    def pagarImpuesto
      super.pagarImpuesto(-@casillaActual.coste/2)
      
    end
    def puedoEdificarCasa(titulo)
      if(super.tengoSaldo(titulo.precioEdificar) && titulo.numCasas < 8)
        return true
      end
      return false
    
    end
    def puedoEdificarHotel(titulo)
      if(super.tengoSaldo(titulo.precioEdificar) && titulo.numHoteles<8 && titulo.numCasas >= 4)
        return true
      end
      return false
    
    end
    
    
      
      def to_s
        return super.to_s + "\nEspeculador:  Fianza #{@fianza}"
      end
      
    
    protected :initialize, :convertirme, :deboIrACarcel, :puedoEdificarCasa,:pagarImpuesto, :puedoEdificarHotel
  end
end
