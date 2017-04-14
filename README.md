# ChpokClient

Learning project, peer-to-peer file sharing over WebSockets!

## Run Seeder
docker run -v /home/yz/Downloads/chpok_src/:/dir --env NAME=Seed name_of_docker_image

## Run Leacher
docker run -v /home/yz/Downloads/chpok_dst/:/dir --env NAME=Leach --env LEACHER=true name_of_docker_image
