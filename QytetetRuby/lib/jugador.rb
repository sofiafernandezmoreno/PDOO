#encoding: utf-8
module ModeloQytetet
  class Jugador 
    attr_reader :nombre, :propiedades, :saldo
    attr_accessor :cartaLibertad, :casillaActual, :encarcelado
  
    def initialize(name)
      @encarcelado = false
      @nombre = name
      @saldo=7500
      @cartaLibertad = nil
      @casillaActual = nil
      @propiedades = []
    end
    
  
    def cancelarHipoteca(titulo)
      cancelarHipo = false
      if(@saldo < titulo.calcularCosteCancelar)
        cancelarHipo = false;
      else
        coste = titulo.calcularCosteCancelar
        @saldo -= coste
        titulo.cancelarHipoteca
        cancelarHipo = true
      end
    
      return cancelarHipo
    end
  
    def comprarTituloPropiedad
      costeCompra = @casillaActual.coste
      comprado = false
    
      if(costeCompra < @saldo)
        titulo = @casillaActual.asignarPropietario(self)
      
        @propiedades << titulo
      
        modificarSaldo(-costeCompra)
        comprado = true
      end
    
      return comprado
    end
  
    def cuantasCasasHotelesTengo
      total = 0
      @propiedades.each do |p|
        total = total + p.numCasas
        total = total + p.numHoteles
      end
      return total
    end
  
    def deboPagarAlquiler
      titulo = @casillaActual.titulo
      esDeMiPropiedad = esDeMiPropiedad(titulo)
      tienePropietario = titulo.tengoPropietario
    
      if(esDeMiPropiedad)
        deboPagar = false
      elsif (tienePropietario)
        if(titulo.propietarioEncarcelado)
          deboPagar=false
        elsif(!titulo.hipotecada)
          deboPagar = true
        end
      end
    
      return deboPagar
    end
  
    def devolverCartaLibertad
      carta = @cartaLibertad
      @cartaLibertad = nil
     
      return carta
    end
  
    def edificarCasa(titulo)
      edificada = false
    
      if(puedoEdificarCasa(titulo))
        costeEdificarCasa = titulo.precioEdificar
      
        tengoSaldo = tengoSaldo(costeEdificarCasa)
      
        if(tengoSaldo)
          titulo.edificarCasa()
          modificarSaldo(-costeEdificarCasa)
          edificada = true
        end
      end
    
      return edificada
    end
  
    def edificarHotel(titulo)
      edificado = false
      
    
      if(puedoEdificarCasa(titulo))
        costeEdificarHotel = titulo.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarHotel)
      
        if(tengoSaldo)
          titulo.edificarHotel
          modificarSaldo(-costeEdificarHotel)
          edificado = true
        end
      end
    
      return edificado
    end
  
    def eliminarDeMisPropiedades(titulo)
      
      
      titulo.propietario=nil
      @propiedades.delete_at(@propiedades.index(titulo))
    end
  
    def esDeMiPropiedad(titulo)
    
      encontrado = false
    
      @propiedades.each do |p|
        if(p == titulo)
          encontrado = true
        end
      end
      return encontrado
    end
  
  
  
    def hipotecarPropiedad(titulo)
      costeHipoteca = titulo.hipotecar
      modificarSaldo(costeHipoteca)
    end
  
    def irACarcel(casilla)
      casillaActual = casilla
      encarcelado = true
    end
  
    def modificarSaldo(cantidad)
    
      @saldo += cantidad
    
      return saldo
    
    end
  
    def obtenerCapital
      valor_propiedades = 0
      @propiedades.each do |p|
        valor_propiedades += p.precioCompra + ((p.numHoteles + p.numCasas) * p.precioEdificar)
      end
      return @saldo + valor_propiedades
    end
  
    def obtenerPropiedades(hipotecada)
      propiedades_hipotecadas = Array.new
      
      for t in @propiedades
        if t.hipotecada == hipotecada
          propiedades_hipotecadas << t
        end
      end
      
      return propiedades_hipotecadas
    end
  
    def pagarAlquiler
      costeAlquiler = @casillaActual.pagarAlquiler
      modificarSaldo(-costeAlquiler)
    end
  
    def pagarImpuesto
      @saldo -= @casillaActual.coste
    end
  
    def pagarLibertad(cantidad)
    
      tengoSaldo = tengoSaldo(cantidad)
      if(tengoSaldo)
        @encarcelado = false
        modificarSaldo(-cantidad)
      end
    
    end

    def tengoCartaLibertad
      if(@cartaLibertad!= nil)
        return true
      else
        return false
      end
    end
  
    def tengoSaldo(cantidad)
      if(@saldo > cantidad)
        return true
      else
        return false
      end
    end
  
    def venderPropiedad(casilla)
      
      titulo = casilla.titulo
      eliminarDeMisPropiedades(titulo)
      precio_venta = titulo.calcularPrecioVenta
      modificarSaldo(precio_venta)
      puts "Propiedad vendida con exito."
    end
  
    def <=>(otrojugador)
      otroCapital = otrojugador.obtenerCapital
      miCapital = obtenerCapital
      if(otroCapital > miCapital)
        return 1
      end
      if(otroCapital < miCapital)
        return -1
      end
      return 0
    end
  
    def convertirme (fianza)
      puts "Te has convertido en especulador."
      especulador = Especulador.copia(self, fianza)
      return especulador
    end
    
    def deboIrACarcel
      !tengoCartaLibertad
    end
    def puedoEdificarCasa(titulo)
      puedo_edificar = false
      num_casas = titulo.numCasas
      coste_edificar_casa = titulo.precioEdificar
      tengo_saldo = tengoSaldo(coste_edificar_casa)
      
      if num_casas < 4 && tengo_saldo
        puedo_edificar = true
      else
        puts "Actualmente no puedes edificar casa."
      end
      
      return puedo_edificar
      
    end
    def puedoEdificarHotel(titulo)
      puedo_edificar = false
      num_casas = titulo.numCasas
      num_hoteles = titulo.numHoteles
      
      coste_edificar_hotel = titulo.precioEdificar
      tengo_saldo = tengoSaldo(coste_edificar_hotel)
      
      if num_hoteles < 4 && num_casas >= 4 && tengo_saldo
        puedo_edificar = true
      else
        puts "Actualmente no puedes edificar hotel."
      end
      
      return puedo_edificar
      
    end
  
  


    def to_s
      
      str = String.new
      str<<"- - - - - - -  Jugador: #{@nombre}- - - - - - -  { " +
              "\n  Encarcelado: #{@encarcelado}" +
              "\n  Nombre: #{@nombre}" +
              "\n  Saldo: #{@saldo}" +
              "\n  Capital: #{obtenerCapital.to_s}" +
              "\n  Carta Libertad: #{@cartaLibertad}" +
              "\n  Casilla Actual: #{@casillaActual}" +
              "\n  Propiedades: "              
                    for t in @propiedades
                      str<< "#{t} \n"
                    end
              
      return str 
  end
    protected 
    def self.copia(nombre)
      new(nombre)
    end
    
  end
end