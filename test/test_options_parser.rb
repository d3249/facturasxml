#!/usr/bin/env ruby
#*-* encoding: utf-8 *-*

require "test/unit"
require "mocha/test_unit"

require_relative "../lib/facturasXML/options_parser/command_line_parser.rb"

#Pruebas de la clase Options
class OptionsParserTester < Test::Unit::TestCase

  class Factura
  end

  #Prueba que se asignen los valores por defecto
  def test_empty_defaults
    argv = []

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)
    
    assert_equal("LOGFILE.log",op.logfile)
    assert_equal("RESUMEN.csv",op.outfile)
    assert_equal("Archivo\tFecha\tNombre del emisor\tTotal",op.cols_headers)
    assert_equal(false,op.total?)
    assert_equal(".",op.directory)

  end

  #Prueba el comportamiento cuando se da un archivo de registro
  def test_logfile_given
    argv = %w{-L otherlogfile.log}

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)
    
    assert_equal("otherlogfile.log",op.logfile)
    assert_equal("RESUMEN.csv",op.outfile)
    assert_equal("Archivo\tFecha\tNombre del emisor\tTotal",op.cols_headers)
    assert_equal(false,op.total?)
    assert_equal(".",op.directory)

  end

  #Prueba el comportamiento cuando se dan dos argumentos
  def test_two_parameters_given
    argv = %w{-L somelogfile.log -N}

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)

    assert_equal("somelogfile.log",op.logfile)
    assert_equal("RESUMEN.csv",op.outfile)
    assert_equal("Archivo\tFecha\tNombre del emisor\tTotal",op.cols_headers)
    assert_equal(false,op.total?)
    assert_equal(".",op.directory)

  end
  
  #Prueba cuando se cambian todos los parámetros por default
  def test_all_non_default
    argv = %w{-L otherlogfile.log -O output.csv -C en,st,t -N -D /path/ -T 2}

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)

    assert_equal("otherlogfile.log",op.logfile)
    assert_equal("output.csv",op.outfile)
    assert_equal("Nombre del emisor\tSubtotal\tTotal\t",op.cols_headers)
    assert_equal(true,op.total?)
    assert_equal(2,op.t_position)
    assert_equal("/path",op.directory)

  end

  #Prueba que haya un error cuando se dan mal los argumentos
  def test_raise_exception_with_bad_arguments

    argv = %w{-L -D}
    assert_raise do
      FacturasXML::OptionsParser::CommandLineParser.parse(argv)
    end

    argv = %{-L file1 notfile1}
    assert_raise do
      FacturasXML::OptionsParser::CommandLineParser.parse(argv)
    end
    
  end

  #Prueba el la lista de procedimientos
  #
  #Se usa un Mock para reemplazar a la Factura
  def test_proc_list_default_columns
    argv = []

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)

    #Se prueba el número de elementos esperados
    assert_equal(4,op.cols_proc_list.size)
    
    #Valores esperados
    expected= ["factura.xml",
               "01/01/16",
               "Pedro Pérez",
               "100.00"]   
    #Se usa un mock
    fact = Factura.new
    fact.expects(:nombre_de_archivo).returns(expected[0])
    fact.expects(:fecha).returns(expected[1])
    fact.expects(:emisor_nombre).returns(expected[2])
    fact.expects(:total).returns(expected[3])

    op.cols_proc_list.each_with_index do |p,i|
      assert_equal(expected[i], p.call(fact) )
    end  
  end

  #Prueba que se emita error cuando se pide el total pero no se indica la posición
  def test_total_require_valor
    argv = %w{-T -L logfile.log}

    assert_raises {FacturasXML::OptionsParser::CommandLineParser.parse(argv)}
  end

  #Prueba que se recupera la posición del total
  def test_se_recupera_posicion_de_total
    argv = %w{-T 3}

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)

    assert_equal(3,op.t_position)
  end

  #Prueba la lista de procesos con todos las columnas dadas
  #
  #Se usa un mock para reemplazar la Factura
  def test_proc_list_with_custom_columns
    argv = %w{-C a,le,mp,tc,t,st,ce,nc,fp,s,fe,fo,se,en,er,ed,ef,rn,rr,rd}

    op = FacturasXML::OptionsParser::CommandLineParser.parse(argv)

    #Se prueba el número de elementos esperados
    assert_equal(20, op.cols_proc_list.size)
    
    #Valores esperados
    ex = ["factura.xml",
          "Zacatecas",
          "efectivo",
          "factura",
          "116.00",
          "100.00",
          "cer",
          "noCer",
          "TDC",
          "SELLO",
          "01/01/16",
          "1",
          "A",
          "Pedro",
          "RFC_emisor",
          "dir_emi",
          "reg",
          "Juan",
          "RFC_receptor",
          "dir_rec"]

    #Mock
    fact = Factura.new
    fact.expects(:nombre_de_archivo).returns(ex[0])
    fact.expects(:lugar_expedicion).returns(ex[1])
    fact.expects(:metodo_de_pago).returns(ex[2])
    fact.expects(:tipo_de_comprobante).returns(ex[3])
    fact.expects(:total).returns(ex[4])
    fact.expects(:subtotal).returns(ex[5])
    fact.expects(:certificado).returns(ex[6])
    fact.expects(:numero_de_certificado).returns(ex[7])
    fact.expects(:forma_de_pago).returns(ex[8])
    fact.expects(:sello).returns(ex[9])
    fact.expects(:fecha).returns(ex[10])
    fact.expects(:folio).returns(ex[11])
    fact.expects(:serie).returns(ex[12])
    fact.expects(:emisor_nombre).returns(ex[13])
    fact.expects(:emisor_rfc).returns(ex[14])
    fact.expects(:emisor_domicilio).returns(ex[15])
    fact.expects(:emisor_regimen_fiscal).returns(ex[16])
    fact.expects(:receptor_nombre).returns(ex[17])
    fact.expects(:receptor_rfc).returns(ex[18])
    fact.expects(:receptor_domicilio).returns(ex[19])

    op.cols_proc_list.each_with_index do |p,i|
      assert_equal(ex[i],p.call(fact))
    end
       
  end
    
  
end
