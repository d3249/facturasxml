#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'
require_relative '../lib/d3249/widget/list_selector.rb'

#Single call to ListSelector to ckeck correct work
if __FILE__ == $0

  Qt::Application.new(ARGV) do

    @cols = %w{uno dos tres cuatro cinco seis}
    
    D3249::Widget::ListSelector.new(@cols) do
      show
    end
        
    exec
    
  end
end
