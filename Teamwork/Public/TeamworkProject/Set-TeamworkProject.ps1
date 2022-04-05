function Set-TeamworkProject {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "FromCustomObject", Mandatory = $True, Position = 0)]
        [TeamworkProject]$TeamworkProject,

        [Parameter(Mandatory = $false)]
        [switch]$Complete
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkProject:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'projects.json'
        $QueryParams.Method = 'POST'
    }

    PROCESS {
        if ($TeamworkProject.Id -gt 0) {
            $QueryParams.Method = 'PUT'
        }
        if ($Complete) {
            $QueryParams.UriPath = "projects/" + $TeamworkProject.id + "/complete.json"
        }
        $QueryParams.Body = $TeamworkProject.ToJson()
        try {
            $Response = Invoke-TeamworkApiQuery @QueryParams
        } catch {
            switch -Regex ($_.Exception.Message) {
                'Project name is taken already' {
                    Throw "$VerbosePrefix Project name is already taken: $($TeamworkProject.Name)"
                }
                default {
                    Throw $_
                }
            }
        }
        $ReturnObject += $Response
    }

    END {
        $ReturnObject
    }
}
