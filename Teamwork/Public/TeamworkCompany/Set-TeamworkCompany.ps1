function Set-TeamworkCompany {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "TeamworkCompany", Mandatory = $True, Position = 0)]
        [TeamworkCompany]$TeamworkCompany
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkCompany:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'companies.json'
        $QueryParams.Method = 'POST'
    }

    PROCESS {
        $QueryParams.Body = $TeamworkCompany.ToJson()
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}