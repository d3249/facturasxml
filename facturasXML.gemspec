# coding: utf-8
Gem::Specification.new do |s|
  s.name = "facturasxml"
  s.summary = "Crea reportes de facturas XML según el estandar mexicano"
  s.description = File.read(File.join(File.dirname(__FILE__),'README'))
  s.licenses = "GPLv2"
  s.requirements = "Ningun requerimiento especial"
  s.version = "0.1.1"
  s.author = "Edgar Arturo Ramos Rambaud"
  s.email = "edgar.a.ramos.rambaud@gmail.com"
  s.homepage = "https://github.com/d3249/facturasxml"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">=1.9"
  s.files = Dir["**/**"]
  s.executables = ["facturasxml","facturasxml-gui"]
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = true
end
