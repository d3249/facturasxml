# *-* encoding: utf-8 *-*

# Este módulo contiene las clases para modelar una factura
# XML según los estándares mexicanos.
#
# Los datos (atributos) que aparecen en las facturas no son consistentes
# por lo que aquí queda sólo una representación general con los que se consiera
# son los más usados.
#
# Para cualquier otro campo, se proveen tres métodos púbicos:
#
# *recuperar_nodo(NOMBRE) donde NOMBRE corresponde a la etiqueta XML 
#
# *recuperar_atributo(NODO,NOMBRE) donde NODO es un nodo recuperado y NOMBRE es
# atributo que se busca.
#
# *recuperar_nodos(NOMBRE) igual que recuperar_nodo, pero se usa cuando hay más
# de una instancia del nodo, por ejemplo Concepto y Traslado.
#
#
# El árbol del documeto que se utilizó se puede revisar en el archivo ../files/arbol
# 


module FacturasXML

  require 'nokogiri'
  require_relative 'logger/logger.rb'
  require_relative 'error/facturasXML_error.rb'

  #Este es un contenedor para el documento XML.
  #
  #Se inicializa con un archivo y lee los nodos y atributos definidos
  #
  #Se consideran indispensables los nodos +Emisor+, +Comprobante+ y +Receptor+, así como sus atributos.
  #Si falla alguno de estos se lanza un #FacturasXML::Error::FacturasXMLError
  class Factura

    include FacturasXML::Log
    
    attr_reader :nombre_de_archivo, :conceptos, :impuestos

    #Inicializa la Factura con el archivo dado
    def initialize(ruta_de_archivo)
      @nombre_de_archivo = ruta_de_archivo.split(/\/|\\/)[-1]
      @xml_document = File.open(ruta_de_archivo) { |f| Nokogiri::XML(f) }

      ##Se recuperan los tres nodos principales
      @comprobante = recuperar_nodo("Comprobante")
      @emisor = recuperar_nodo("Emisor")
      @receptor = recuperar_nodo("Receptor")

      ##Se recuperan los nodos secundarios
      @emisor_domicilio = recuperar_nodo("DomicilioFiscal")
      @emisor_expedido_en = recuperar_nodo("ExpedidoEn")
      @emisor_regimen = recuperar_nodo("RegimenFiscal")
      @receptor = recuperar_nodo("Receptor")
      @receptor_domicilio = recuperar_nodo("Domicilio")

      cargar_conceptos(recuperar_nodos("Concepto"))
      cargar_impuestos(recuperar_nodos("Traslado"))
      
    end

    protected
    #Itera sobre los nodos hijo de un nodo_padre dado y crea objetos de tipo #Concepto
    def cargar_conceptos(nodo_padre)

      @conceptos = []

      nodo_padre.each do |concepto|
        @conceptos << FacturasXML::Concepto.new(concepto)
      end

    end
    
    #Itera sobre los nodos hijo de un nodo_padre dado y crea objetos de tipo #Impuesto
    def cargar_impuestos(nodo_padre)

      @impuestos = []

      nodo_padre.each do |impuesto|
        @impuestos << FacturasXML::Impuesto.new(impuesto)
      end
      
    end
    
    public    
    #Busca un nodo único en el documento por nombre. Si falla y se buscaba uno de los nodos principales
    #(+Comprobante+, +Emisor+ o +Receptor+) se lanza un #FacturasXML::Error::FactruasXMLError. Para cualquier
    #otro regresa nil
    def recuperar_nodo(nombre)

      log.debug{"Factura:: Recuperando el nodo <#{nombre}>"}
      
      begin

        nodo = @xml_document.at_css("cfdi|#{nombre}") unless nodo = @xml_document.at_css(nombre)

        raise FacturasXML::Error::FacturasXMLError.new unless nodo     

      rescue Nokogiri::XML::XPath::SyntaxError, FacturasXML::Error::FacturasXMLError => ex

        if nombre =~ /Comprobante|Emisor|Receptor/
          log.error{"Factura:: #{@nombre_de_archivo} no es una factura válida. No se pudo recuperar el nodo <#{nombre}>"}
          raise FacturasXML::Error::FacturasXMLError.new("Factura inválida: #{@nombre_de_archivo}")
        end
        
        log.warn{"Factura:: No existe el nodo <#{nombre}> en el archivo #{@nombre_de_archivo}"}
        nodo = nil
      end
        
      nodo
      
    end
    #Busca todos los nodos de documento del nombre dado.
    def recuperar_nodos(nombre)

      nodo = @xml_document.css(nombre)

      begin
        nodo = @xml_document.css("cfdi|#{nombre}") if nodo.size == 0
      rescue Nokogiri::XML::XPath::SyntaxError => ex
        log.warn("Factura:: No existen nodos del tipo <#{nombre}> en #{@nombre_de_archivo}")
        nodo = []
      end
       
      nodo
        
    end

    #Regresa el valor como string del atributo del nodo
    #
    #Si es un nodo principal (+Comprobante+, +Emisor+ o +Receptor+) y el atributo no se
    #encuentra se lanza un #FacturasXML::Error::FacturasXMLError
    #
    #Si se proporciona nil como nodo, se regresa una cadena vacía
    def recuperar_atributo(nodo, atributo)
      
      return "" unless nodo

      result = nodo.attribute(atributo).to_s

      log.debug{"Factura:: #{nombre_de_archivo}: #{atributo} = #{result}"}
      
      if result.empty? && [@comprobante,@emisor,@receptor].member?(nodo)
        log.error{"Factura:: #{@nombe_de_archivo}! No se encontró el atributo #{atributo}"}
        raise FacturasXML::Error::FacturasXMLError.new("Error. Factura inválida")
      end

      return result
      
    end

    #Regresa el RFC del emisor seguido del total de la factura
    def to_s
      emisor_rfc + " " + total
    end

    #Regresa la fecha de la factura
    def fecha
     recuperar_atributo(@comprobante,"fecha")
    end
    
    #Regresa el nombre del emisor de la factura
    def emisor_nombre
     recuperar_atributo(@emisor,"nombre")
    end
    
    #Regresa el total de la factura
    def total
     recuperar_atributo(@comprobante,"total")
    end

    #Regresa el Lugar de Expedición de la factura
    def lugar_expedicion
      recuperar_atributo(@comprobante,"LugarExpedicion")
    end
    
    #Regresa el Método de Pago de la factura
    def metodo_de_pago
      recuperar_atributo(@comprobante,"metodoDePago")
    end

    #Regresa el Tipo de Comprobante de la factura
    def tipo_de_comprobante
      recuperar_atributo(@comprobante,"tipoDeComprobante")
    end

    #Regresa el sub total de la factura
    def subtotal
      recuperar_atributo(@comprobante,"subTotal")
    end

    #Regresa el certificado de la factura
    def certificado
      recuperar_atributo(@comprobante,"certificado")
    end

    #Regresa el número de certificado de la factura
    def numero_de_certificado
      recuperar_atributo(@comprobante,"noCertificado")
    end

    #Regresa la forma de pago registrada
    def forma_de_pago
      recuperar_atributo(@comprobante,"formaDePago")
    end

    #Regresa el sello de la factura
    def sello
      recuperar_atributo(@comprobante,"sello")
    end

    #Regresa el folio de la factura
    def folio
      recuperar_atributo(@comprobante,"folio")
    end

    #Regresa la serie de la factura
    def serie
      recuperar_atributo(@comprobante,"serie")
    end
    
    #Regresa la versión del comprobante
    def version
      recuperar_atributo(@comprobante,"version")
    end

    #Regresa el RFC del emisor
    def emisor_rfc
      recuperar_atributo(@emisor,"rfc")
    end

    #Regresa el domicilio completo del emisor
    def emisor_domicilio
      emisor_domicilio_calle + " "
      emisor_domicilio_numero + " "
      emisor_domicilio_colonia + " "
      emisor_domicilio_municipio + " "
      emisor_domicilio_estado + " "
      "C.P. " + emisor_domicilio_codigo_postal
    end

    #Regresa la calle del domicilio del emisor
    def emisor_domicilio_calle
      recuperar_atributo(@emisor_domicilio,"calle")
    end
    
    #Regresa el número del domicilio del emisor
    def emisor_domicilio_numero
      recuperar_atributo(@emisor_domicilio,"noExterior")
    end

    #Regresa la colonia del domicilio del emisor    
    def emisor_domicilio_colonia
      recuperar_atributo(@emisor_domicilio,"colonia")
    end

    #Regresa el municipio del domicilio del emisor
    def emisor_domicilio_municipio
      recuperar_atributo(@emisor_domicilio,"municipio")
    end
    
    #Regresa el estado del domicilio del emisor
    def emisor_domicilio_estado
      recuperar_atributo(@emisor_domicilio,"estado")
    end

    #Regresa el país del domicilio del emisor
    def emisor_domicilio_pais
      recuperar_atributo(@emisor_domicilio,"pais")
    end

    #Regresa el código postal del domicilio del emisor
    def emisor_domicilio_codigo_postal
      recuperar_atributo(@emisor_domicilio,"codigoPostal")
    end

    #Regresa la calle donde fue expedida la factura
    def expedido_en_calle
      recuperar_atributo(@emisor_expedido_en,"calle")
    end

    #Regresa el país donde fue emitida la factura
    def expedido_en_pais
      recuperar_atributo(@emisor_expedido_en,"pais")
    end

    #Recupera el código postal de donde fue emitida la factura
    def expedido_en_codigo_postal
      recuperar_atributo(@emisor_expedido_en,"codigoPostal")
    end

    #Recupera el régimen fiscal del emisor
    def emisor_regimen_fiscal
      recuperar_atributo(@emisor_regimen,"Regimen")
    end
      
    #Recupera el nombre del receptor
    def receptor_nombre
      recuperar_atributo(@receptor,"nombre")
    end

    #Recupera el RFC del receptor
    def receptor_rfc
      recuperar_atributo(@receptor,"rfc")
    end

    #Recupera el domicilio completo del receptor
    def receptor_domicilio
      receptor_domicilio_calle + " "
      receptor_domicilio_municipio + " "
      receptor_domicilio_estado + " "
      "C. P. " + receptor_domicilio_codigo_postal
    end

    #Recupera el código postal del domicilio del receptor
    def receptor_domicilio_codigo_postal
      recuperar_atributo(@receptor_domicilio,"codigoPostal")
    end

    #Recupera el país del domicilio del receptor
    def receptor_domicilio_pais
      recuperar_atributo(@receptor_domicilio,"pais")
    end

    #Recupera el municipio del domiciñio del receptor
    def receptor_domicilio_municipio
      recuperar_atributo(@receptor_domicilio,"municipio")
    end

    #Recupera la calle del domicilio del receptor
    def receptor_domicilio_calle
      recuperar_atributo(@receptor_domicilio,"calle")
    end
    
  end #Class

  #Este es un contenedor para los conceptos listados en una #Factura
  class Concepto

    #Se inicializa con un nodo de tipo Concepto
    def initialize(nodo)
      @nodo = nodo
    end

    #El importe del concepto
    def importe
      @nodo.attribute("importe").to_s
    end

    #El valor unitario del concepto
    def valor_unitario
      @nodo.attribute("valorUnitario").to_s
    end

    #La descripción del concepto
    def descripcion
      @nodo.attribute("descripcion").to_s
    end

    #La unidad de medida del concepto
    def unidad
      @nodo.attribute("unidad").to_s
    end

    #La cantidad del concepto. La unidad se puede obtener de #unidad
    def cantidad
      @nodo.attribute("cantidad").to_s
    end

  end #Class

  #Esta clase es un contenedor para los Impuestos de una #Factura
  class Impuesto

    #Se inicializa con un nodo de tipo Imputesto
    def initialize(nodo)
      @nodo = nodo
    end

    #El importe del impuesto
    def importe
      @nodo.attribute("importe").to_s
    end

    #La tasa porcentual del impuesto
    def tasa
      @nodo.attribute("tasa").to_s
    end

    #El nombre del impuesto
    def impuesto
      @nodo.attribute("impuesto").to_s
    end
    
  end #Class

end #Module
