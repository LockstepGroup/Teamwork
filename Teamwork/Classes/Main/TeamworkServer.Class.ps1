Class TeamworkServer {
    [string]$BaseFqdn
    [string]$UriPath
    [string]$ApiToken

    #region storedTeamworkProperties
    ########################################################################

    [array]$CustomFields
    [array]$Companies

    ########################################################################
    #endregion storedTeamworkProperties

    #region Tracking
    ########################################################################

    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$QueryHistory
    $LastError
    $LastResult
    $LastRawResult

    ########################################################################
    #endregion Tracking

    # getApiUrl
    [String] getApiUrl() {
        if ($this.BaseFqdn) {
            $url = "https://" + $this.BaseFqdn + '/projects/api/v3/' + $this.UriPath
            return $url
        } else {
            return $null
        }
    }

    # createQueryString
    [string] createQueryString ([hashtable]$hashTable) {
        $QueryString = [System.Web.httputility]::ParseQueryString("")

        foreach ($Pair in $hashTable.GetEnumerator()) {
            $QueryString[$($Pair.Name)] = $($Pair.Value)
        }

        return ("?" + $QueryString.ToString())
    }

    # processQueryResult
    [psobject] processQueryResult ($unprocessedResult) {
        if ($unprocessedResult.GetType().Name -eq 'String') {
            $processedResult = $unprocessedResult | ConvertFrom-Json -AsHashtable
        } else {
            $processedResult = $unprocessedResult
        }
        return $processedResult
    }

    # encodeAuthorizationHeader
    [string] encodeAuthorizationHeader () {
        $plainTextHeader = $this.ApiToken + ':x' # password can be any character
        $encodedHeader = [System.Text.Encoding]::UTF8.GetBytes($plainTextHeader)
        $base64Header = [System.Convert]::ToBase64String($encodedHeader)
        return $base64Header
    }

    #region invokeApiQuery
    ########################################################################

    [psobject] invokeApiQuery([hashtable]$queryString, [string]$method, [string]$body) {

        # Wrike uses the query string as a body attribute, keeping this function as is for now and just using an empty querystring
        $url = $this.getApiUrl()

        # Populate Query/Url History
        $this.QueryHistory += $queryString

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $url
            switch ($method) {
                'PUT' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                }
                'POST' {
                    $QueryParams.Body = $body
                }
                'GET' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                }
            }
            $this.UrlHistory += $QueryParams.Uri
            $QueryParams.Method = $method
            $QueryParams.Headers = @{
                'Authorization' = "Basic $($this.encodeAuthorizationHeader())"
            }

            $rawResult = Invoke-RestMethod @QueryParams
        } catch {
            Throw $_
        }

        $this.RawQueryResultHistory += $rawResult
        $this.LastRawResult = $rawResult

        $proccessedResult = $this.processQueryResult($rawResult)
        $this.LastResult = $proccessedResult

        return $proccessedResult
    }

    # with just a querystring
    [psobject] invokeApiQuery([hashtable]$queryString) {
        return $this.invokeApiQuery($queryString, 'GET', '')
    }

    # with just a method
    [psobject] invokeApiQuery([string]$method) {
        return $this.invokeApiQuery(@{}, $method, '')
    }

    # with no method or querystring specified
    [psobject] invokeApiQuery() {
        return $this.invokeApiQuery(@{}, 'GET', '')
    }

    ########################################################################
    #endregion invokeApiQuery

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkServer() {
    }

    ########################################################################
    #endregion Initiators
}
