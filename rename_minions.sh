#!/bin/bash

# 1. Check if the user provided a number
if [ -z "$1" ]; then
  echo "Error: No number provided."
  echo "Usage: ./rename-minions.sh <number_of_minions>"
  exit 1
fi

MAX_MINIONS=$1

# Update this if your master container has a different name!
MASTER_CONTAINER="docker-saltstack-sandbox-salt-master-1"

for i in $(seq 1 $MAX_MINIONS); do
  CONTAINER_NAME="docker-saltstack-sandbox-salt-minion-$i"
  NEW_ID="minion-$i"

  echo "Updating $CONTAINER_NAME to $NEW_ID..."

  # Grab the current container hostname (the old minion ID) so we can delete its key later
  OLD_ID=$(docker exec $CONTAINER_NAME hostname)

  # Write the new ID configuration into the container
  docker exec $CONTAINER_NAME sh -c "echo 'id: $NEW_ID' > /etc/salt/minion.d/id.conf"

  docker restart $CONTAINER_NAME >/dev/null
  # remove old salt keys, new keys are auto accepted
  docker exec $MASTER_CONTAINER salt-key -y -d "$OLD_ID" >/dev/null 2>&1
  echo "Container restarted. Waiting for minion to send its new key to the master..."

  echo "Successfully updated minion, and accepted $NEW_ID on the Master."
  echo "----------------------------------------"
done

echo "Done! All $MAX_MINIONS minions are renamed, restarted, and accepted."
