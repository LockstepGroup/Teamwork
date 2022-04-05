function New-TeamworkTimeEntry {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkTimeEntry:"
    }

    PROCESS {
        $ReturnObject = [TeamworkTimeEntry]::new()
    }

    END {
        $ReturnObject
    }
}
