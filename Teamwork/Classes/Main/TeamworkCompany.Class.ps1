Class TeamworkCompany {
    [int]$Id
    $FullData

    # Essentials
    [string]$Name
    [string]$Website
    [string]$Email
    [string[]]$Industry
    [string]$Phone
    [string]$Fax

    # Address
    [string]$AddressLine1
    [string]$AddressLine2
    [string]$City
    [string]$State
    [string]$Zip
    [string]$Country

    # ToJson
    [string] ToJson() {
        $returnObject = @{ 'company' = @{} }
        $returnObject.company = @{ 'name' = $this.Name }

        $jsonObject = $returnObject | ConvertTo-Json -Depth 10 -Compress
        return $jsonObject
    }

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkCompany() {
    }

    ########################################################################
    #endregion Initiators
}
