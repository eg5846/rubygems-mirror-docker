# rubygems-mirror docker image

## Build rubygems-mirror docker image
```
git clone git@github.com:eg5846/rubygems-mirror-docker.git
cd rubygems-mirror
sudo docker build -t eg5846/rubygems-mirror .
sudo docker push eg5846/rubygems-mirror
```

## Inspect rubygems-mirror docker image
```
sudo docker run --rm -ti -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror /bin/bash
```

## Run rubygems-mirror docker image
```
sudo docker run --rm -ti -v /export/docker/rubygems-mirror/mirror/rubygems.org:/mirror/rubygems.org eg5846/rubygems-mirror
```
CMD mirrors rubygems.org to given volume and creates file content.cto.  
Volume should be shared by a webserver container.  
Use 'contento/fetch_files.rb' to fetch files from the webserver.
