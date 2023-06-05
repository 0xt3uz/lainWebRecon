#!/bin/bash

arquivo=$2
op=$1
url=$3
sc=$4

if [ $5 ]
then
	ext=$5
else
	ext="txt"
fi

usage_func(){
	echo -e "Usage: ./lainWebRecon <op> <url> <wordlist> <http_status_code> <ext>\n"

	echo "<op>: dir ou files"
	echo "<url>: host url"
	echo "<wordlist>: lista com nomes"
	echo "<ext>: extensão para busca (útil apenas em casos de busca por arquivos)"
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


if [[ $op == "dir" ]]
then
	dir_func
elif [[ $op == "file" ]];
then
	files_func
else
	usage_func
fi
