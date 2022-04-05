Class TeamworkProject {
    [int]$Id
    $FullData

    [string]$Name
    [string]$CompanyName
    [string]$CompanyId

    [int64]$CategoryId
    [string]$Category

    [string]$Status
    [string]$SubStatus

    # generic custom fields
    [array]$CustomField

    # tags
    [int64[]]$TagId
    [string[]]$Tag

    # dates
    [datetime]$StartDate
    [datetime]$EndDate

    # people
    [int64[]]$PeopleId
    [array]$People
    [int64]$OwnerId

    # ToJson
    [string] ToJson() {
        $thisProject = @{}
        $thisProject.name = $this.Name
        $thisProject.companyId = $this.CompanyId
        $thisProject.'category-id' = $this.CategoryId

        # CustomFields
        if ($this.CustomField.Count -gt 0) {
            $thisProject.customFields = @()
            foreach ($field in $this.CustomField) {
                $thisField = @{}
                $thisField.customFieldId = $field.Id
                $thisField.value = $field.Value
                $thisProject.customFields += $thisField
            }
        }

        # Dates
        if ($this.StartDate -ne (Get-Date -Date 1/1/0001)) {
            $thisProject.'start-date' = Get-Date -Date $this.StartDate -Format "yyyyMMdd"
        }

        if ($this.EndDate -ne (Get-Date -Date 1/1/0001)) {
            $thisProject.'end-date' = Get-Date -Date $this.EndDate -Format "yyyyMMdd"
        }

        # People
        if ($this.PeopleId) {
            $thisProject.people = $this.PeopleId -join ','
        }

        # Owner
        if ($this.OwnerId) {
            $thisProject.projectOwnerId = $this.OwnerId
        }

        # Tags
        if ($this.TagId.Count -gt 0) {
            $thisProject.tagIds = $this.TagId -join ','
        }

        $returnObject = @{ 'project' = $thisProject }

        $jsonObject = $returnObject | ConvertTo-Json -Depth 10 -Compress
        return $jsonObject
    }

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkProject() {
    }

    ########################################################################
    #endregion Initiators
}
