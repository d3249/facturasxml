#*-* encoding: utf-8 *-*

require "logger"

module FacturasXML
  module Log

    @level=Logger::ERROR
    @out=STDOUT

    #Inicializa el logger con los valores por default
    def inicializar_logger
      @logger = Logger.new(@out)
      @logger.level=@level
      @logger
    end

    #Devuelve el objeto logger
    def log
      @logger ||= inicializar_logger
    end

  end
end
