#!/bin/bash
[[ $VER  ]] && NODE_VER=$VER || NODE_VER="node"

echo "nvm install $NODE_VER > /dev/null 2>&1" >> /root/.bashrc

DEBIAN_VER=$(cat /etc/debian_version)
echo "NODE_VER=\$(nvm current)" >> /root/.bashrc

echo "echo 'Debian : $DEBIAN_VER'" >> /root/.bashrc
echo "echo 'Node   : $NODE_VER'" >> /root/.bashrc

if [ -d /src ];
then
  echo "cd /src" >> /root/.bashrc
fi

/bin/bash
