function New-TeamworkProject {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkProject:"
    }

    PROCESS {
        $ReturnObject = [TeamworkProject]::new()
    }

    END {
        $ReturnObject
    }
}
