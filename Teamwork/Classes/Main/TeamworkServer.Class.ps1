Class TeamworkServer {
    [string]$BaseFqdn
    [string]$UriPath
    [string]$ApiToken

    #region storedTeamworkProperties
    ########################################################################

    [array]$CustomFields
    [array]$Companies
    [array]$ProjectCategories
    [array]$People
    [array]$Tags

    ########################################################################
    #endregion storedTeamworkProperties

    #region Tracking
    ########################################################################

    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$QueryHistory
    [array]$QueryParamHistory
    $LastError
    hidden $LastResult
    hidden $LastRawResult
    hidden $RateLimiter = [System.Collections.ArrayList]@()

    ########################################################################
    #endregion Tracking

    # getApiUrl
    [String] getApiUrl([string]$method) {
        if ($this.BaseFqdn) {
            $url = "https://" + $this.BaseFqdn + $this.getApiVersionString($method) + $this.UriPath
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

    # getApiVersionString
    [string] getApiVersionString ([string]$method) {
        $ApiVersionMap = @{}
        $ApiVersionMap.'projects.json' = @{}
        $ApiVersionMap.'projects.json'.'POST' = '/'
        $ApiVersionMap.'projects.json'.'PUT' = '/'

        $ApiVersionMap.'projectCategories.json' = @{}
        $ApiVersionMap.'projectCategories.json'.'GET' = '/'

        $CurrentUriPath = $this.UriPath # -replace '\d+', ''

        $thisVersion = $ApiVersionMap.$CurrentUriPath.$method

        if (-not $thisVersion) {
            switch -Regex ($CurrentUriPath) {
                'projects/\d+/people.json' {
                    switch ($method) {
                        'POST' {
                            $thisVersion = '/'
                        }
                    }
                }
                'projects/\d+/complete.json' {
                    switch ($method) {
                        'PUT' {
                            $thisVersion = '/'
                        }
                    }
                }
                'projects\/\d+\.json' {
                    switch ($method) {
                        'PUT' {
                            $thisVersion = '/'
                        }
                    }
                }
            }
        }

        if (-not $thisVersion) {
            $thisVersion = '/projects/api/v3/'
        }

        return $thisVersion
    }

    #region apiVersion
    ########################################################################



    ########################################################################
    #endregion apiVersion

    #region invokeApiQuery
    ########################################################################

    [psobject] invokeApiQuery([hashtable]$queryString, [string]$method, [string]$body) {
        # Wrike uses the query string as a body attribute, keeping this function as is for now and just using an empty querystring
        $url = $this.getApiUrl($method)

        # Populate Query/Url History
        $this.QueryHistory += $queryString

        $QueryParams = @{}
        $rawResult = $null
        # try query
        try {
            $QueryParams.Uri = $url
            switch ($method) {
                'PUT' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                    if ('' -ne $body) {
                        $QueryParams.Body = $body
                    }
                }
                'POST' {
                    $QueryParams.Body = $body
                    $QueryParams.ContentType = 'application/json'
                }
                'PATCH' {
                    $QueryParams.Body = $body
                    $QueryParams.ContentType = 'application/json'
                }
                'GET' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                }
                'DELETE' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                }
            }
            $this.UrlHistory += $QueryParams.Uri
            $QueryParams.Method = $method
            $QueryParams.Headers = @{
                'Authorization' = "Basic $($this.encodeAuthorizationHeader())"
            }

            $this.QueryParamHistory += $QueryParams

            $TimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
            $this.RateLimiter += $TimeStamp
            if ($this.RateLimiter.Count -gt 150) {
                $TimeDifference = ($TimeStamp - $this.RateLimiter[-150])
                $TimeDifferenceInSeconds = $TimeDifference / 1000
                if ($TimeDifference -lt 60000) {
                    Write-Warning "Rate Limit hit, waiting $TimeDifferenceInSeconds seconds"
                    Start-Sleep -Milliseconds $TimeDifference
                }
            }

            $rawResult = Invoke-RestMethod @QueryParams
        } catch [System.Net.Http.HttpRequestException] {
            $RetryCount = 0
            do {
                Start-Sleep -Seconds 3
                Write-Warning "Generic connection error, waiting 3 seconds and trying again"
                $rawResult = Invoke-RestMethod @QueryParams
                $RetryCount++
            } while ($RetryCount -lt 3)
            if ($null -eq $rawResult) {
                Throw "Retries failed, check your connection"
            }
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
