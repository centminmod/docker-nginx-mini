function nps_stop() {

	if [[  -z $2  ]]; then process="all"; else process="$2"; fi
	
	/usr/bin/supervisorctl stop $process
	
}
