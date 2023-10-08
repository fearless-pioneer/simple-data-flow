#!/bin/bash
set -e

# Create data directory
mkdir -p docker/data-generator/data

# Function to install aria2
install_aria2() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian
        sudo apt-get update && sudo apt-get install -y aria2
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS
        brew install aria2
    else
        echo "Unsupported OS. Please install aria2 manually."
        exit 1
    fi
}

# Check if aria2c is installed, if not install it
if ! command -v aria2c &> /dev/null
then
    install_aria2
fi

# Download the data using aria2
aria2c -Z \
https://data.rees46.com/datasets/marketplace/2019-Oct.csv.gz \
https://data.rees46.com/datasets/marketplace/2019-Dec.csv.gz \
-d ./data

# Decompress the data using gunzip
gunzip ./data/*.gz
