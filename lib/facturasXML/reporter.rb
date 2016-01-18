# -*- coding: utf-8 -*-

require_relative "factura.rb"
require_relative "logger/logger.rb"
require_relative "core/core.rb"

module FacturasXML

    #Esta clase implementa los métodos del módulo #Core para crear un reporte de facturas XML
    class Reporter

      extend FacturasXML::Log
      include FacturasXML::Core

      #Se inicializa con un objeto de tipo #Options
      def initialize(options)
        log.info {"Creando Reporter"}
        @options = options
      end

      #Crea el reporte con las opciones dadas
      def make_report
        create_summary(@options)
      end

    end
       
end
