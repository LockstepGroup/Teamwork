function Remove-TeamworkTimeEntry {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "FromCustomObject", Mandatory = $True, Position = 0)]
        [TeamworkTimeEntry]$TeamworkTimeEntry
    )

    BEGIN {
        $VerbosePrefix = "Remove-TeamworkTimeEntry:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.Method = 'DELETE'
    }

    PROCESS {
        $QueryParams.UriPath = 'time/' + $TeamworkTimeEntry.Id + '.json'
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}
