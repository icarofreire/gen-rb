# -- script para automatizar tarefas de manipulação de arquivos;;
# -- Ícaro, 27/Abril/2020;

require 'json'

# \/ cria arquivo se o mesmo não existe;
def criar_arquivo(nome, conteudo)
    if File.file?(nome)
        File.write(nome, conteudo)
    else
        return false
    end
end

# \/ deletar arquivo;
def deletar_arquivo(nome)
    File.delete(nome) if File.exist?(nome)
end

# \/ realizar substituições em arquivos de forma recursiva;
def gerar_substituicoes(pasta_projeto, hash_subs)
	path = pasta_projeto
	extensions = %w(.rb) # Ou .php
	    
	require 'find'
	Find.find(path) do |f|
	  if extensions.include? File.extname(f)
		hash_subs.each do |key, value|
			buffer = File.new(f,'r').read.gsub(key, value)
	    end
	    File.open(f,'w') {|fw| fw.write(buffer)}
	  end
	end
end

# \/ realizar substituições em arquivo;
def subs_arquivo(nome, hash_subs)
    if File.file?(nome)
       hash_subs.each do |key, value|
			buffer = File.new(nome,'r').read.gsub(key, value)
	   end
	   File.open(nome,'w') {|fw| fw.write(buffer)}
    else
        return false
    end
end

# \/ realizar substituição em determinada linha do arquivo;
def substituir_linha_arquivo(nome, linha, novo_conteudo)
	lines = File.readlines(nome)
	lines[linha] = novo_conteudo
	File.open(nome,'w') {|fw| fw.write(lines.join)}
end

# \/ criar pasta se a mesma não existe;
def criar_pasta(pasta)
    unless File.directory?(pasta)
        Dir.mkdir(pasta)
    end
end

# \/ acrescentar conteúdo a um arquivo;
def add_conteudo_arquivo(arquivo, conteudo)
    File.write(arquivo, conteudo, File.size(arquivo), mode: 'a')
end

# \/ acrescentar conteúdos - inseridos por um array - a um arquivo a partir de uma determinada linha;
# Não esquecer de inserir uma quebra de linha (\n), no final da string de cada elemento do array se
# desejar uma quebra de linha ao inserir o conteúdo.
def add_linhas_arquivo(nome, linha, array_novos_conteudos)
	lines = File.readlines(nome)
	lines = lines.insert(linha,*array_novos_conteudos)
	File.open(nome,'w') {|fw| fw.write(lines.join)}
end


#subs = {/ActiveRecord::Migration/ => 'ActiveRecord::Migration[5.2]'}
#puts subs[/ActiveRecord::Migration/]

# \/ ler arquivo JSON a partir da linha de comando;
def ler_arquivo_json
	if ARGV.length != 1
	  puts "Informe o arquivo com conteúdo no formato JSON."
	  exit
	else
		arquivo = ARGV[0]
		if File.file?(arquivo)
			#...
			#... interpretar JSON do arquivo;
			#...
		else
			puts "Conteúdo informado não é uma arquivo."
			exit
		end
	end
end

=begin
string = '{"desc":{"someKey":"someValue","anotherKey":"value"},"main_item":{"stats":{"a":8,"b":12,"c":10}}}'

json = JSON.parse '{"foo":"bar", "ping":"pong"}'
puts json['foo'] # prints "bar"

json = JSON.parse(string)
puts( json['main_item']['stats']['c'] )
=end
