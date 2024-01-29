#!/bin/bash

# Log the info with the same format as NEO4J outputs
log_info() {
  # https://www.howtogeek.com/410442/how-to-display-the-date-and-time-in-the-linux-terminal-and-use-it-in-bash-scripts/
  # printf '%s %s\n' "$(date -u +"%Y-%m-%d %H:%M:%S:%3N%z") INFO  Wrapper: $1"  # Display UTC time
  printf '%s %s\n' "$(date +"%Y-%m-%d %H:%M:%S:%3N%z") INFO  Wrapper: $1"  # Display local time (PST/PDT)
  return
}

# turn on bash's job control
set -m

# Start the primary process and put it in the background
/startup/docker-entrypoint.sh neo4j &

# Wait for Neo4j
log_info "Checking to see if Neo4j has started..."
wget --quiet --tries=10 --waitretry=10 -O /dev/null http://localhost:7474
log_info "Neo4j has started"

# Run cupher scripts
log_info  "Loading and importing Cypher file(s)..."

for cypherFile in /var/lib/neo4j/import/*.cypher; do
    log_info "Processing ${cypherFile}..."
    cypher-shell -u neo4j -p ${ROOT_PASS} -f ${cypherFile} --fail-fast
done

log_info "Finished processing all Cypher files"

# Foreground the initial process
fg %1
