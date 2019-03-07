#encoding: utf-8

module ModeloQytetet
  class Sorpresa
    attr_reader :texto, :valor, :tipo
    
    def initialize(t, v, ti)
      @texto = t
      @valor = v
      @tipo = ti
    end
    
    def to_s
      "Texto: #{@texto} \n Valor: #{@valor} \n Tipo: #{@tipo}"
    end
    
    end
end

