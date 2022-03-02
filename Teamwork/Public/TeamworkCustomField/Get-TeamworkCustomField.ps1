function Get-TeamworkCustomField {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkCustomField:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'customfields.json'
        $QueryParams.Query = $Query
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.customfields) {
            $New = New-TeamworkCustomField

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.Name = $entry.name
            $New.Description = $entry.description
            $New.Type = $entry.type
            $New.Choices = $entry.options.choices

            switch ($entry.entity) {
                'project' {
                    $new.IsProjectField = $true
                }
                'task' {
                    $new.IsTaskField = $true
                }
            }

            $ReturnObject += $New
        }
    }

    END {
        $Global:TeamworkServer.CustomFields = $ReturnObject
        $ReturnObject
    }
}
