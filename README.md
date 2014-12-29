# rubygems-mirror docker image

## Build rubygems-mirror docker image
```
git clone git@github.com:eg5846/rubygems-mirror-docker.git
cd rubygems-mirror-docker
sudo docker build -t eg5846/rubygems-mirror-docker .

# Pushing image to registry.hub.docker.com is no longer required!!!
# Image build is automatically initiated after pushing commits of project to github.com
# sudo docker push eg5846/rubygems-mirror-docker
```

## Inspect rubygems-mirror docker image
```
sudo docker run --rm -ti -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror-docker /bin/bash
```

## Run rubygems-mirror docker image
```
sudo docker run --rm -t -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror-docker

# Run behind a HTTP proxy
sudo docker run --rm -t -v /export/rubygems.org:/mirror/rubygems.org -e http_proxy="http://192.168.1.10:800/" eg5846/rubygems-mirror-docker
```
CMD mirrors rubygems.org to given volume.  
