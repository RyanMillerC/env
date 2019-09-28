#!/bin/bash
#
# Restore ENV_SOURCE to a previous version
#

ENV_SOURCE="${HOME}/Dropbox/env/MacOS"

# Pre-flight checks
[[ ! -d ${ENV_SOURCE} ]] && echo "Sign in and sync Dropbox before using this tool" && exit 1
[[ ! -f src/INCLUDED_FILES.txt ]] && echo "src/INCLUDED_FILES.txt does not exist" && exit 1
for file in $(cat "src/INCLUDED_FILES.txt") ; do
  full_path="src/${file}"
  [[ ! -e ${full_path} ]] && echo "${full_path} does not exist" && exit 1
done

# Verify
if [[ ${1} = "-f" ]] ; then
  echo "Skipping confirmation with '-f' force flag."
else
  echo "This will replace the following files in ${ENV_SOURCE} with versions from this repo:"
  cat "src/INCLUDED_FILES.txt"
  echo "Are you sure you want to do this? (n/Y)"
  read confirm && [[ ${confirm} = y || ${confirm} = Y ]] || exit 1
fi

echo "Removing existing files..."
for file in $(cat src/INCLUDED_FILES.txt) "INCLUDED_FILES.txt" ; do
  [[ -e ${ENV_SOURCE}/${file} ]] && rm -r "${ENV_SOURCE}/${file}"
done

echo "Restoring files..."
for file in $(cat "src/INCLUDED_FILES.txt") "INCLUDED_FILES.txt" ; do
  cp -r "src/${file}" "${ENV_SOURCE}"
done

echo "Done!"
