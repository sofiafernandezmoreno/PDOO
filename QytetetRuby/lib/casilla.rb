#encoding: utf-8

module ModeloQytetet
  class Casilla
    
    attr_reader :numeroCasilla, :tipo
    attr_accessor :coste
    def initialize(n,c,t)
      @coste = c
      @numeroCasilla = n
      @tipo = t
      
    end
    
    def titulo
      return nil
    end
    
    def soyEdificable
      return false
    end
   
    def to_s
      texto = "Numero de la casilla: #{@numeroCasilla}\nCoste de la casilla: #{@coste}\nTipo de casilla: #{@tipo}\n"
       
      texto
    end
  end
end
