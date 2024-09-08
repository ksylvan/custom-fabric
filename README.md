# Custom Fabric Patterns

This repository contains custom patterns for the [fabric](https://github.com/danielmiessler/fabric) tool, enhancing its functionality for specific use cases.

## Overview

Fabric is a powerful AI-assistant tool that helps with various tasks. This repository extends fabric's capabilities by adding custom patterns for specialized tasks.

## Custom Patterns

The patterns in this repository are designed to be used with fabric's `--pattern` flag.

Each pattern is a separate file in the `patterns` directory, and each file contains a system description,
input instructions, output instructions, and an example input and output.

## Usage

To use these custom patterns with fabric:

1. Ensure you have fabric installed and configured.
2. Clone this repository to your local machine.
3. Run the update script to add these patterns to your fabric configuration:

```bash
./update-fabric.sh
```

The `update-fabric.sh` script will update your fabric configuration with the custom patterns and also
create an alias for each pattern in your fabric configuration.
