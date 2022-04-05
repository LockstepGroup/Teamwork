function New-TeamworkBudget {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-TeamworkBudget:"
    }

    PROCESS {
        $ReturnObject = [TeamworkBudget]::new()
    }

    END {
        $ReturnObject
    }
}
