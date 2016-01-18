# coding: utf-8
#*-* enconding: utf-8 *-*

module FacturasXML
  module OptionsParser

    #Hash de equivalencias entre columnas solicitadas y los
    #títulos que aparecerán las columnas del reporte
    COLUMNS_HEADERS = {
      "a" => "Archivo",
      "le" => "Lugar de expedición",
      "mp" => "Método de pago",
      "tc" => "Típo de comprobante",
      "t" =>  "Total",
      "st" => "Subtotal",
      "ce" => "Certificado",
      "nc" => "Número de certificado",
      "fp" => "Forma de pago",
      "s" => "Sello",
      "fe" => "Fecha",
      "fo" => "Folio",
      "se" => "Serie",
      "en" => "Nombre del emisor",
      "er" => "RFC del emisor",
      "ed" => "Domicilio del emisor",
      "ef" => "Régimen fiscal del emisor",
      "rn" => "Nombre del receptor",
      "rr" => "RFC del receptor",
      "rd" => "Domicilio del receptor",
#      "cd" => "Descropción del concepto",
#      "ci" => "Importe del concepto",
#      "cv" => "Valor unitario del concepto",
#      "cu" => "Unidad del concepto",
#      "cc" => "Cantidad del concepto",
#      "i" => "Total de impuestos trasladados"
#      "ii" => "Importe del impuesto",
#      "it" => "Tasa del impuesto",
#      "in" => "Nombre del impuesto"
    }
    
    #El valor por default del nombre de una columna no especificada es un espacio vacío
    COLUMNS_HEADERS.default=(" ")
  
    #Hash de equivalencias entre las columnas solicitadas y los
    #parámetros del archivo XML
    #
    #Este hash devuelve un procedimiento (Proc) que al momento de ser ejecutado
    #recibe como argumento un objeto de tipo FacturasXML::Factura
    COLUMNS_PROCS = {
      "a" => Proc.new{|f| f.nombre_de_archivo},
      "le" => Proc.new {|f| f.lugar_expedicion},
      "mp" => Proc.new {|f| f.metodo_de_pago},
      "tc" => Proc.new {|f| f.tipo_de_comprobante},
      "t" =>  Proc.new {|f| f.total},
      "st" => Proc.new {|f| f.subtotal},
      "ce" => Proc.new {|f| f.certificado},
      "nc" => Proc.new {|f| f.numero_de_certificado},
      "fp" => Proc.new {|f| f.forma_de_pago},
      "s" => Proc.new {|f| f.sello},
      "fe" => Proc.new {|f| f.fecha},
      "fo" => Proc.new {|f| f.folio},
      "se" => Proc.new {|f| f.serie},
      "en" => Proc.new {|f| f.emisor_nombre},
      "er" => Proc.new {|f| f.emisor_rfc},
      "ed" => Proc.new {|f| f.emisor_domicilio},
      "ef" => Proc.new {|f| f.emisor_regimen_fiscal},
      "rn" => Proc.new {|f| f.receptor_nombre},
      "rr" => Proc.new {|f| f.receptor_rfc},
      "rd" => Proc.new {|f| f.receptor_domicilio},
      #    "cd" => factura.descripcion, #Para cada nodo Concepto
      #    "ci" => factura.importe, #Para cada nodo Concepto
      #    "cv" => factura.valorUnitario, #Para cada nodo Concepto
      #    "cu" => factura.unidad, #Para cada nodo Concepto
      #    "cc" => factura.cantidad, #Para cada nodo Concepto
      #    "i" => Proc.new {|f|f.totalImpuestosTrasladados} #Para el nodo Impuestos
      #    "ii" => factura.importe, #Para cada nodo Impuesto
      #    "it" => factura.tasa, #Para cada nodo Impuesto
      #    "in" => factura.impuesto #Para cada nodo Impuesto
    }

    #El valor por default de una columna no listada es NODEF
    COLUMNS_PROCS.default=Proc.new {|f| "NODEF"} 
  end  
end
