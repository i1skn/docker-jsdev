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
#   echo "=> Failed! $DOCKER_NVM_CACHE"
# fi

mkdir -p $INSTALL_DIR
echo "=> Donwloading jsd alias script..."
SCRIPT_FILE=$(curl -q -s "https://raw.githubusercontent.com/i1skn/docker-jsdev/master/jsd.sh" -o $JSD_FILE 2>&1)
if [ $? == 0 ] ; then
  echo "=> Done! Saved to $JSD_FILE"
else
  echo "=> Failed! $SCRIPT_FILE"
  exit
fi
chmod +x $JSD_FILE

if [ -z "$PROFILE" ] ; then
  echo "=> Profile not found. Tried $PROFILE (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
  echo "=> Create one of them and run this script again"
  echo "=> Create it (touch $PROFILE) and run this script again"
  echo "   OR"
  echo "=> Append the following lines to the correct file yourself:"
  printf "alias jsd=\"$JSD_FILE\""
  echo
else
  if ! command grep -qc 'jsd' "$PROFILE"; then
    echo "=> Appending JSD string to $PROFILE"
    printf "alias jsd=\"$JSD_FILE\"\n" >> "$PROFILE"
  else
    echo "=> JSD alias already in $PROFILE"
  fi
fi

echo "\n=> Installation process is succesfully finished!\n"
echo "   !!! Please do now 'source $PROFILE' and after you can start developing!\n"
echo "   After this, just navigate to the project directory and run 'jsd' command!\n"
echo "   Examples:"
echo "   jsd -v 4.2.2 3000 8000    will start environment with node version 4.2.2 and open ports 3000 and 8000"
echo "   jsd 8080                  will start environment with the latest node version and open port 8080"
