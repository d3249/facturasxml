# -*- coding: utf-8 -*-

require_relative 'columns.rb'

module FacturasXML
  module OptionsParser

    #Esta clase se utiliza para inicializar un FacturasXML::Reporter
    #
    #Contiene la configuración deseada.
    #Tiene los siguientes valores por defecto:
    #  *[logfile] LOGFILE.log
    #  *[outfile] RESUMEN.csv
    #  *[columnas] Archivo - Fecha - Nombre del emisor - Total (con sus respectivos procedimientos)
    #  *[total] falso (no incluye línea de total por default)
    #  *[directory] +.+ (El directorio desde donde se invocó)
    class Options

      attr_accessor :logfile,:outfile,:cols_headers,:directory,:t_position,:cols_proc_list
      attr_writer :total

      #Inicializa el objeto con los valores por defecto
      def initialize
        @@c_procs = FacturasXML::OptionsParser::COLUMNS_PROCS
        
        @logfile = 'LOGFILE.log'
        @outfile = 'RESUMEN.csv'
        @cols_headers = "Archivo\tFecha\tNombre del emisor\tTotal"
        @total = false
        @t_position = 4
        @directory = "."
        @cols_proc_list = [@@c_procs["a"],
                           @@c_procs["fe"],
                           @@c_procs["en"],
                           @@c_procs["t"]]

      end

      def total?
        @total
      end
    end
  end
end
