
# docker-saltstack

Docker Compose setup to spin up a salt master and minions.

You will need a system with Docker and Docker Compose installed to use this project.

Just run:

`docker compose up -d`

Then you can run :

`docker compose exec salt-master bash`

and it will log you into the command line of the salt-master server.

From that command line you can run something like:

`salt '*' test.ping`

and in the window where you started docker compose, you will see the log output of both the master sending the command and the minion receiving the command and replying.

The salt-master is set up to accept all minions that try to connect.  Since the network that the salt-master sees is only the docker-compose network, this means that only minions within this docker-compose service network will be able to connect (and not random other minions external to docker).

#### Running multiple minions

`docker-compose up --scale salt-minion=2`

This will start up two minions instead of just one.

#### Host Names

Run the `rename_minions.sh 'number of minions'` script to rename the hostnames. Otherwise the hostnames in salt are set to the container ids making it harder to reference them.
The script currently sets the hostname to minion-x where x a number from 1 to the number provided to the script.
If you are running more than one minion with `--scale=2`, you will need to use `docker-saltstack_salt-minion_1` and `docker-saltstack_salt-minion_2` for the minions if you want to target them individually.
