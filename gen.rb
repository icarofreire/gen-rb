# -- script para automatizar tarefas de manipulação de arquivos;;
# -- Ícaro, 27/Abril/2020;

require 'json'

# \/ cria arquivo se o mesmo não existe;
def criar_arquivo(nome, conteudo)
    if !File.file?(nome)
        File.write(nome, conteudo)
    else
        return false
    end
end

# \/ deletar arquivo;
def deletar_arquivo(nome)
    File.delete(nome) if File.exist?(nome)
end

# \/ renomear arquivo;
def renomear_arquivo(nome_arquivo, novo_nome)
	File.rename(nome_arquivo, novo_nome) if File.exist?(nome_arquivo)
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

# \/ Exemplo de hash com key regex e valor string;
#subs = {/ActiveRecord::Migration/ => 'ActiveRecord::Migration[5.2]'}
#puts subs[/ActiveRecord::Migration/]

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

# dir_raiz = "D:\\Documentos\\gen-rb"
# dir_criar = "\\icaro\\teste\\blob"

# \/ cria lista de diretórios aninhados definidos por uma string, em um diretório definido;
# Ex: No diretório raiz "ProjetoX/pasta-projeto1", Criar subdiretórios "\\pasta1\\sub-pasta2\\sub-pasta3";
def criar_diretorios_aninhados(dir_raiz, dir_criar)
	sub = dir_raiz
	sep = '\\'
	dir_criar.split(sep).each do |pasta|
		sub += sep+pasta
		criar_pasta(sub)
	end
end

# \/ cria arquivo em diretórios aninhados definidos por uma string, em um diretório definido;
# Ex: No diretório raiz "ProjetoX/pasta-projeto1", Criar arquivo através dos subdiretórios "\\pasta1\\sub-pasta2\\arquivoX";
def criar_arquivo_dir_aninhados(dir_raiz, dir_criar)
	sub = dir_raiz
	sep = '\\'
	arr_dir = dir_criar.split(sep)
	arr_dir[0...-1].each do |pasta|
		sub += sep+pasta
		criar_pasta(sub)
	end
	criar_arquivo(sub+sep+arr_dir[-1], '')
end

# \/ abrir e ler arquivo json;
def ler_json(arquivo)
	json_from_file = File.read(arquivo)
	hash = JSON.parse(json_from_file)
	hash
end

# \/ checar se chaves do json existem;
def if_keys(json, key1, key2, key3)
	return (json.has_key?(key1) && json[key1].has_key?(key2) && json[key1][key2].has_key?(key3))
end

# \/ checar se chaves do json existem;
#~ def if_keys(json, keys)
	#~ return (json.has_key?(keys[0]) && json[keys[0]].has_key?(keys[1]) && json[keys[0]][keys[1]].has_key?(keys[2]))
#~ end

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

json = ler_json('D:\\Documentos\\gen-rb\\json-entrada.json')
#~ puts json['actions']['sub']


if if_keys(json, 'actions', 'sub', 'arquivo') && if_keys(json, 'actions', 'sub', 'hash_subs')
#    subs_arquivo(json['actions']['sub']['arquivo'], json['actions']['sub']['arquivo']['hash_subs'])	
end

if if_keys(json, 'actions', 'create', 'nome') && if_keys(json, 'actions', 'create', 'conteudo')
#    criar_arquivo(json['actions']['create']['nome'], json['actions']['create']['arquivo']['conteudo'])	
end

if if_keys(json, 'actions', 'del', 'nome')
#    deletar_arquivo(json['actions']['del']['nome'])	
end

if if_keys(json, 'actions', 'rename', 'nome') && if_keys(json, 'actions', 'rename', 'novo_nome')
#    renomear_arquivo(json['actions']['del']['nome'], json['actions']['del']['novo_nome'])	
end

if if_keys(json, 'actions', "substituicoes-projeto", "src") && if_keys(json, 'actions', "substituicoes-projeto", 'hash_subs')

end

if if_keys(json, 'actions', "substituicoes-src", "src") && if_keys(json, 'actions', "substituicoes-src", "hash_subs")

end

if if_keys(json, 'actions', "substituir_linha_arquivo", "nome") && if_keys(json, 'actions', "substituir_linha_arquivo", "linha") && if_keys(json, 'actions', "substituir_linha_arquivo", "novo_conteudo")
   
end

if if_keys(json, 'actions', "criar_pasta", "nome")

end

if if_keys(json, 'actions', "add_conteudo_arquivo", "arquivo") && if_keys(json, 'actions', "add_conteudo_arquivo", "conteudo")

end

if if_keys(json, 'actions', "add_linhas_arquivo", "nome") && if_keys(json, 'actions', "add_linhas_arquivo", "linha") && if_keys(json, 'actions', "add_linhas_arquivo", "array_novos_conteudos")

end

if if_keys(json, 'actions', "criar_diretorios_aninhados", "dir_raiz") && if_keys(json, 'actions', "criar_diretorios_aninhados", "dir_criar")

end

if if_keys(json, 'actions', "criar_arquivo_dir_aninhados", "dir_raiz") && if_keys(json, 'actions', "criar_arquivo_dir_aninhados", "dir_criar")

end
