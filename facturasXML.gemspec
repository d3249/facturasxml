# coding: utf-8
Gem::Specification.new do |s|
  s.name = "facturasxml"
  s.summary = "Crea reportes de facturas XML según el estandar mexicano"
  s.description = File.read(File.join(File.dirname(__FILE__),'README'))
  s.licenses = "GPLv2"
  s.requirements = "Qt library"
  s.version = "0.2.0"
  s.author = "Edgar Arturo Ramos Rambaud"
  s.email = "edgar.a.ramos.rambaud@gmail.com"
  s.homepage = "https://github.com/d3249/facturasxml"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">=1.9"
  s.files = Dir["**/**"]
  s.executables = ["facturasxml","facturasxml-gui"]
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = true
  s.add_dependency 'nokogiri', '~> 1.6', '>= 1.6.7'
  s.add_dependency 'qtbindings', '~> 4.8', '>= 4.8.6'
  s.add_dependency 'axlsx','~> 2.0', '>= 2.0.1'
end
