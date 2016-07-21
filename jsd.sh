PORTS=""
VERSION=""
while [[ $@ ]]
do
key="$1"
case $key in
    -v|--version)
    VERSION="$2"
    shift
    ;;
    *)
    PORTS="-p $1:$1 $PORTS"
    ;;
esac
shift
done
docker run --rm --volumes-from nvm-cache $PORTS -i -t -e VER=$VERSION -v $(pwd):/src i1skn/jsdev
