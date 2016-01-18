#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'
require_relative "../lib/d3249/widget/path_selector.rb"

#Single call to PathSelector to check correct work.
if __FILE__ == $0

  Qt::Application.new(ARGV) do
    D3249::Widget::PathSelector.new do
      show
    end
    exec

  end
  
end
