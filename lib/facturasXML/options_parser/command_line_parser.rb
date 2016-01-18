# -*- coding: utf-8 -*-

require 'optparse'

require_relative 'columns.rb'
require_relative 'options_class.rb'
require_relative '../logger/logger.rb'


module FacturasXML
  module OptionsParser

    #Esta clase analiza la entrada de la línea de comandos y crea un objeto
    #FacturasXML::OptionsParser::Options que puede ser usado para inicializar el FacturasXML::Reporter
    class CommandLineParser

      extend FacturasXML::Log

      #Método de clase que crea un objeto Options
      def self.parse(command_line)
        
        log.debug{"Opciones dadas: #{command_line}"}
        
        parser = self.init_parser

        @@options = FacturasXML::OptionsParser::Options.new

        parser.parse(command_line)

        @@options
      end

      private
      #Definición del parser
      def self.init_parser
        OptionParser.new do |opts|
          
          opts.on("-L",
                  "--logfile LOGFILE",
                  "Nombre del archivo de registro") do |l|
            log.debug{"Se detectó un archivo para log: #{l}"}
            raise "Se debe especificar el  nombre de archivo" if l =~ /^-/
            raise "Nombre de archivo inválido" if l =~ /^\S*\s+\S*/
            logfile(l)
          end
          
          opts.on("-N",
                  "--no-total",
                  "No agregar una línea final con el total") do
            log.debug{"Se detectó No Total"}
            total(false)
          end

          opts.on("-O",
                  "--output FILE",
                  "Archivo de salida") do |file|
            log.debug{"Se detectó archivo de salida: #{file}"}
            raise "Se debe especificar el  nombre de archivo" if file =~ /^-/
            outfile(file)
            
          end

          opts.on("-D",
                  "--directory DIR",
                  "Directorio de los archivos XML") do |dir|
            log.debug{"Se detectó directorio: #{dir}"}
            raise "Se debe especificar la ruta del directorio" if dir =~ /^-/
            dir = dir.slice(0,dir.size - 1) if dir =~ /\/$/
            directory(dir)
            
          end

          opts.on("-T",
                  "--total POS",
                  "Agrega una línea al final con el total en la columna POS") do |pos|
            log.debug{"Se detectó total. Posición #{pos}"}
            raise "Se debe especificar la posición" if pos =~ /^-/
            total(true)
            t_position(pos.to_i)
          end

          opts.on("-C",
                  "--columns COLS",
                  "Espeficica las columnas deseadas en el reporte. Las columnas se dan como una lista de elementos separados por coma sin espacio") do |cols|

            log.debug{"Se detectó lista de columnas: <#{cols}>"}
            raise "Se debe especificar una lista de columnas" if cols =~ /^-/
            c_list = cols.split(",")

            cols_headers(c_list)
            cols_proc_list(c_list)
            
          end
              
          opts.on("-h",
                  "--help",
                  "Muestra este mensaje") do
            puts opts
            exit
          end
        end
      end

      #Asignación del atributo logfile
      def self.logfile(logfile)
        @@options.logfile=logfile
      end

      #Asignación del atributo outfile
      def self.outfile(outfile)
        @@options.outfile=outfile
      end

      #Asignación del atributo cols_headers
      def self.cols_headers(c_list)
        c_headers = FacturasXML::OptionsParser::COLUMNS_HEADERS
        headers = ""
        c_list.each { |c| headers += c_headers[c] + "\t" }
        @@options.cols_headers= headers
      end

      #Asignación del atributo directory
      def self.directory(dir)
        @@options.directory= dir
      end

      #Asignación del atributo t_position
      def self.t_position(pos)
        @@options.t_position= pos
      end

      #Asignación del atributo cols_proc_list
      def self.cols_proc_list(c_list)
        c_procs = FacturasXML::OptionsParser::COLUMNS_PROCS
        list = []
        c_list.each {|c| list << c_procs[c] }
        @@options.cols_proc_list= list
      end

      #Asignación del atributo total
      def self.total(bool)
        @@options.total= bool  
      end
      
    end
    
  end
end
        
        
    
