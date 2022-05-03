function Invoke-TeamworkApiQuery {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$UriPath,

        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $false)]
        [string]$Body = '',

        [Parameter(Mandatory = $false)]
        [string]$Method = 'GET'
    )

    BEGIN {
        $VerbosePrefix = "Invoke-TeamworkApiQuery:"
        $ReturnObject = @()
    }

    PROCESS {
        if (-not $Global:TeamworkServer) {
            Throw "$VerbosePrefix no active connection to Teamwork, please use Connect-TeamworkServer to get started."
        } else {
            $Global:TeamworkServer.UriPath = $UriPath

            # first result
            $Query.page = 1
            $thisResult = $Global:TeamworkServer.invokeApiQuery($Query, $Method, $Body)
            $ReturnObject += $thisResult

            # process all pages if they exist
            do {
                $Query.page++
                $thisResult = $Global:TeamworkServer.invokeApiQuery($Query, $Method, $Body)
                $ReturnObject += $thisResult
            } while ($thisResult.meta.page.hasMore)
        }
    }

    END {
        $ReturnObject
    }
}