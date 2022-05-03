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
    }

    PROCESS {
        if (-not $Global:TeamworkServer) {
            Throw "$VerbosePrefix no active connection to Teamwork, please use Connect-TeamworkServer to get started."
        } else {
            $Global:TeamworkServer.UriPath = $UriPath

            # first result
            $Query.page = 1
            $thisResult = $Global:TeamworkServer.invokeApiQuery($Query, $Method, $Body)
            $ReturnObject = $thisResult

            # pull these so we can add the correct values no matter what the call is in the while loop
            $ResponseProperties = ($thisResult | Get-Member -Type NoteProperty).Name
            $ResponseProperties = $ResponseProperties | Where-Object { $_ -ne 'meta' }

            # process all pages if they exist
            if ($thisResult.meta.page.hasMore) {
                do {
                    $Query.page++
                    $thisResult = $Global:TeamworkServer.invokeApiQuery($Query, $Method, $Body)
                    foreach ($property in $ResponseProperties) {
                        Write-Warning "$VerbosePrefix adding $property"
                        if ($property -eq 'included') {
                            if (-not $Query.include) {
                                continue
                            }
                        }
                        $ReturnObject.$property += $thisResult.$property
                    }
                } while ($thisResult.meta.page.hasMore)
            }
        }
    }

    END {
        $ReturnObject
    }
}