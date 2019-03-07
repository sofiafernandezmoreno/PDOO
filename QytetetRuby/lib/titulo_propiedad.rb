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
      coste_hipotecar = calcularCosteHipotecar
      
      return coste_hipotecar + 0.1*coste_hipotecar
    end
    
    def calcularCosteHipotecar
       return @hipotecaBase + @numCasas * 0.5 * @hipotecaBase + @numHoteles * @hipotecaBase;
    end

    def calcularImporteAlquiler
        return @alquilerBase + @numCasas*0.5 + @numHoteles*2;
    end
    
    def calcularPrecioVenta
      return  @precioCompra + (@numCasas + @numHoteles) * @precioEdificar * @factorRevalorizacion
    end
    
    def cancelarHipoteca
        hipotecada = false;
    end
    
   
    
    def edificarCasa
      @numCasas += 1
    end
    
    def edificarHotel
      @numHoteles += 1
    end
    
    def hipotecar
     @hipotecada = true
     costeHipoteca = calcularCosteHipotecar
     return costeHipoteca
    end
    
    def pagarAlquiler
      costeAlquiler = calcularImporteAlquiler
      @propietario.modificarSaldo(costeAlquiler)
      return costeAlquiler
    end
    
    def propietarioEncarcelado
      return @propietario.encarcelado
    end
    
    def tengoPropietario
      return (@propietario != nil)
    end
    
    
    
    def to_s
        "\n- - - - - - - - - - - - - - - - - Titulo de propiedad - - - - - - - - - - - - - - - -\nNombre: #{@nombre} \nHipotecada: #{@hipotecada} \nprecioCompra: #{@precioCompra} \nAlquilerBase: #{@alquilerBase} \nfactorRevalorización: #{@factorRevalorizacion} \nhipotecaBase: #{@hipotecaBase} \nprecioEdificar: #{@precioEdificar} \nnumHoteles:   #{@numHoteles} \nnumCasas:  #{@numCasas}"
    end
  end
end
