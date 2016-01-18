#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'
require_relative "../lib/facturasXML/gui/facturas_xml_gui.rb"

#Single call to FacturasXMLGUI to check correct work
if __FILE__ == $0

  Qt::Application.new(ARGV) do
    
    w = FacturasXML::GUI::FacturasXMLGUI.new do      
      set_window_title(trUtf8('[TEST] FacturasXML'))
      show
    end
 
    connect(w,SIGNAL("quit()"),
              self,SLOT("quit()"))
    exec
    
  end
end
   
