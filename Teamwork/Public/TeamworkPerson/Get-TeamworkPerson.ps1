function Get-TeamworkPerson {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Query')]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 500,

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'TeamworkProject')]
        [TeamworkProject]$TeamworkProject
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkPerson:"
        $ReturnObject = @()

        $Query = @{}
        $Query.pagesize = $PageSize

        $QueryParams = @{}
        $QueryParams.UriPath = 'people.json'
        $QueryParams.Query = $Query
    }

    PROCESS {
        if ($TeamworkProject) {
            $QueryParams.UriPath = 'projects/' + $TeamworkProject.Id + '/people.json'
            $QueryParams.Remove('Query')
        }
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.people) {
            $New = New-TeamworkPerson

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.FirstName = $entry.firstName
            $New.LastName = $entry.lastName
            $New.Email = $entry.email

            $ReturnObject += $New
        }
    }

    END {
        if ($PSCmdlet.ParameterSetName -eq 'Query') {
            $Global:TeamworkServer.People = $ReturnObject
        }

        $ReturnObject
    }
}