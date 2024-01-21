#!/bin/sh
ssh-keygen -q -f sshprivkey -N ''
mv sshprivkey.pub authorized_keys
echo 'Generated `sshprivkey` and `authorized_keys`.'
echo 'Copy `authorized_keys` to remote `.ssh/` directory.'
