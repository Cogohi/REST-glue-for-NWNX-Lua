@REM Either run this script from where your volume mounts
@REM dir is or replace the . with the absolute path
set servershareddir=.

docker run -it --rm ^
-v %servershareddir%/lua/share:/usr/local/share/lua/5.1 ^
-v %servershareddir%/lua/lib:/usr/local/lib/lua/5.1 ^
-v %~dp0/configurelua.sh:/mnt/configurelua.sh ^
nwnxee/builder bash -c '/mnt/configurelua.sh'
