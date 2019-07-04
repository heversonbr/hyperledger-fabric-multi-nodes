#!/bin/bash

############################
# Setup anchor peer for acme
# Set the context
. bins/set-context.sh acme

# Submit the channel create tx
bins/submit-channel-create.sh

# Give time for the channel tx to propagate
sleep 3s

# Join acme peer to the channel
bins/join-channel.sh

sleep 3s

# Update anchor peer in channel
bins/anchor-update.sh

############################
# Setup anchor peer for budget
# Set the context
. bins/set-context.sh budget

# Join the budget peer
bins/join-channel.sh

sleep 3s

# Update anchor peer in channel
bins/anchor-update.sh