function Get-TeamworkTag {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkTag:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'tags.json'
        $QueryParams.Query = $Query
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.tags) {
            $New = New-TeamworkTag

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.Name = $entry.name
            $New.ProjectId = $entry.projectId
            $New.Color = $entry.color

            $ReturnObject += $New
        }
    }

    END {
        $Global:TeamworkServer.Tags = $ReturnObject
        $ReturnObject
    }
}
