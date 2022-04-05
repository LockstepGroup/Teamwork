function New-TeamworkPerson {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkPerson:"
    }

    PROCESS {
        $ReturnObject = [TeamworkPerson]::new()
    }

    END {
        $ReturnObject
    }
}
