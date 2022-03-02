function Connect-TeamworkServer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$ApiToken = $global:TeamworkApiToken,

        [Parameter(Mandatory = $false)]
        [string]$TeamworkFqdn = $global:TeamworkFqdn
    )

    BEGIN {
        $VerbosePrefix = "Connect-TeamworkServer:"
    }

    PROCESS {
        $Global:TeamworkServer = New-TeamworkServer
        $Global:TeamworkServer.ApiToken = $ApiToken
        $Global:TeamworkServer.BaseFqdn = $TeamworkFqdn

        # test connection
        try {
            $TestResponse = Invoke-TeamworkApiQuery -UriPath 'features.json'
            $Global:TeamworkServer.Connected = $true
        } catch {
            Throw $_
        }
    }

    END {
    }
}
