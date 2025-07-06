# See if we have a CUSTOM_PATTERNS_DIRECTORY in the .env file
$envFile = Join-Path $HOME ".config/fabric/.env"
$customPatternsDir = $null
if (Test-Path $envFile) {
    $envContent = Get-Content $envFile | Where-Object { $_.Trim() -ne '' -and $_.Trim() -notlike '#*' }
    $envHash = $envContent | ConvertFrom-StringData -Delimiter '='
    $customPatternsDir = $envHash.CUSTOM_PATTERNS_DIRECTORY
}

# Path to the patterns directory
$defaultPatternsPath = Join-Path $HOME ".config/fabric/patterns"
$patternPaths = @($defaultPatternsPath)

if (-not [string]::IsNullOrEmpty($customPatternsDir) -and (Test-Path -Path $customPatternsDir -PathType Container)) {
    $patternPaths += $customPatternsDir
}

foreach ($path in $patternPaths) {
    foreach ($patternDir in Get-ChildItem -Path $path -Directory) {
        $patternName = $patternDir.Name

        # Dynamically define a function for each pattern
        $functionDefinition = @"
function $patternName {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = `$true)]
        [string] `$InputObject,

        [Parameter(ValueFromRemainingArguments = `$true)]
        [String[]] `$patternArgs
    )

    begin {
        # Initialize an array to collect pipeline input
        `$collector = @()
    }

    process {
        # Collect pipeline input objects
        if (`$InputObject) {
            `$collector += `$InputObject
        }
    }

    end {
        # Join all pipeline input into a single string, separated by newlines
        `$pipelineContent = `$collector -join "`n"

        # If there's pipeline input, include it in the call to fabric
        if (`$pipelineContent) {
            `$pipelineContent | fabric --pattern $patternName `$patternArgs
        } else {
            # No pipeline input; just call fabric with the additional args
            fabric --pattern $patternName `$patternArgs
        }
    }
}
"@
        # Add the function to the current session
        Invoke-Expression $functionDefinition
    }
}

# Define the 'yt' function as well
function yt {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias("timestamps")]
        [switch]$t,

        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]$videoLink
    )

    begin {
        $transcriptFlag = "--transcript"
        if ($t) {
            $transcriptFlag = "--transcript-with-timestamps"
        }
    }

    process {
        if (-not $videoLink) {
            Write-Error "Usage: yt [-t | --timestamps] youtube-link"
            return
        }
    }

    end {
        if ($videoLink) {
            # Execute and allow output to flow through the pipeline
            fabric -y $videoLink $transcriptFlag
        }
    }
}

# Check if fzf command exists and set up fuzzy_fabric alias
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    function fuzzy_fabric {
        [CmdletBinding()]
        param(
            [Parameter(ValueFromRemainingArguments = $true)]
            [String[]] $RemainingArgs
        )

        $patternsRoot = Join-Path $HOME ".config/fabric/patterns"
        $fzfArgs = @(
            "--walker-root=$patternsRoot",
            "--preview", "type {}",
            "--preview-window=up:50%:wrap"
        )
        $selectedOutput = fzf $fzfArgs

        # Check fzf's exit code
        if ($LASTEXITCODE -eq 0) {
            # fzf exited successfully, meaning an item was selected.
            $selectedPath = ($selectedOutput | Out-String).Trim() # Get the first line of output if multiple items selected without --multi

            if (-not [string]::IsNullOrWhiteSpace($selectedPath)) {
                # Get the parent directory of the selected item (this should be the pattern's directory)
                $parentDir = Split-Path -Path $selectedPath -Parent

                if ($parentDir -and (Test-Path -LiteralPath $parentDir -PathType Container)) {
                    # Get the name of the parent directory (this is the pattern name)
                    $patternName = Split-Path -Path $parentDir -Leaf

                    if (-not [string]::IsNullOrWhiteSpace($patternName)) {
                        # Execute fabric with the determined pattern name and any additional arguments
                        fabric --pattern $patternName $RemainingArgs
                    }
                    else {
                        Write-Warning "Could not extract pattern name from directory '$parentDir'."
                    }
                }
                else {
                    Write-Warning "Parent directory '$parentDir' (derived from fzf selection '$selectedPath') is not valid or not found."
                }
            }
            else {
                # This case might occur if fzf exits with 0 but outputs nothing or only whitespace.
                Write-Warning "fzf exited successfully but no valid path was selected or output was empty."
            }
        }
        elseif ($LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 130) {
            # Common exit codes for user cancellation (e.g., Esc, Ctrl-C).
            # Write-Verbose "fzf selection cancelled by user (exit code $LASTEXITCODE)."
            # Silently do nothing, as is common for fzf cancellations.
        }
        else {
            # fzf failed for other reasons.
            Write-Warning "fzf command failed with exit code $LASTEXITCODE."
            # $selectedOutput might contain error messages from fzf's stderr if they were merged.
            # If fzf writes errors to stderr and it wasn't redirected, they might appear on console directly.
        }
    }
}

function fabric_pattern_summary {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [String[]] $CmdArgs
    )

    $instructions = @"
This is the directory structure of all the Fabric Patterns
I want you to examine all the system.md files and create an alphabetized list
that shows simply:

pattern_name - short and concise summary of its function

So the list might look something like this:

extract_wisdom -- Gets the most important points, quotes, etc. from a piece of text
improve_writing -- Fixes grammar and clarity issues
write_essay -- Converts writing to a simple, direct style (i.e. Paul Graham's style)
"@

    $patternsDir = Join-Path $HOME ".config/fabric/patterns"
    code_helper -ignore user.md $patternsDir 'Generate a summary of the fabric patterns' | fabric $CmdArgs $instructions
}

# Check if the file model-defs.ps1 exists in $HOME/.config/fabric and source it if it does
$modelDefsPath = Join-Path $HOME ".config/fabric/model-defs.ps1"
if (Test-Path -Path $modelDefsPath) {
    . $modelDefsPath
}
