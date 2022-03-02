function New-TeamworkCompany {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkCompany:"
    }

    PROCESS {
        $ReturnObject = [TeamworkCompany]::new()
    }

    END {
        $ReturnObject
    }
}
