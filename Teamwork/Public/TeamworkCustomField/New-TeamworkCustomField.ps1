function New-TeamworkCustomField {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkCustomField:"
    }

    PROCESS {
        $ReturnObject = [TeamworkCustomField]::new()
    }

    END {
        $ReturnObject
    }
}
