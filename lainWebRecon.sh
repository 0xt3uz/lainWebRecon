#!/bin/bash

op=$1
arquivo=$3
url=$2
sc=$4

if [ $3 ]
then
	arquivo=$3
else
	arquivo=0
fi

if [ $4 ]
then
	sc=$4
else
	sc=0
fi

if [ $5 ]
then
	ext=$5
else
	ext="txt"
fi

usage_func(){
	echo -e "Usage: ./lainWebRecon <op> <url> <wordlist> <http_status_code> <ext>\n"

	echo "<op>: dir, files, addressearch"
	echo "<url>: url"
	echo "<wordlist>: lista com nomes"
	echo "<http_status_code>: código HTTP de retorno"
	echo "<ext>: extensão para busca (útil apenas em casos de busca por arquivos)"

	echo -e "\n"

	echo "Para realizar brute force de diretórios: ./lainWebRecon dir google.com wordlist 200"
	echo "Para realizar brute force de arquivos: ./lainWebRecon file google.com wordlist 200 txt"
	echo "Para realizar busca de emails ./lainWebRecon addressearch google.com"
}

dir_func(){
	while IFS= read -r linha || [[ -n "$linha" ]]; do
		req=$(curl -o /dev/null -sw "%{http_code}" "http://www.$url/$linha/")
		if [[ $req == $sc ]]
		then
			echo "URL Encontrada => $url/$linha/"
		fi
	done < "$arquivo"
}

files_func(){
	while IFS= read -r arquivo || [[ -n "$arquivo" ]]; do
		req=$(curl -o /dev/null -sw "%{http_code}" "$url/$arquivo.$ext")
		if [[ $req == $sc ]]
		then
			echo "Arquivo encontrado => $url.com/$arquivo.$ext"
		fi
	done < $arquivo
}

addressearch_func(){
	wget -q $url
	grep href index.html | cut -d "/" -f 3 | grep "\." | cut -d '"' -f 1 | grep -v "<l" > hosts.txt

	for host in $(cat hosts.txt); do
		echo "Endereço Encontrado => $host"
	done

	rm hosts.txt
	rm index.html
}

if [[ $op == "dir" ]]
then
	dir_func
elif [[ $op == "file" ]]
then
	files_func
elif [[ $op == "addressearch" ]]
then
	addressearch_func
else
	usage_func
fi
