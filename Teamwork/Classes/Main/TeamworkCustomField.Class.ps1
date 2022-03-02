Class TeamworkCustomField {
    [int]$Id
    $FullData

    [string]$Name
    [string]$Description
    [string]$Type
    [array]$Choices

    [bool]$IsTaskField
    [bool]$IsProjectField

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkCustomField() {
    }

    ########################################################################
    #endregion Initiators
}
