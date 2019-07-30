#!/bin/bash
#
# Set up MacOS environment on machine
#

ENV_SOURCE="${HOME}/Dropbox/env/MacOS"

# Pre-flight checks
[[ ! -d ${ENV_SOURCE} ]] && echo "Sign in and sync Dropbox before using this tool" && exit 1
[[ ! -f ${ENV_SOURCE}/INCLUDED_FILES.txt ]] && echo "${ENV_SOURCE}/INCLUDED_FILES.txt does not exist" && exit 1
for file in $(${ENV_SOURCE}/INCLUDED_FILES.txt) ; do
  full_path=${ENV_SOURCE}/${file}
  [[ ! -e $full_path ]] && echo "${full_path} does not exist" && exit 1
done

# Verify
if [[ ${1} = "-f" ]] ; then
  echo "Skipping confirmation with '-f' force flag."
else
  echo "This will replace the following files in ${HOME}"
  cat "${ENV_SOURCE}/INCLUDED_FILES.txt"
  echo "Are you sure you want to do this? (n/Y)"
  read confirm && [[ ${confirm} = y || ${confirm} = Y ]] || exit 1
fi

# Backup
timestamp=$(date '+%Y%m%d%H%M%S')
backup_dir="${HOME}/.env_backup_${timestamp}"
[[ ! -d ${backup_dir} ]] && mkdir "${backup_dir}"
echo "Creating backup under ${backup_dir}..."
for file in $(cat "${ENV_SOURCE}/INCLUDED_FILES.txt") ; do
  [[ -e ${HOME}/${file} ]] && mv "${HOME}/${file}" "${backup_dir}"
done

echo "Linking files..."
for file in $(cat "${ENV_SOURCE}/INCLUDED_FILES.txt") ; do
  ln -s "${ENV_SOURCE}/${file}" "${HOME}/${file}"
done

echo "Done!"
