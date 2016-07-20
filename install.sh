detect_profile() {
  if [ -n "$PROFILE" -a -f "$PROFILE" ]; then
    echo "$PROFILE"
    return
  fi

  local DETECTED_PROFILE
  DETECTED_PROFILE=''
  local SHELLTYPE
  SHELLTYPE="$(basename "/$SHELL")"

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    if [ -f "$HOME/.profile" ]; then
      DETECTED_PROFILE="$HOME/.profile"
    elif [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
      DETECTED_PROFILE="$HOME/.zshrc"
    fi
  fi

  if [ ! -z "$DETECTED_PROFILE" ]; then
    echo "$DETECTED_PROFILE"
  fi
}

PROFILE=$(detect_profile)
INSTALL_DIR="$HOME/.docker-jsdev"
JSD_FILE="$INSTALL_DIR/jsd.sh"

docker -v > /dev/null 2>&1
if [ $? == 0 ] ; then
  echo "=> $(docker -v) found"
else
  echo "=> Docker is not installed!"
  echo "=> Please go to https://docs.docker.com/engine/installation/, install docker and run this script again."
fi

# echo "=> Creating Data Volume Container for nvm cache..."
# DOCKER_NVM_CACHE=$(docker create -v /root/.nvm -v /root/.node-gyp --name nvm-cache i1skn/jsdev 2>&1)
# if [ $? == 0 ] ; then
#   echo "=> Done! Container with ID $DOCKER_NVM_CACHE was created!"
# else
#   echo "Failed! $DOCKER_NVM_CACHE"
# fi

mkdir -p $INSTALL_DIR

touch $JSD_FILE
JSD="PORTS=\"\"\nfor port in \"\$@\"\ndo\nPORTS=\"-p \$port:\$port \$PORTS\"\ndone\ndocker run --volumes-from nvm-cache \$PORTS -i -t -e VER=6.2.2 -v \$(pwd):/src i1skn/jsdev"
echo $JSD > $JSD_FILE
chmod +x $JSD_FILE

# SOURCE_STR=
#
# if [ -z "$PROFILE" ] ; then
#    echo "=> Profile not found. Tried $PROFILE (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
#    echo "=> Create one of them and run this script again"
#    echo "=> Create it (touch $PROFILE) and run this script again"
#    echo "   OR"
#    echo "=> Append the following lines to the correct file yourself:"
#    printf "$SOURCE_STR"
#    echo
#  else
#    if ! command grep -qc '/nvm.sh' "$PROFILE"; then
#      echo "=> Appending source string to $PROFILE"
#      printf "$SOURCE_STR\n" >> "$PROFILE"
#    else
#      echo "=> Source string already in $PROFILE"
#    fi
#  fi
