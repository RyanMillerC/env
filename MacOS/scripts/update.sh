#!/bin/bash
#
# Update repo with files from ENV_SOURCE
#

ENV_SOURCE="${HOME}/Dropbox/env/MacOS"

# Pre-flight checks
[[ ! -d ${ENV_SOURCE} ]] && echo "Sign in and sync Dropbox before using this tool" && exit 1
[[ ! -f ${ENV_SOURCE}/INCLUDED_FILES.txt ]] && echo "${ENV_SOURCE}/INCLUDED_FILES.txt does not exist" && exit 1
for file in $(cat "${ENV_SOURCE}/INCLUDED_FILES.txt") ; do
  full_path="${ENV_SOURCE}/${file}"
  [[ ! -e ${full_path} ]] && echo "${full_path} does not exist" && exit 1
done

echo "Clearing src..."
for file in $(cat "${ENV_SOURCE}/INCLUDED_FILES.txt") "INCLUDED_FILES.txt" ; do
  rm -r "src/${file}"
done

echo "Copying files from ${ENV_SOURCE} to src..."
for file in $(cat "${ENV_SOURCE}/INCLUDED_FILES.txt") "INCLUDED_FILES.txt" ; do
  cp -r "${ENV_SOURCE}/${file}" src
done

echo "Done!"
