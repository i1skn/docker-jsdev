# JS development using Docker
This docker image is useful for developing using `node`.


### NVM Cache
Because we want to be able to run containers with different `node` versions, there are no `node` in the image. This mean, that every time we run a container - `nvm` is about to install `node`. To prevent this we can create [Data Volume Container](https://docs.docker.com/v1.10/engine/userguide/containers/dockervolumes/) to store `nvm` cache.
```
docker create -v /root/.nvm --name nvm-cache i1skn/jsdev
```
So now you do not need to download `node` every time you run a container.

### Run dev environment
```
docker run --volumes-from nvm-cache -p 8080:8080 -i -t -e VER=6.2.2 -v $(pwd):/src i1skn/jsdev
```
After container created you will be automatically moved to `/src` if it exist. **VER** (OPTIONAL) is `node` version, default to latest version.
