function New-TeamworkServer {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkServer:"
    }

    PROCESS {
        $ReturnObject = [TeamworkServer]::new()
    }

    END {
        $ReturnObject
    }
}
