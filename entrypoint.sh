#!/bin/sh

set -e # exit inmediately on command execution failure
set -u # treat unset variables as an error when substituting
set -x # show commands when executing

FINAL_MINETEST_CONFIG='/srv/minetest/data/minetest.conf'
TEMPORARY_MINETEST_CONFIG='/tmp/minetest.conf'

if [ ! -e "$FINAL_MINETEST_CONFIG" ]
then
	if [ -n "${NAME}" ]
	then
		echo "name = $NAME" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No administration account name'
		exit 1
	fi

	if [ -n "${SERVER_NAME}" ]
	then
		echo "server_name = $SERVER_NAME" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No server name'
		exit 1
	fi

	if [ -n "${SERVER_DESCRIPTION}" ]
	then
		echo "server_description = $SERVER_DESCRIPTION" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No server description'
		exit 1
	fi

	if [ -n "${SERVER_ADDRESS}" ]
	then
		echo "server_address = $SERVER_ADDRESS" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No server address'
		exit 1
	fi

	if [ -n "${SERVER_URL}" ]
	then
		echo "server_url = $SERVER_URL" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No server URL'
		exit 1
	fi

	if [ -n "${SERVER_ANNOUNCE}" ]
	then
		echo "server_announce = $SERVER_ANNOUNCE" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		SERVER_ANNOUNCE='false'
		echo "server_announce = $SERVER_ANNOUNCE" >> "$TEMPORARY_MINETEST_CONFIG"
	fi

	if [ -n "${MOTD}" ]
	then
		echo "motd = $MOTD" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No message of the day'
		exit 1
	fi

	if [ -n "${MAX_USERS}" ]
	then
		echo "max_users = $MAX_USERS" >> "$TEMPORARY_MINETEST_CONFIG"
	else
		echo 'No maximum number of users'
		exit 1
	fi

	if [ -n "${DEFAULT_PASSWORD}" ]
	then
		echo "default_password = $DEFAULT_PASSWORD" >> "$TEMPORARY_MINETEST_CONFIG"
	fi

	echo 'disallow_empty_password = true' >> "$TEMPORARY_MINETEST_CONFIG"
	echo 'enable_rollback_recording = true' >> "$TEMPORARY_MINETEST_CONFIG"

	if [ -n "${MAP_DIR}" ]
	then
		echo "map-dir = $MAP_DIR" >> "$TEMPORARY_MINETEST_CONFIG"	
	else
		MAP_DIR='/srv/minetest/data/worlds/world'
		echo "map-dir = $MAP_DIR" >> "$TEMPORARY_MINETEST_CONFIG"
	fi

	mkdir -p $MAP_DIR

	echo 'default_game = mineclone2' >> "$TEMPORARY_MINETEST_CONFIG"

	mv "$TEMPORARY_MINETEST_CONFIG" "$FINAL_MINETEST_CONFIG"
fi

FINAL_WORLD_CONFIG="$MAP_DIR/world.mt"
TEMPORARY_WORLD_CONFIG='/tmp/world.mt'

if [ ! -e "$FINAL_WORLD_CONFIG"  ]
then
	echo 'gameid = mineclone2' >> "$TEMPORARY_WORLD_CONFIG"

	if [ -n "${CREATIVE_MODE}" ]
	then
		echo "creative_mode = $CREATIVE_MODE" >> "$TEMPORARY_WORLD_CONFIG"
	else
		CREATIVE_MODE='false'
		echo "creative_mode = $CREATIVE_MODE" >> "$TEMPORARY_WORLD_CONFIG"
	fi

	if [ -n "${ENABLE_DAMAGE}" ]
	then
		echo "enable_damage = $ENABLE_DAMAGE" >> "$TEMPORARY_WORLD_CONFIG"
	else
		ENABLE_DAMAGE='true'
		echo "enable_damage = $ENABLE_DAMAGE" >> "$TEMPORARY_WORLD_CONFIG"
	fi

	echo 'backend = sqlite3' >> "$TEMPORARY_WORLD_CONFIG"
	echo 'auth_backend = sqlite3' >> "$TEMPORARY_WORLD_CONFIG"
	echo 'player_backend = sqlite3' >> "$TEMPORARY_WORLD_CONFIG"
	echo 'mod_storage_backend = sqlite3' >> "$TEMPORARY_WORLD_CONFIG"

	mv "$TEMPORARY_WORLD_CONFIG" "$FINAL_WORLD_CONFIG"
fi

exec /srv/minetest/application/bin/minetestserver --config "$FINAL_MINETEST_CONFIG"
