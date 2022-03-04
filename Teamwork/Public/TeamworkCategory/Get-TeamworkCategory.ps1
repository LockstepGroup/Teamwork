function Get-TeamworkCategory {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkCategory:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'projectCategories.json'
        $QueryParams.Query = $Query
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.categories) {
            $New = New-TeamworkCategory

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.Name = $entry.name

            $ReturnObject += $New
        }
    }

    END {
        $Global:TeamworkServer.ProjectCategories = $ReturnObject
        $ReturnObject
    }
}
