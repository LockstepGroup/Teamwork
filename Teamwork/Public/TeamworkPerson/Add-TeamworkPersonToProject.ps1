function Add-TeamworkPersonToProject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [TeamworkProject]$TeamworkProject,

        [Parameter(Mandatory = $True)]
        [int[]]$PersonId
    )

    BEGIN {
        $VerbosePrefix = "Add-TeamworkPersonToProject:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.Method = 'POST'
        $QueryParams.Body = @{
            'add' = @{
                'userIdList' = ($PersonId -join ',')
            }
        }
        $QueryParams.Body = $QueryParams.Body | ConvertTo-Json
    }

    PROCESS {
        $QueryParams.UriPath = "projects/$($TeamworkProject.Id)/people.json"
        $Response = Invoke-TeamworkApiQuery @QueryParams
        $ReturnObject += @{
            'ProjectId' = $TeamworkProject.Id
            'Details'   = $Response.Details
        }
    }

    END {
        $ReturnObject
    }
}