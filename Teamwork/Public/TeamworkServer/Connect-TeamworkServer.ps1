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
        $ReturnObject = New-TeamworkServer
        $ReturnObject.ApiToken = $ApiToken
        $ReturnObject.BaseFqdn = $TeamworkFqdn

        #TODO: need to add a test connection
    }

    END {
        $Global:TeamworkServer = $ReturnObject
    }
}
