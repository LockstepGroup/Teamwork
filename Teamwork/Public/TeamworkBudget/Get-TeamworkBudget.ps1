function Get-TeamworkBudget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'TeamworkBudget')]
        [TeamworkProject]$TeamworkProject,

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'Id')]
        [int]$Id
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkBudget:"
        $ReturnObject = @()

        $QueryParams = @{}
        if ($Id) {
            $QueryParams.UriPath = 'budgets/' + [string]$Id + '.json'
        } else {
            $QueryParams.UriPath = 'budgets.json'
            $QueryParams.Query = $Query
        }
    }

    PROCESS {
        if ($TeamworkProject) {
            $QueryParams.Query.projectIds = $TeamworkProject.Id
        }

        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.budgets) {
            $New = New-TeamworkBudget

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.ProjectId = $entry.projectId
            $New.Type = $entry.type
            $New.CapacityUsed = $entry.capacityUsed
            $New.Capacity = $entry.capacity
            $New.StartDate = $entry.startDateTime

            $ReturnObject += $New
        }
    }

    END {
        $ReturnObject
    }
}
