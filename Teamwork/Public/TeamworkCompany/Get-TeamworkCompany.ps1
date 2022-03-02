function Get-TeamworkCompany {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Get-TeamworkCompany:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'companies.json'
        $QueryParams.Query = $Query
    }

    PROCESS {
        $Response = Invoke-TeamworkApiQuery @QueryParams

        foreach ($entry in $Response.companies) {
            $New = New-TeamworkCompany

            $New.Id = $entry.id
            $New.FullData = $entry

            # Essentials
            $New.Name = $entry.name
            $New.Website = $entry.website
            $New.Email = $entry.emailOne
            $New.Industry = $entry.industryId #TODO need to resolve this
            $New.Phone = $entry.phone
            $New.Fax = $entry.fax

            # Address
            $New.AddressLine1 = $entry.addressOne
            $New.AddressLine2 = $entry.addressTwo
            $New.City = $entry.city
            $New.State = $entry.state
            $New.Zip = $entry.zip
            $New.Country = $entry.contryCode

            $ReturnObject += $New
        }
    }

    END {
        $Global:TeamworkServer.Companies = $ReturnObject
        return $ReturnObject
    }
}
