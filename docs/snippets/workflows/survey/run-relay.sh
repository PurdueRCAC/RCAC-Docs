#!/bin/bash
# FILENAME: run-relay.sh
# Start this cluster's HyperShell relay on its login00 node. Run it after
# module load hypershell:
#   bash run-relay.sh
# The relay asks the server on Geddes for work in the zones of relay.toml
# and starts clients for it with srun, as many as the server's plan asks.

# Use the survey's relay settings and no other configuration.
export HYPERSHELL_SITE=$HOME/survey/hypershell
export HYPERSHELL_CONFIG_FILE=$HYPERSHELL_SITE/relay.toml

# Start the relay in the background, so that it keeps running after you
# log out, with its messages in relay.log.
nohup hs relay >> $HYPERSHELL_SITE/relay.log 2>&1 &

# Note the relay's process ID, to drain or stop it later.
echo $! > $HYPERSHELL_SITE/relay.pid
echo "Relay started on $(hostname -s) with process ID $!"
