# ChpokClient

Useless peer-to-peer file sharing over WebSockets.

## Run Seeder
docker run -v /home/yz/Downloads/chpok_src/:/dir --env NAME=Seed client2

## Run Leacher
docker run -v /home/yz/Downloads/chpok_dst/:/dir --env NAME=Leach --env LEACHER=true client2
