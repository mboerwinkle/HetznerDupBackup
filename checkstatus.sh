#! /bin/bash
set -e # exit on failure
lockfile=$(jq -Mr .lockfile config.json)
duplicitypassphrase=$(jq -Mr .duplicitypassphrase config.json)
hetzneruser=$(jq -Mr .hetznerstorageboxuser config.json)
localtarget=$(jq -Mr .localtarget config.json)
remotetarget=$(jq -Mr .remotetarget config.json)
if { set -C; 2>/dev/null > "$lockfile"; }; then
 trap "rm -f \"$lockfile\"" EXIT
else
 echo "Lock file ($lockfile) exists. Aborting."
 exit
fi
export PASSPHRASE="$duplicitypassphrase"
echo "# Disk Usage"
echo 'df -h' | sftp -oIdentityFile=sshprivkey -oPort=23 "$hetzneruser@$hetzneruser.your-storagebox.de"
echo "# Collection Status"
duplicity collection-status --ssh-options='-oIdentityFile=sshprivkey' "rsync://$hetzneruser@$hetzneruser.your-storagebox.de:23/$remotetarget"
echo "# Verify"
duplicity verify --ssh-options='-oIdentityFile=sshprivkey' "rsync://$hetzneruser@$hetzneruser.your-storagebox.de:23/$remotetarget" "$localtarget"
echo "# List Files"
duplicity list-current-files --ssh-options='-oIdentityFile=sshprivkey' "rsync://$hetzneruser@$hetzneruser.your-storagebox.de:23/$remotetarget"


unset PASSPHRASE
