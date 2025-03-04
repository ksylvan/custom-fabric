# Path to the patterns directory
$patternsPath = Join-Path $HOME ".config/fabric/patterns"
foreach ($patternDir in Get-ChildItem -Path $patternsPath -Directory) {
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

# Check if the file model-defs.ps1 exists in $HOME/.config/fabric and source it if it does
$modelDefsPath = Join-Path $HOME ".config/fabric/model-defs.ps1"
if (Test-Path -Path $modelDefsPath) {
    . $modelDefsPath
}
