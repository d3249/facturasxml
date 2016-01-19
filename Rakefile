require 'rake/testtask'

desc "Remove backpu files"
task :clean do
  files = Dir["**/*~"]
  rm(files,verbose:true) unless files.empty?
end

desc "Repackages the gem file"
task :build do
  gemfile = Dir["facturasxml*.gem"]
  rm(gemfile,verbose:true) unless gemfile.empty?
  sh 'gem build facturasXML.gemspec'
end
