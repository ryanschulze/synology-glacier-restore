#!/bin/bash

set -o nounset

abort() {
	echo "USAGE: $(basename "${0}") <mapping_file> <encoded_files_directory> <destination_deirectory>";
	echo "${@:-}"
	exit 1
}

[[ ! $# -eq 3 ]] && abort "Error: Not enough arguments"

mappingFile="${1:-}"
sourceDir="${2:-}"
destDir="${3:-}"

[[ ! -r "${mappingFile}" ]] && abort "Error: Mapping file '${mappingFile}' isn't readable"
[[ ! -d "${sourceDir}" ]] && abort "Error: Source directory '${sourceDir}' doesn't exist"
[[ ! -d "${destDir}" ]] && abort "Error: Destination directory '${destDir}' doesn't exist"


# generate list of file mappings from sqlite database
fileList="$(sqlite3 "${mappingFile}" "select basePath,archiveID from file_info_tb")"

for pair in ${fileList}; do
	# split source and destination from string
	filePath="${pair%|*}"
	fileSource="${pair#*|}"

	# check if we need to create subdirectories
	if [[ ${filePath} =~ / ]] ; then
		mkdir -p "${destDir}/${filePath%/*}"
	fi

	# copy files
	if [[ -f "${sourceDir}/${fileSource}" ]] ; then
		cp "${sourceDir}/${fileSource}" "${destDir}/${filePath}"
		echo "OK: restored ${filePath}"
	else 
		echo "ERROR: ${filePath} could not be restored (${sourceDir}/${fileSource} not found)"
	fi
done
