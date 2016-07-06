# JS development using Docker
This docker image is useful for developing using `node`.

### Why you want to use this?
* Finally Docker released versions for [Mac](https://docs.docker.com/engine/installation/mac/#/docker-for-mac) and [Windows](https://docs.docker.com/engine/installation/windows/#/docker-for-windows), which implements "native" approach
* Host machine is not polluted with `npm` `nvm` `global node modules` stuff
* You can copy your node environment and easily restore it somewhere else (Read: you can share it with your team)
* You can run your code on production like environment
* `node-gyp` friendly

### NVM Cache
Because we want to be able to run containers with different `node` versions, there are no `node` in the image. This mean, that every time we run a container - `nvm` is about to install `node`. To prevent this we can create [Data Volume Container](https://docs.docker.com/v1.10/engine/userguide/containers/dockervolumes/) to store `nvm` cache.
```
docker create -v /root/.nvm -v /root/.node-gyp --name nvm-cache i1skn/jsdev
```
So now you do not need to download `node` every time you run a container.

### Run dev environment
```
docker run --volumes-from nvm-cache -p 8080:8080 -i -t -e VER=6.2.2 -v $(pwd):/src i1skn/jsdev
```
After container created you will be automatically moved to `/src` if it exist. **VER** (OPTIONAL) is `node` version, default to latest version.

### Bash alias
For convenience you can create bash alias to run long `docker run` command
* Create directory `~/.jsd`(could be any name)
* Put the file `run.sh` inside this directory with `docker run` script:
```
docker run --volumes-from nvm-cache -p 8080:8080 -i -t -e VER=6.2.2 -v $(pwd):/src i1skn/jsdev
```
* Run `chmod +x ~/.jsd/run.sh`
* Add to your `bash profile`(like .zshrc etc) file following:
```
alias jsd="~/.jsd/run.sh"
```
* Run `source <your_bash_profile_file>`
* Type `jsd` in directory you want to work in
