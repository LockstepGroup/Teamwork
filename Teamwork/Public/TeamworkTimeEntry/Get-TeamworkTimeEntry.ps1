function Get-TeamworkTimeEntry {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 500)]
        [int]$PageSize = 500,

        [Parameter(Mandatory = $true)]
        [int64]$ProjectId
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkTimeEntry:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'projects/' + [string]$ProjectId + '/time.json'
        $Query.pagesize = $PageSize
        $QueryParams.Query = $Query
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.timelogs) {
            $New = New-TeamworkTimeEntry

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.TimeLogged = $entry.timeLogged
            $New.Minutes = $entry.minutes

            $New.UserId = $entry.userId
            $New.ProjectId = $entry.projectId

            $New.Description = $entry.description

            $ReturnObject += $New
        }
    }

    END {
        $ReturnObject
    }
}