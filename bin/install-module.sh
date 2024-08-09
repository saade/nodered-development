#!/bin/bash

# Directory containing nodes
NODES_DIR="./nodes"

# Loop over each node directory
for NODE_DIR in $NODES_DIR/*; do
    if [ -d "$NODE_DIR" ]; then
        echo "Processing $NODE_DIR..."

        # Move to the node directory
        cd "$NODE_DIR" || { echo "Failed to enter directory $NODE_DIR"; exit 1; }

        # Pack the module and capture the package name
        PACKAGE=$(npm pack | tail -n 1)

        # Check if npm pack was successful
        if [ $? -ne 0 ]; then
            echo "Error: npm pack failed for $NODE_DIR"
            exit 1
        fi

        # Move the package to the Docker container
        docker cp "$PACKAGE" nodered:/data/
        if [ $? -ne 0 ]; then
            echo "Error: Failed to move $PACKAGE to /data in the container"
            exit 1
        fi

        # Delete the package from the host
        rm "$PACKAGE"

        # Return to the original directory
        cd - || exit
    fi
done

# Install the packages inside the Docker container
docker exec nodered sh -c "cd /data && npm install *.tgz --legacy-peer-deps --omit=dev && rm *.tgz"

# Restart Node-RED using your custom script
npm run docker:restart-nodered

echo "All modules installed and Node-RED restarted successfully."
