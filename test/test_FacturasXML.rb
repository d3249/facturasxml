# -*- coding: utf-8 -*-

require 'test/unit'

require 'nokogiri'

require_relative '../lib/facturasXML/factura.rb'

#Pruebas para la clase Factura
class Pruebas < Test::Unit::TestCase

  #Antes de cada prueba se abren dos facturas para verificar la prueba
  #Los archivos de muestra están en test/files
  def setup
    @file1 = "files/OXXO.xml"
    @file2 = "files/sanborns.xml"

    @factura_1 = FacturasXML::Factura.new(@file1)
    @factura_2 = FacturasXML::Factura.new(@file2)

    @documento_1 = File.open(@file1) {|f| Nokogiri::XML(f)}
    @documento_2 = File.open(@file2) {|f| Nokogiri::XML(f)}
    
  end

  #Prueba que se recupere el nombre del emisor
  def test_recupera_nombre_emisor

    expected_1 = @documento_1.at_css("cfdi|Emisor").attribute("nombre").to_s
    expected_2 = @documento_2.at_css("Emisor").attribute("nombre").to_s
      
    assert_equal(expected_1, @factura_1.emisor_nombre)
    assert_equal(expected_2, @factura_2.emisor_nombre)
  end

  #Prueba que haya un error con un archivo inválido
  #
  #El archivo inválido es test/files/invalid.xml
  def test_raises_exception_when_invalid
    assert_raises(FacturasXML::Error::FacturasXMLError) do | |
      factura = FacturasXML::Factura.new("files/invalid.xml")
    end
  end

  #Prueba que se recuperen todos los atributos del comprobante
  def test_comprobante_attributes

    nodo1 = @documento_1.at_css("cfdi|Comprobante")
    nodo2 = @documento_2.at_css("Comprobante")
    
    assert_equal(nodo1.attribute("LugarExpedicion").to_s, @factura_1.lugar_expedicion)

    assert_equal(nodo2.attribute("LugarExpedicion").to_s, @factura_2.lugar_expedicion)

    assert_equal(nodo1.attribute("metodoDePago").to_s,@factura_1.metodo_de_pago)
    assert_equal(nodo2.attribute("metodoDePago").to_s,@factura_2.metodo_de_pago)

    assert_equal(nodo1.attribute("tipoDeComprobante").to_s,@factura_1.tipo_de_comprobante)
    assert_equal(nodo2.attribute("tipoDeComprobante").to_s,@factura_2.tipo_de_comprobante)

    assert_equal(nodo1.attribute("total").to_s,@factura_1.total)
    assert_equal(nodo2.attribute("total").to_s,@factura_2.total)

    assert_equal(nodo1.attribute("subTotal").to_s,@factura_1.subtotal)
    assert_equal(nodo2.attribute("subTotal").to_s,@factura_2.subtotal)

    assert_equal(nodo1.attribute("certificado").to_s,@factura_1.certificado)
    assert_equal(nodo2.attribute("certificado").to_s,@factura_2.certificado)

    assert_equal(nodo1.attribute("noCertificado").to_s,@factura_1.numero_de_certificado)
    assert_equal(nodo2.attribute("noCertificado").to_s,@factura_2.numero_de_certificado)

    assert_equal(nodo1.attribute("formaDePago").to_s,@factura_1.forma_de_pago)
    assert_equal(nodo2.attribute("formaDePago").to_s,@factura_2.forma_de_pago)

    assert_equal(nodo1.attribute("sello").to_s,@factura_1.sello)
    assert_equal(nodo2.attribute("sello").to_s,@factura_2.sello)

    assert_equal(nodo1.attribute("fecha").to_s,@factura_1.fecha)
    assert_equal(nodo2.attribute("fecha").to_s,@factura_2.fecha)

    assert_equal(nodo1.attribute("folio").to_s,@factura_1.folio)
    assert_equal(nodo2.attribute("folio").to_s,@factura_2.folio)

    assert_equal(nodo1.attribute("serie").to_s,@factura_1.serie)
    assert_equal(nodo2.attribute("serie").to_s,@factura_2.serie)

    assert_equal(nodo1.attribute("version").to_s,@factura_1.version)
    assert_equal(nodo2.attribute("version").to_s,@factura_2.version)    
    
  end

  #Prueba que se recuperen todos los atributos del emisor
  def test_emisor_attributes

    nodo1 = @documento_1.at_css("cfdi|Emisor")
    nodo2 = @documento_2.at_css("Emisor")

    assert_equal(nodo1.attribute("nombre").to_s,@factura_1.emisor_nombre)
    assert_equal(nodo2.attribute("nombre").to_s,@factura_2.emisor_nombre)

    assert_equal(nodo1.attribute("rfc").to_s,@factura_1.emisor_rfc)
    assert_equal(nodo2.attribute("rfc").to_s,@factura_2.emisor_rfc)
    
  end

  #Prueba que se recuperen los datos del domicilio fiscal del emisor
  def test_domicilio_fiscal_attributes

    nodo1 = @documento_1.at_css("cfdi|DomicilioFiscal")
    nodo2 = @documento_2.at_css("DomicilioFiscal")

    assert_equal(nodo1.attribute("calle").to_s,@factura_1.emisor_domicilio_calle)
    assert_equal(nodo2.attribute("calle").to_s,@factura_2.emisor_domicilio_calle)

    assert_equal(nodo1.attribute("noExterior").to_s,@factura_1.emisor_domicilio_numero)
    assert_equal(nodo2.attribute("noExterior").to_s,@factura_2.emisor_domicilio_numero)

    assert_equal(nodo1.attribute("colonia").to_s,@factura_1.emisor_domicilio_colonia)
    assert_equal(nodo2.attribute("colonia").to_s,@factura_2.emisor_domicilio_colonia)

    assert_equal(nodo1.attribute("municipio").to_s,@factura_1.emisor_domicilio_municipio)
    assert_equal(nodo2.attribute("municipio").to_s,@factura_2.emisor_domicilio_municipio)

    assert_equal(nodo1.attribute("estado").to_s,@factura_1.emisor_domicilio_estado)
    assert_equal(nodo2.attribute("estado").to_s,@factura_2.emisor_domicilio_estado)
    
    assert_equal(nodo1.attribute("pais").to_s,@factura_1.emisor_domicilio_pais)
    assert_equal(nodo2.attribute("pais").to_s,@factura_2.emisor_domicilio_pais)

    assert_equal(nodo1.attribute("codigoPostal").to_s,@factura_1.emisor_domicilio_codigo_postal)
    assert_equal(nodo2.attribute("codigoPostal").to_s,@factura_2.emisor_domicilio_codigo_postal)   
    
  end

  #Prueba que se recuperen los atributos del lugar de expedición
  def test_expedido_en_attributes

    nodo1 = @documento_1.at_css("cfdi|ExpedidoEn")
    nodo2 = @documento_2.at_css("ExpedidoEn")

    assert_equal(nodo1.attribute("codigoPostal").to_s,@factura_1.expedido_en_codigo_postal)
    assert_equal(nodo2.attribute("codigoPostal").to_s,@factura_2.expedido_en_codigo_postal)

    assert_equal(nodo1.attribute("pais").to_s,@factura_1.expedido_en_pais)
    assert_equal(nodo2.attribute("pais").to_s,@factura_2.expedido_en_pais)

    assert_equal(nodo1.attribute("calle").to_s,@factura_1.expedido_en_calle)
    assert_equal(nodo2.attribute("calle").to_s,@factura_2.expedido_en_calle)

  end

  #Prueba que se recupere el régimen fiscal del emisor
  def test_regimen_fiscal_attributes
    nodo1 = @documento_1.at_css("cfdi|RegimenFiscal")
    nodo2 = @documento_2.at_css("RegimenFiscal")

    assert_equal(nodo1.attribute("Regimen").to_s,@factura_1.emisor_regimen_fiscal)
    assert_equal(nodo2.attribute("Regimen").to_s,@factura_2.emisor_regimen_fiscal)

  end

  #Prueba que se recuperen los atributos del receptor
  def test_receptor_attributes

    nodo1 = @documento_1.at_css("cfdi|Receptor")
    nodo2 = @documento_2.at_css("Receptor")

    assert_equal(nodo1.attribute("nombre").to_s,@factura_1.receptor_nombre)
    assert_equal(nodo2.attribute("nombre").to_s,@factura_2.receptor_nombre)

    assert_equal(nodo1.attribute("rfc").to_s,@factura_1.receptor_rfc)
    assert_equal(nodo2.attribute("rfc").to_s,@factura_2.receptor_rfc)

  end

  #Prueba que se recuperen los atributos de la dirección del receptor
  def test_receptor_direccion_attributes
    nodo1 = @documento_1.at_css("cfdi|Domicilio")
    nodo2 = @documento_2.at_css("Domicilio")

    assert_equal(nodo1.attribute("codigoPostal").to_s,@factura_1.receptor_domicilio_codigo_postal)
    assert_equal(nodo2.attribute("codigoPostal").to_s,@factura_2.receptor_domicilio_codigo_postal)

    assert_equal(nodo1.attribute("pais").to_s,@factura_1.receptor_domicilio_pais)
    assert_equal(nodo2.attribute("pais").to_s,@factura_2.receptor_domicilio_pais)

    assert_equal(nodo1.attribute("municipio").to_s,@factura_1.receptor_domicilio_municipio)
    assert_equal(nodo2.attribute("municipio").to_s,@factura_2.receptor_domicilio_municipio)

    assert_equal(nodo1.attribute("calle").to_s,@factura_1.receptor_domicilio_calle)
    assert_equal(nodo2.attribute("calle").to_s,@factura_2.receptor_domicilio_calle)

  end
                 
  
end
  
