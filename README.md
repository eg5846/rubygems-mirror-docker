# rubygems-mirror docker image

## Build rubygems-mirror docker image
```
git clone git@github.com:eg5846/rubygems-mirror-docker.git
cd rubygems-mirror
sudo docker build -t eg5846/rubygems-mirror .

# Pushing image to registry.hub.docker.com is no longer required!!!
# Image build is automatically initiated after pushing commits of project to github.com
#sudo docker push eg5846/rubygems-mirror
```

## Inspect rubygems-mirror docker image
```
sudo docker run --rm -ti -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror /bin/bash
```

## Run rubygems-mirror docker image
```
sudo docker run --rm -t -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror
```
CMD mirrors rubygems.org to given volume and creates file 'content.cto'.  
Volume should be shared by a webserver container.  
Use 'contento/fetch_files.rb' to fetch files from the webserver.
