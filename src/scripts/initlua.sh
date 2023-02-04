#/bin/bash
#
# Either run this script from where your servershared
# dir is or replace the . with the absolute path
#
# WARNING: Untested.
servershareddir=.

docker run -it --rm \
-v $servershareddir/lua/share:/usr/local/share/lua/5.1 \
-v $servershareddir/lua/lib:/usr/local/lib/lua/5.1 \
-v $( dirname -- "$0"; )/configurelua.sh:/mnt/configurelua.sh \
nwnxee/builder bash -c '/mnt/configurelua.sh'
