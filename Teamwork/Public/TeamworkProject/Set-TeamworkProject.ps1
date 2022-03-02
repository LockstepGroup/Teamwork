function Set-TeamworkProject {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "FromCustomObject", Mandatory = $True, Position = 0)]
        [TeamworkProject]$TeamworkProject
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkProject:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'projects.json'
        $QueryParams.Method = 'POST'
    }

    PROCESS {
        $QueryParams.Body = $TeamworkProject.ToJson()
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}
