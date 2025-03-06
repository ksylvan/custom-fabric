# Custom Fabric Patterns

This repository contains custom patterns for the [fabric](https://github.com/danielmiessler/fabric) tool, enhancing its functionality for specific use cases.

## Overview

Fabric is a powerful AI-assistant tool that helps with various tasks.

This repository extends fabric's capabilities by adding custom patterns for specialized tasks.

## Custom Patterns

The patterns in this repository are designed to be used with fabric's `--pattern` flag.

Each pattern is a separate file in the `patterns` directory, and each file contains a system description,
input instructions, output instructions, and an example input and output.

## Usage

To use these custom patterns with fabric:

1. Ensure you have fabric installed and configured.
2. Clone this repository to your local machine.
3. Run the update script to add these patterns to your fabric configuration:

On MacOS and Linux:

```shell
./update-fabric.sh
```

On Windows, in a PowerShell window:

```shell
./update-fabric.ps1
```

This will copy the custom patterns into the correct location, at which point they are seen by `fabric`.

**Note:** The file `custom_pattern_explanations.md` is also installed in `~/.config/fabric/patterns`. This
file contains brief one-line summaries of the custom patterns.

### Shell Startup an Automatic Fabric Pattern Aliases

The `update-fabric` also installs the `fabric-bootstrap` and `model-defs` scripts in
the `$HOME/.config/fabric` directory.

The bootstrap scrip implements the [Aliases for All Patterns][aliases] startup
shell suggestions from the fabric project.

On MacOS/Linux systems, you only have to add this line to your shell startup (in `.zshrc` or `.bashrc`):

```shell
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then . "$HOME/.config/fabric/fabric-bootstrap.inc"; fi
```

on Windows, in your PowerShell startup script (referenced by `$PROFILE`), add this snippet:

```shell
$fabricPath = Join-Path $HOME ".config/fabric"
$fabricBootstrapPath = "$fabricPath\fabric-bootstrap.ps1"
if (Test-Path -Path $fabricBootstrapPath) {
  Write-Host "Sourcing additional script: $fabricBootstrapPath"
  . $fabricBootstrapPath
}
else {
  Write-Host "Additional script not found: $fabricBootstrapPath"
}
```

Now, when you create a new shell, all your fabric patterns are available as aliases.

[aliases]: https://github.com/danielmiessler/fabric?tab=readme-ov-file#add-aliases-for-all-patterns
