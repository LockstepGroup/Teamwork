function Set-TeamworkCompany {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ParameterSetName = "TeamworkCompany", Mandatory = $True, Position = 0)]
        [TeamworkCompany]$TeamworkCompany
    )

    BEGIN {
        $VerbosePrefix = "Set-TeamworkCompany:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'companies.json'
        $QueryParams.Method = 'POST'

        if ($TeamworkServer.Companies.count -eq 0) {
            $TeamworkCompanes = Get-TeamworkCompany
        }
    }

    PROCESS {
        $QueryParams.Body = $TeamworkCompany.ToJson()
        $Response = Invoke-TeamworkApiQuery @QueryParams

        $New = New-TeamworkCompany

        $New.Id = $Response.company.id
        $New.FullData = $Response.company

        # Essentials
        $New.Name = $Response.company.name
        $New.Website = $Response.company.website
        $New.Email = $Response.company.emailOne
        $New.Industry = $Response.company.industryId #TODO need to resolve this
        $New.Phone = $Response.company.phone
        $New.Fax = $Response.company.fax

        # Address
        $New.AddressLine1 = $Response.company.addressOne
        $New.AddressLine2 = $Response.company.addressTwo
        $New.City = $Response.company.city
        $New.State = $Response.company.state
        $New.Zip = $Response.company.zip
        $New.Country = $Response.company.contryCode

        $ReturnObject += $New
    }

    END {
        $TeamworkServer.Companies += $ReturnObject
        $ReturnObject
    }
}