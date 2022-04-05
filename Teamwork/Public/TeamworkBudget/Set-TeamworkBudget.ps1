function Set-TeamworkBudget {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "FromCustomObject", Mandatory = $True, Position = 0)]
        [TeamworkBudget]$TeamworkBudget
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkBudget:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'budgets.json'
        $QueryParams.Method = 'POST'

    }

    PROCESS {
        $QueryParams.Body = $TeamworkBudget.ToJson()
        if ($TeamworkBudget.Id -gt 0) {
            $QueryParams.UriPath = 'budgets/' + [string]$TeamworkBudget.Id + '.json'
            $QueryParams.Method = 'PATCH'
        }
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}
