#!/bin/bash
#this file generates suppression file for valgrind

function suppression()
{
	if [[ !($1) || !($2) ]]
	then
		echo "usage ${0} [execution file] [output file]"
		return
	fi

	if [[ !(-x $1) ]]
	then
		echo "${1} is not an executable file"
		return
	fi

	if [[ -d $2 ]]
	then
		echo "${2} is a directory"
		return
	fi

	if [[ (-f $2) && !(-w $2) ]]
	then
		echo "${2} permission denied"
		return
	fi

	if [[ !(`command -v valgrind`) ]]
	then
		echo "valgrind is not currently installed yet"
		return
	fi

	valgrind --tool=memcheck --leak-check=full --gen-suppressions=all --error-limit=no --show-leak-kinds=all --log-fd=9 ${1} 9>&1 1>/dev/null 2>/dev/null | grep -v "==" 1>${2}
}

suppression $1 $2