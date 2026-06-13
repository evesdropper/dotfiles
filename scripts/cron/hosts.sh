#/bin/sh

# adds new hosts to blocklist weekly
docker run --pull always --rm -it -v /etc/hosts:/etc/hosts -v "/etc/myhosts:/hosts/myhosts" ghcr.io/stevenblack/hosts:latest updateHostsFile.py --auto --replace --extensions fakenews gambling porn
