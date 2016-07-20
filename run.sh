#!/bin/bash
[[ $VER ]] && NODE_VER=$VER || NODE_VER="node"

echo "nvm install $NODE_VER" >> /root/.bashrc

DEBIAN_VER=$(cat /etc/debian_version)
echo "NODE_VER=\$(nvm current)" >> /root/.bashrc
echo "npm config set user 0" >> /root/.bashrc
echo "npm config set unsafe-perm true" >> /root/.bashrc
echo "chown -R root:root /root/.nvm/versions/node" >> /root/.bashrc
echo "echo '##############'" >> /root/.bashrc
echo "echo \"Debian : $DEBIAN_VER\"" >> /root/.bashrc
echo "echo \"Node   : \$NODE_VER\"" >> /root/.bashrc
echo "echo '##############'" >> /root/.bashrc

if [ -d /src ];
then
  echo "cd /src" >> /root/.bashrc
fi

/bin/bash
