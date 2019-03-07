#encoding: utf-8

require "singleton"

module ModeloQytetet
  class Dado
    include Singleton
    
    attr_reader :valor
    
    def initialize
      @valor = 0
    end
    
    def tirar
      @valor = 1 + rand(6)
      
      return valor
    end
    
    def to_s
      "#{@valor}"
    end
  end
end
