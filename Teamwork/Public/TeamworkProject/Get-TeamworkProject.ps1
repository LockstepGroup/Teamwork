function Get-TeamworkProject {
    [CmdletBinding(DefaultParameterSetName = 'NoProjectId')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'NoProjectId')]
        [hashtable]$Query = @{},

        [Parameter(Mandatory = $false, ParameterSetName = 'NoProjectId')]
        [int]$PageSize = 500,

        [Parameter(Mandatory = $true, ParameterSetName = 'ProjectId')]
        [int64]$ProjectId,

        [Parameter(Mandatory = $false, ParameterSetName = 'NoProjectId')]
        [ValidateSet("Active", "Current", "Late", "Upcoming", "Completed", "Archived")]
        [string]$Status
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkProject:"
        $ReturnObject = @()

        $QueryParams = @{}
        if ($ProjectId) {
            $QueryParams.UriPath = 'projects/' + [string]$ProjectId + '.json'
        } else {
            $QueryParams.UriPath = 'projects.json'
        }

        if ($Query.include) {
            $Query.include += ',customfields,customfieldprojects,projectCategories'
        } else {
            $Query.include = 'customfields,customfieldprojects,projectCategories'
        }

        if ($Status) {
            $Query.projectStatuses = $Status
        }

        $Query.pagesize = $PageSize
        $QueryParams.Query = $Query

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

        if ($Response.project) {
            $ResponseLoop = $Response.project
        } else {
            $ResponseLoop = $Response.projects
        }

        foreach ($entry in $ResponseLoop) {
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