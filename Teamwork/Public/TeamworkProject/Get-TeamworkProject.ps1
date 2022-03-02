function Get-TeamworkProject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkProject:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'projects.json'
        $QueryParams.Query = $Query
        if ($Query.include) {
            $Query.include += ',customfields,customfieldprojects,projectCategories'
        } else {
            $Query.include = 'customfields,customfieldprojects,projectCategories'
        }

        # update other teamwork values if needed
        if ($Global:TeamworkServer.CustomFields.Count -eq 0) {
            $PullData = Get-TeamworkCustomField
        }

        if ($Global:TeamworkServer.Companies.Count -eq 0) {
            $PullData = Get-TeamworkCompany
        }
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.projects) {
            $New = New-TeamworkProject

            $New.Id = $entry.id
            $New.FullData = $entry

            $New.Name = $entry.name
            $New.CompanyId = $entry.companyId
            $New.CompanyName = ($Global:TeamworkServer.Companies | Where-Object { $_.Id -eq $New.CompanyId }).Name

            # Category

            $ThisCategoryId = [string]($entry.categoryId)
            if ($ThisCategoryId) {
                $New.Category = ($Response.included.projectCategories.$ThisCategoryId).name
            }
            $New.CategoryId = $ThisCategoryId

            $ReturnObject += $New
        }

        # add in custom fields
        foreach ($fieldValue in $Response.included.customfieldProjects.GetEnumerator()) {
            $ThisValue = $fieldValue.Value

            $ThisCustomFieldValue = "" | Select-Object Id, Name, Value
            $ThisCustomFieldValue.Id = $ThisValue.customfieldId
            $ThisCustomFieldValue.Value = $ThisValue.value
            $ThisCustomFieldValue.Name = ($Global:TeamworkServer.CustomField | Where-Object { $_.Id -eq $ThisCustomFieldValue.Id }).Name

            $ProjectLookup = $ReturnObject | Where-Object { $_.Id -eq $ThisValue.projectId }
            if ($ProjectLookup) {
                $ProjectLookup.CustomField += $ThisCustomFieldValue
            }
        }
    }

    END {
        $ReturnObject
    }
}