# -*- coding: utf-8 -*-

require 'Qt4'

require_relative '../../d3249/widget/path_selector.rb'
require_relative '../../d3249/widget/list_selector.rb'
require_relative '../options_parser/columns.rb'
require_relative '../options_parser/options_class.rb'
require_relative '../reporter.rb'
require_relative '../logger/logger.rb'

module FacturasXML
  module GUI

    ##Interfaz gráfica de la aplicación FacturasXML
    #
    # Implementada con qtruby (Qt4)
    class FacturasXMLGUI < Qt::Widget

      include FacturasXML::Log
      
      slots 'total_chk_changed(int)','create_report()'
      signals 'quit()'

      #Inicializa el widget
      def initialize(parent = nil)
        super
        @@cols = FacturasXML::OptionsParser::COLUMNS_PROCS
        @@cols_names = FacturasXML::OptionsParser::COLUMNS_HEADERS.invert
        init_gui
      end

      private
      #Configuración del layout y conexiones internas
      def init_gui
        @codec = Qt::TextCodec.codec_for_name("UTF-8")
        
        font = Qt::Font.new("Arial",10,Qt::Font::Bold)
        metrics = Qt::FontMetrics.new(font)
        set_font(font)        
        
        #Selector de carpeta
        l1 = vertical_layout(trUtf8("Carpeta"))
        @path_selector = D3249::Widget::PathSelector.new
        l1.add_widget(@path_selector)

        l2 = vertical_layout(trUtf8("Reporte"))
        @reporte_le = Qt::LineEdit.new do
          set_text("LOGFILE.log")
        end
        l2.add_widget(@reporte_le)

        l3 = vertical_layout(trUtf8("Registro"))
        @registro_le = Qt::LineEdit.new do
          set_text("REPORTE.csv")
        end
        l3.add_widget(@registro_le)

        l4 = vertical_layout(trUtf8("Total"))
        @total_chk = Qt::CheckBox.new
        @total_pos = Qt::LineEdit.new do
          set_enabled(false)
          set_fixed_size(metrics.width("888"),metrics.height)
        end
        connect(@total_chk,SIGNAL('stateChanged(int)'),
                self,SLOT('total_chk_changed(int)'))
        l4.add_widget(@total_chk)
        l4.add_widget(Qt::Label.new(trUtf8("Columna")))
        l4.add_widget(@total_pos)

        l5 = Qt::VBoxLayout.new
        l5.add_widget(Qt::Label.new(trUtf8("Columnas")))
        @cols_selector = D3249::Widget::ListSelector.new(@@cols_names.keys)
        l5.add_widget(@cols_selector)

        l6 = Qt::HBoxLayout.new
        @exit_btn = Qt::PushButton.new(trUtf8('Salir'))
        connect(@exit_btn,SIGNAL('clicked()'),
                self,SIGNAL('quit()'))
        @go_btn = Qt::PushButton.new(trUtf8('Crear Reporte'))
        connect(@go_btn,SIGNAL('clicked()'),
                self,SLOT('create_report()'))
        l6.add_widget(@exit_btn)
        l6.add_widget(@go_btn)
                      
        
        main_layout = Qt::GridLayout.new
        main_layout.add_layout(l1,0,0,1,5)
        main_layout.add_layout(l2,1,0,1,3)
        main_layout.add_layout(l3,2,0,1,3)
        main_layout.add_layout(l5,3,0,1,5)
        main_layout.add_layout(l4,4,1,6,2)
        main_layout.add_layout(l6,10,1,3,2)
        
        set_layout(main_layout)
      end

      #Crea un layout horizontal con una etiqueta dada
      def vertical_layout(label)
        result = Qt::HBoxLayout.new
        result.add_widget(Qt::Label.new(label))
        result
      end

      #[Qt slot] llamada cuando se habilita el checkbox de total
      def total_chk_changed(state)
        @total_pos.set_enabled(state != 0)
      end

      #Usa la información dada en el widget para crear un objeto FacturasXML::OptionsParser::Options
      #que a su vez usa para crear un objeto FacturasXML::Reporter y crear los archivos solicitados
      def create_report
        options = FacturasXML::OptionsParser::Options.new

        options.directory = @path_selector.path
        options.logfile = @reporte_le.text
        options.outfile = @registro_le.text
        options.cols_headers = @cols_selector.selected.inject("") {|res,col|res += col + "\t"}
        options.total = @total_chk.is_checked
        options.t_position = @total_pos.text.to_i if options.total?

        proc_list = []
        @cols_selector.selected.each do |title_ascii|
          title = title_ascii.force_encoding("UTF-8")
          log.debug{"GUI:: Buscando el proceso de la columna: #{title}[#{title.encoding}]"}
          log.debug{"GUI::\tLlave recuperada: #{@@cols_names[title]}"}
          log.debug{"GUI::\tExiste el procedimiento? #{@@cols.key?(@@cols_names[title])}"}
          proc_list << @@cols[@@cols_names[title]]
        end
        options.cols_proc_list = proc_list

        FacturasXML::Reporter.new(options).make_report

        Qt::MessageBox.new self do
          set_window_title(trUtf8("Finalizado"))
          set_text(trUtf8("Se crearon los archivos:\n#{options.directory}/#{options.outfile}\t#{options.directory}/#{options.logfile}"))
          show
        end
        
      end

    end
  end
end

  
