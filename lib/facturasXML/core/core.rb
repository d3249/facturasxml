#!/usr/bin/env ruby
#*-* coding: utf-8 *-*
#
#

#

#

require_relative "../logger/logger.rb"
require_relative "../factura.rb"

# El objetivo de este proyecto es crear una serie de funciones para el ágil procesamiento
# de facturas electrónicas emitidas en México.
module FacturasXML
  # Se usa una librería (nokogiri) para analizar un archivo XML en busca de los elementos
  #
  # Otra función hará uso de la anterior para procesar una lista de archivos y hacer un resumen
  # en un archivo de valores separados por tabuladores (csv) el cual puede ser abierto con un editor
  # de hojas de cálculo (v.g. MS Excell o LibreOffice Calc).
  #
  # Las funciones de este módulo están pensadas para el manejo de un gran número de archivos XML,
  # por lo que hace uso de procesamiento en paralelo (multiples hilos). Por esta razón no se puede
  #garantizar un orden en el resultado, sin embargo esto puede solucionarse facilmente con cualquier editor de hojas de cálculo.#  module Core

  include FacturasXML::Log
    
    @acum = 0.0
    
    ##Crea la línea específica de cada archivo e incrementa el monto acumulado.
    def parsefile(file, cols)

      log.info {"Core:: Inicia análisis del archivo #{file}"}
    
      begin
        log.debug {"\tCore:: Intentando crear el archivo #{file}"}
        factura = FacturasXML::Factura.new(file)        
        @acum += factura.total.to_f        
      rescue FacturasXML::Error::FacturasXMLError => ex
        log.warn{"Core:: #{file}! #{ex.class}: #{ex}"}
        return
      end
      
      line = ""        
    
      cols.each do |c|
        line +=  c.call(factura) + "\t"
      end

      log.debug {"\tCore:: #{file}:: #{line}"}
    
      line

    end

  ##Toma el contenido de un directorio y crea un array con los archivos
  # XML encontrados
  def scandir(path)

    xml_files = []

    Dir.entries(path).each { |file| xml_files << file if file =~ /\.xml$/i }

    xml_files
    
  end

  ##Crea los hilos que serán ejecutados para analizar los archivos XML encontrados
  def create_threads(path, xml_files, cols, summary, logfile)

    threads = []

    mutex = Mutex.new
    
    xml_files.each do |xml|
      threads << Thread.new("#{path}/#{xml}") do |f|

        linea = parsefile(f,cols)

        if linea
          mutex.lock
          summary.puts(linea)
          mutex.unlock
        else
          mutex.lock
          log.error{"Core:: #{f} no es una factura válida"}
          logfile.puts("#{Time.now} El archivo #{f} no es una factura válida")
          mutex.unlock          
        end
      end

    end

    threads
    
  end
  
  ##Genera los archivos de resumen y de registro
  # Hace uso del resto de las funciones para obtener la información necesaria.
  def create_summary(options)

    path = options.directory
    logfile_name = options.logfile
    file_name = options.outfile
    total = options.total?
    headers = options.cols_headers
    cols = options.cols_proc_list

    File.open("#{path}/#{logfile_name}","w") do |logfile|
      File.open("#{path}/#{file_name}","w") do |summary|

        logfile.puts("#{Time.now} Iniciando")
  
        summary.puts(headers)

        @acum = 0.0
      
        xml_files = scandir(path)

        logfile.puts("#{Time.now} Archivos XML encontrados: #{xml_files.size}")

        create_threads(path, xml_files, cols, summary, logfile).each { |t| t.join }

        summary.puts(create_total_line(options.t_position,@acum)) if total

        logfile.puts("#{Time.now} Monto total de los comprobantes: #{@acum}")
        logfile.puts("#{Time.now} Terminado")

      end
    end
  end

  #Crea la línea final de Total en caso de haber sido requerida.
  def create_total_line(position,value)
    line = ""
    
    (position-2).times {line += "\t"}

    line += "TOTAL\t#{value}"
  end
  

  end
  
end
  
