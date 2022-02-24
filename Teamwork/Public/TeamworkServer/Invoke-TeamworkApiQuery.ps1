function Invoke-TeamworkApiQuery {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$UriPath,

        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $false)]
        [string]$Method = 'GET'
    )

    BEGIN {
        $VerbosePrefix = "Invoke-TeamworkApiQuery:"
    }

    PROCESS {
        if (-not $Global:TeamworkServer) {
            Throw "$VerbosePrefix no active connection to Wrike, please use Connect-TeamworkApiQuery to get started."
        } else {
            $Global:TeamworkServer.UriPath = $UriPath
            $ReturnObject = $Global:TeamworkServer.invokeApiQuery($Query, $Method)
        }
    }

    END {
        $ReturnObject
    }
}