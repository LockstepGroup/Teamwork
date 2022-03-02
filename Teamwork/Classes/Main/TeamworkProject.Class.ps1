Class TeamworkProject {
    [int]$Id
    $FullData

    [string]$Name
    [string]$CompanyName
    [string]$CompanyId

    [int64[]]$CategoryId
    [string[]]$Category

    # generic custom fields
    [array]$CustomField

    [int64[]]$TagId
    [string[]]$Tag

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkProject() {
    }

    ########################################################################
    #endregion Initiators
}
