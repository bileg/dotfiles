https://stackoverflow.com/questions/24309526/how-to-change-the-docker-image-installation-directory

First create directory and file for custom configuration:

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo $EDITOR /etc/systemd/system/docker.service.d/docker-storage.conf
For docker version before 17.06-ce paste:

[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --graph="/data2/docker_images"
For docker after 17.06-ce paste:

[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --data-root="/data2/docker_images"
Then reload configuration and restart Docker:

sudo systemctl daemon-reload
sudo systemctl restart docker
To confirm that Docker was reconfigured:

docker info|grep "loop file"
In recent version (17.03) different command is required:

docker info|grep "Docker Root Dir"
Output should look like this:

 Data loop file: /mnt/devicemapper/devicemapper/data
 Metadata loop file: /mnt/devicemapper/devicemapper/metadata
Or:

 Docker Root Dir: /mnt
Then you can safely remove old Docker storage:

rm -rf /var/lib/docker

