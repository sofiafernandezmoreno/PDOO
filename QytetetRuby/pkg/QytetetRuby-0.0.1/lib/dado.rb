#encoding: utf-8

require "singleton"

module ModeloQytetet
  class Dado
    include Singleton
    
    attr_reader :valor
    
    def initialize
      @valor = 0
    end
    
    
    def to_s
      "Dado : valor - #{@valor}"
    end
  end
end
