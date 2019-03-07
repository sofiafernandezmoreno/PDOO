#encoding: utf-8

module ModeloQytetet
  class Casilla
    attr_accessor :titulo
    attr_reader :numeroCasilla, :precioCompra, :tipo, :coste
    
    def initialize(n,p,t,ti)
      @coste = p
      @numeroCasilla = n
      @precioCompra = p
      @tipo = t
      @titulo = ti
    end
    
    def self.crearCartaCalle(n,ti)
      new(n,ti.precioCompra,TipoCasilla::CALLE,ti)
    end
    
    def self.crearCartaSinCalle(n,t)
      new(n,nil,t,nil)
    end
    
    def asignarPropietario(jugador)
      raise NotImplementedError
    end
    
    def pagarAlquiler
      raise NotImplementedError
    end
    
    def propietarioEncarcelado
      raise NotImplementedError
    end
    
    def soyEdificable
      raise NotImplementedError
    end
    
    def tengoPropietario
      raise NotImplementedError
    end
    
    def to_s
      
      if(@tipo == TipoCasilla::CALLE)
        return "--------------------------------- Casilla nº #{@numeroCasilla} --------------------------------------- \nTipo: #{@tipo} \nPrecio de Compra: #{@precioCompra} \nTitulo: #{@titulo} \n"
      else
        return "--------------------------------- Casilla nº #{@numeroCasilla} --------------------------------------- \nTipo: #{@tipo} \n";
      end
      
    
    end
  end
end
