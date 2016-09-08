# How to run openstreetmaps (osm) docker container environment:

The openstreetmaps (aka OSM) docker stack is compose of consul container that is going to store some config keys and files to custom
our OSM, and OSM container that has a postgresql, php and apache2.

## CUSTOMIZE YOUR OSM:

1. Create a file in config/local_php

	~~~
	NOTE: Example in production for Germany
	<?php
 	// Paths
 	@define('CONST_Postgresql_Version', '9.3');
 	@define('CONST_Postgis_Version', '2.1');
 	// Website settings
 	@define('CONST_Website_BaseURL', 'https://subdomain.your.site/');
 	@define('CONST_Replication_Url', 'http://download.geofabrik.de/europe/germany-updates');
 	@define('CONST_Replication_MaxInterval', '86400');     // Process each update separately, osmosis cannot merge multiple updates
 	@define('CONST_Replication_Update_Interval', '86400');  // How often upstream publishes diffs
 	@define('CONST_Replication_Recheck_Interval', '900');   // How long to sleep if no update found yet
	?>
	~~~

2. Create a file with the next variables:

	~~~
	export CONSUL_URL="http://<CONSUL_IP>:<CONSUL_PORT>"
	export NOMINATIM_USER_PASSWORD="<NOMINATIM_USER_PASSWORD>"
	export OPENSTREETMAP_MAP_FILE_URL="<MAP_FILE>"
	export SERVICE="<COMPONENT_NAME>"
	~~~

   For example, to config Monaco maps (very good for testing because is very small) in my consul that has the ip 192.168.99.100, should be:

	~~~bash
	export CONSUL_URL="http://192.168.99.100:8500"
	export NOMINATIM_USER_PASSWORD="example"
	export OPENSTREETMAP_MAP_FILE_URL="http://download.geofabrik.de/europe/monaco-latest.osm.pbf"
	export SERVICE="maps"
	~~~

## SYNC MAPS:

1. Connect to the OSM container:

        $ docker exec -it nominatim bash

2. Login as nominatim user:

        $ su - nominatim

3. Launch command to sync OSM:

        $ cd /app/nominatim

	>NOTE: Remember that you have to declare CONST_Replication_Url in your local.php file with the proper country maps.
        Create configuration files:

        $ ./utils/setup.php --osmosis-init

        Enable hierarchical updates:

        $ ./utils/setup.php --create-functions --enable-diff-updates

        Run syncronization:

        $ nohup ./utils/update.php --import-osmosis-all --no-npi &

	To see the trace log:

	$ tailf nohup.out

