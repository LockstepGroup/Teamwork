function New-TeamworkCategory {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkCategory:"
    }

    PROCESS {
        $ReturnObject = [TeamworkCategory]::new()
    }

    END {
        $ReturnObject
    }
}
