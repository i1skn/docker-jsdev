# JavaScript development using Docker
Everything below should be useful for everyone, who developing using `node`.

### Example
1. Install [Docker](https://docs.docker.com/engine/installation)  
2. Run [install script](#install) and do not forget to `source` updated configuration (you will be notified with more detail instructions during the process).
3. Just do this:
```
cd ~/my-cool-project // Move to your project directory
jsd 8000             // Run Linux environment with latest Node installed
                        // When container starting - it will mound current directory to /src
npm install          // Install deps
npm start            // Run the server
```
4. Enjoy your development :)

### Why you want to develop NodeJS with Docker?
* Finally Docker released versions for [Mac](https://docs.docker.com/engine/installation/mac/#/docker-for-mac) and [Windows](https://docs.docker.com/engine/installation/windows/#/docker-for-windows), which implements "native" approach.
* Host machine is not polluted with `npm` `nvm` `global node modules` stuff.
* You can copy your node environment and easily restore it somewhere else (Read: you can share it with your team).
* You can run your code on production like environment.
* Things like `node-gyp` is not a problem anymore!

### Why just not use official node Docker image?
[Official image](https://hub.docker.com/_/node/) has only one installed node version per image. So basically to run another node version, you will need another image.  
This image give you possibility to use multiple node versions within the same image.

### How this works
Basically we take debian image and install python, gcc and other useful stuff.  
Next we install [nvm](https://github.com/creationix/nvm) to be able use multiple node versions.  
So now when you run a container from this image you will need to install needed node version. If we will do this way, time to run a container will be around 1 minute (depend from internet connection and CPU) which is not really convenient.  
But we can improve this approach with caching!

### NVM Cache
Because we want to be able to run containers with different `node` versions, there are no `node` in the image as we mentioned before. This mean, that every time we run a container - `nvm` is about to install `node`. To prevent this we can create [Data Volume Container](https://docs.docker.com/v1.10/engine/userguide/containers/dockervolumes/) to store `nvm` cache.
```
docker create -v /root/.nvm -v /root/.node-gyp --name nvm-cache i1skn/jsdev
```
So now you do not need to download `node` every time you run a container.

### Run dev environment
```
docker run --volumes-from nvm-cache -p 8080:8080 -i -t -e VER=6.2.2 -v $(pwd):/src i1skn/jsdev
```
After container created you will be automatically moved to `/src` if it exist.  
- **VER** (optional) is `node` version, default to latest version.   

This looks a bit long, but we have **SHORCUT** for it.

### <a name="install"></a>Install
To install, you can use the install script using cURL:
```
curl -o- https://raw.githubusercontent.com/i1skn/docker-jsdev/master/install.sh | bash
```
Script will create `NVM Cache container` and also add **jsd** tool, which will make usage even simplier!  

So, instead of:
```
docker run --volumes-from nvm-cache -p 8080:8080 -p 8000:8000 -p 3000:3000-i -t -e VER=6.2.2 -v $(pwd):/src i1skn/jsdev
```
you can type
```
jsd -v 4.2.2 3000 8000 8080
```
### License
MIT
