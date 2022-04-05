function New-TeamworkTag {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkTag:"
    }

    PROCESS {
        $ReturnObject = [TeamworkTag]::new()
    }

    END {
        $ReturnObject
    }
}
