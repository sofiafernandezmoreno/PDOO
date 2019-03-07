# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Jugador
  attr_reader :nombre, :propiedades, :saldo
  attr_accessor :cartaLibertad, :casillaActual, :encarcelado
  def initialize(name)
    @encarcelado = false
    @nombre = name
    @saldo=7500
    @cartaLibertad = nil
    @casillaActual = nil
    @propiedades = Array.new
  end
  
  def cancelarHipoteca(titulo)
    raise NotImplementedError
  end
  
  def comprarTituloPropiedad
    raise NotImplementedError
  end
  
  def cuantasCasasHotelesTengo
    total = 0
    propiedades.each do |p|
      total = total + p.numCasas
      total = total + p.numHoteles
    end
    return total
  end
  
  def deboPagarAlquiler
    raise NotImplementedError
  end
  
  def devolverCartaLibertad
     carta = cartaLibertad
     cartaLibertad = nil
     
    return carta
  end
  
  def edificarCasa(titulo)
    raise NotImplementedError
  end
  
  def edificarHotel(titulo)
    raise NotImplementedError
  end
  
  def eliminarDeMisPropiedades(titulo)
    raise NotImplementedError
  end
  
  def esDeMiPropiedad(titulo)
    
    encontrado = false
    
    propiedades.each do |p|
      if(p == @titulo)
        encontrado = true
      end
    end
    return encontrado
  end
  
  def estoyEnCalleLibre
    raise NotImplementedError
  end
  
  def hipotecarPropiedadTitulo(titulo)
    raise NotImplementedError
  end
  
  def irACarcel(casilla)
    raise NotImplementedError
  end
  
  def modificarSaldo(cantidad)
    
    @saldo += cantidad
    
    return saldo
    
  end
  
  def obtenerCapital
    valor_propiedades = 0
    propiedades.each do |p|
      valor_propiedades += p.precioCompra + ((p.numHoteles + p.numCasas) * p.precioEdificar)
    end
    return @saldo + valor_propiedades
  end
  
  def obtenerPropiedades(hipotecada)
    propiedades_p = Array.new 
    
    propiedades.each do |p|
      if(@estadoHipoteca == p.hipotecada)
        propiedades << p
      end
      
    end
    return propiedades_p
  end
  
  def pagarAlquiler
    raise NotImplementedError
  end
  
  def pagarImpuesto
   
    saldo -= @casillaActual.coste
    
  end
  
  def pagarLibertad(cantidad)
    raise NotImplementedError
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
    raise NotImplementedError
  end
  
  def <=>(otrojugador)
    otroCapital = otroJugador.obtenerCapital
    miCapital = obtenerCapital
    if(otroCapital > miCapital)
      return 1
    end
    if(otroCapital < miCapital)
      return -1
    end
    return 0
  end
  
  
  def to_s 
    "- - - - - - -  Jugador: #{@nombre} - - - - - - - \ncartaLibertal : #{@cartaLibertad} \ncasillaActual: #{@casillaActual} \nEncarcelado: #{@encarcelado} \nPropiedades: #{@propiedades} \nSaldo: #{@saldo} \n Capital:" + obtenerCapital
  end
end
