#!/usr/bin/env bash
# Usage: smoke-test.sh <image>
# Starts the image, waits for the real server, and checks that initialization
# completed. Shared by every CI build job so the checks cannot drift apart.
set -euo pipefail

image="$1"

docker run -d --name test-mysql \
	-e MYSQL_ROOT_PASSWORD=test \
	"$image"

# Probe over TCP rather than the unix socket. While it initializes, the
# entrypoint runs a temporary server started with --skip-networking, so
# a socket probe reports ready against that server and the connection is
# then pulled away when it is shut down. Only the real server has TCP.
ready=
for i in $(seq 1 60); do
	if docker exec test-mysql mysql -h 127.0.0.1 -uroot -ptest -e "SELECT VERSION()" 2>/dev/null; then
		ready=yes
		break
	fi
	sleep 2
done
# Without this check the loop simply falls through when the server
# never starts, and the step passes on a completely broken image.
if [ "$ready" != yes ]; then
	echo "Server never became ready. Container log:"
	docker logs test-mysql
	exit 1
fi

# The entrypoint loads the time zone tables from /usr/share/zoneinfo.
# An empty table means the image is missing tzdata.
tz="$(docker exec test-mysql mysql -h 127.0.0.1 -uroot -ptest -N -e 'SELECT COUNT(*) FROM mysql.time_zone_name')"
echo "time zone names loaded: $tz"
[ "$tz" -gt 0 ]

docker stop test-mysql
docker rm test-mysql
