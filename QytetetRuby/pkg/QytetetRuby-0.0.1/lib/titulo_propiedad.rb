#encoding: utf-8

module ModeloQytetet
  class TituloPropiedad
    attr_accessor :hipotecada, :propietario
    attr_reader :nombre, :precioCompra, :alquilerBase, :factorRevalorizacion, :hipotecaBase, :precioEdificar, :numHoteles, :numCasas
    
    def initialize(n,p,a,f,h,pr)
      @nombre = n
      @precioCompra = p
      @alquilerBase = a
      @factorRevalorizacion = f
      @hipotecaBase = h
      @precioEdificar = pr
      @hipotecada = false
      @numHoteles = 0
      @numCasas = 0
      @propietario = nil
    end
    
    def calcularCosteCancelar
      raise NotImplementedError
    end
    
    def calcularCosteHipotecar
      raise NotImplementedError
    end
    
    def calcularImporteAlquiler
      raise NotImplementedError
    end
    
    def calcularPrecioVenta
      raise NotImplementedError
    end
    
    def cancelarHipoteca
      raise NotImplementedError
    end
    
    def cobrarAlquiler(coste)
      raise NotImplementedError
    end
    
    def edificarCasa
      raise NotImplementedError
    end
    
    def edificarHotel
      raise NotImplementedError
    end
    
    def hipotecar
      raise NotImplementedError
    end
    
    def pagarAlquiler
      raise NotImplementedError
    end
    
    def propietarioEncarcelado
      raise NotImplementedError
    end
    
    def tengoPropietario
      raise NotImplementedError
    end
    
    
    
    def to_s
        "\n- - - - - - - - - - - - - - - - - Titulo de propiedad - - - - - - - - - - - - - - - -\nNombre: #{@nombre} \nHipotecada: #{@hipotecada} \nprecioCompra: #{@precioCompra} \nAlquilerBase: #{@alquilerBase} \nfactorRevalorización: #{@factorRevalorizacion} \nhipotecaBase: #{@hipotecaBase} \nprecioEdificar: #{@precioEdificar} \nnumHoteles:   #{@hipotecada} \nnumCasas:  #{@numCasas}"
    end
  end
end
