Class TeamworkProject {
    [int]$Id
    $FullData

    [string]$Name
    [string]$CompanyName
    [string]$CompanyId

    [int64]$CategoryId
    [string]$Category

    # generic custom fields
    [array]$CustomField

    [int64[]]$TagId
    [string[]]$Tag

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
