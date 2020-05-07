# fazer substituições necessarias para atualizar o projeto rails para rails 5;

def gerar_substituicoes(pasta_projeto)
	path = pasta_projeto #'jl-politica-teste'
	extensions = %w(.rb)
	    
	require 'find'
	Find.find(path) do |f|
	  if extensions.include? File.extname(f)
	    buffer = File.new(f,'r').read.gsub(/ActiveRecord::Migration/,'ActiveRecord::Migration[5.2]').gsub(/ActiveRecord::Base/,'ApplicationRecord').gsub(/before_filter/,'before_action')
	    File.open(f,'w') {|fw| fw.write(buffer)}
	  end
	end

	#\/ Criar arquivo "application_record.rb";
	File.write(path+"/app/models/application_record.rb", "class ApplicationRecord < ActiveRecord::Base" +"\n"+ "self.abstract_class = true" +"\n"+ "end")

	#\/ Criar arquivo "database.yml"; Editar depois de gerado;
	conteudo_file_database_yml = 
	"# Configure Using Gemfile" +"\n"+ 
	"# gem 'pg'" +"\n"+ 
	"#" +"\n"+ 
	"development:" +"\n"+ 
	"  adapter: postgresql" +"\n"+ 
	"  encoding: utf8" +"\n"+ 
	"  database: nomedobanco_development" +"\n"+ 
	"  pool: 5" +"\n"+ 
	"  username: desenvolvimento-02" +"\n"+ 
	"  password:" +"\n\n"+
	
  "production:" +"\n"+ 
	"  adapter: postgresql" +"\n"+ 
	"  encoding: utf8" +"\n"+ 
	"  database: nomedobanco_db" +"\n"+ 
	"  pool: 5" +"\n"+ 
	"  username: nomedobanco_user" +"\n"+ 
	"  password:" +"\n"

	File.write(path+"/config/database.yml", conteudo_file_database_yml)

	gemfile_lock = path+"/Gemfile.lock"
	File.delete(gemfile_lock) if File.exist?(gemfile_lock)
end


if ARGV.length != 1
  puts "Informe o nome da pasta do projeto."
  exit
else
	pasta = ARGV[0]
	if File.directory?(pasta)
		gerar_substituicoes(pasta)
	else
		puts "Conteúdo informado não é uma pasta."
  		exit
	end
end
