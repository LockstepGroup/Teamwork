Class TeamworkBudget {
    [int64]$Id
    $FullData

    [int64]$ProjectId
    [string]$Type
    [int64]$CapacityUsed
    [int64]$Capacity
    [string]$Status = 'ACTIVE'
    [string]$TimeLogType = 'ALL'
    [datetime]$StartDate

    # ToJson
    [string] ToJson() {
        $thisJson = @{}

        $thisJson.projectId = $this.ProjectId
        $thisJson.type = $this.Type
        $thisJson.capacity = $this.Capacity
        $thisJson.status = $this.Status
        $thisJson.timelogType = $this.TimeLogType
        $thisJson.startDateTime = Get-date -Date $this.StartDate -Format "yyyy-MM-ddTHH:mmm:00Z"

        $returnObject = @{ 'budget' = $thisJson }

        $jsonObject = $returnObject | ConvertTo-Json -Depth 10 -Compress
        return $jsonObject
    }

    #region Initiators
    ########################################################################

    # empty initiator
    TeamworkBudget() {
    }

    ########################################################################
    #endregion Initiators
}
