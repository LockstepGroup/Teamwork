function Set-TeamworkTimeEntry {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "FromCustomObject", Mandatory = $True, Position = 0)]
        [TeamworkTimeEntry]$TeamworkTimeEntry
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkTimeEntry:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.Method = 'POST'
    }

    PROCESS {
        $QueryParams.UriPath = 'projects/' + [string]($TeamworkTimeEntry.ProjectId) + '/time.json'
        $QueryParams.Body = $TeamworkTimeEntry.ToJson()
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}
