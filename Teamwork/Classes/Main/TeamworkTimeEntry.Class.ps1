Class TeamworkTimeEntry {
  [int]$Id
  $FullData

  [datetime]$TimeLogged
  [int]$Minutes

  [int]$UserId
  [int]$ProjectId

  [string]$Description

  # ToJson
  [string] ToJson() {
    $thisJson = @{}

    $thisJson.time = Get-Date -Format "HH:mmm:00" -Date $this.TimeLogged
    $thisJson.date = Get-Date -Format "yyyy-MM-dd" -Date $this.TimeLogged
    $thisJson.minutes = $this.Minutes
    $thisJson.userId = $this.UserId
    $thisJson.projectId = $this.ProjectId
    $thisJson.description = $this.Description

    $returnObject = @{ 'timelog' = $thisJson }

    $jsonObject = $returnObject | ConvertTo-Json -Depth 10 -Compress
    return $jsonObject
  }

  <# "timelog": {
        "date": {},
        "description": "string",
        "hasStartTime": true,
        "hours": 0,
        "invoiceId": 0,
        "isBillable": true,
        "isUtc": true,
        "minutes": 0,
        "projectId": 0,
        "tagIds": [
          0
        ],
        "taskId": 0,
        "ticketId": 0,
        "time": {},
        "userId": 0
      } #>

  #region Initiators
  ########################################################################

  # empty initiator
  TeamworkTimeEntry() {
  }

  ########################################################################
  #endregion Initiators
}
