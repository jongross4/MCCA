using module "..\MCCA.psm1"

class RM102 : MCCACheck {
    <#
    

    #>

    RM102() {
        $this.Control = "RM-102"
        $this.ParentArea = "Microsoft Information Governance"
        $this.Area = "Records Management"
        $this.Name = "Automatically Apply Record Labels"
        $this.PassText = "Your organization is using auto apply record label policies"
        $this.FailRecommendation = "Your organization should use auto apply record label policies"
        $this.Importance = "Your organization should use records management to manage regulatory, legal, and business-critical records across corporate data. You can automatically apply record labels to content that matches certain conditions."
        $this.ExpandResults = $True
        $this.CheckType = [CheckType]::ObjectPropertyValue
        $this.ObjectType = "Policy Name"
        $this.ItemName = "Labels"
        $this.DataType = "Remarks"
        $this.Links = @{
            "Overview of Records"              = "https://docs.microsoft.com/en-us/microsoft-365/compliance/records?view=o365-worldwide"
            "Compliance Center - Records Management"                       = "https://compliance.microsoft.com/recordsmanagement?viewid=fileplan"
            "Records management in Microsoft 365" = "https://docs.microsoft.com/en-us/microsoft-365/compliance/records-management?view=o365-worldwide"
            "Compliance Manager - RM Actions" = "https://compliance.microsoft.com/compliancescore?filter=%7B%22Solution%22:%5B%22Records%20management%22%5D,%22Status%22:%5B%22None%22,%22NotAssessed%22,%22Passed%22,%22FailedLowRisk%22,%22FailedMediumRisk%22,%22FailedHighRisk%22,%22ToBeDetermined%22,%22CouldNotBeDetermined%22,%22PartiallyTested%22,%22Select%22%5D%7D&viewid=ImprovementActions"
        }
    
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config) {               
        if (($Config["GetRetentionComplianceRule"] -eq "Error") -or ($Config["GetRetentionCompliancePolicy"] -eq "Error") -or ($Config["GetComplianceTag"] -eq "Error")) {
            $this.Completed = $false
        }
        else {
            $UtilityFiles = Get-ChildItem "$PSScriptRoot\..\Utilities"

            ForEach ($UtilityFile in $UtilityFiles) {
        
                . $UtilityFile.FullName
                
            }
            
            $LogFile = $this.LogFile
            $Mode= "Auto"
            $ConfigObjectList = Get-RMPolicyValidation -LogFile $LogFile -Mode $Mode

            Foreach ($ConfigObject in $ConfigObjectList) {
                $this.AddConfig($ConfigObject)
            }

            
        
            $hasRemediation = $this.Config | Where-Object { $_.RemediationAction -ne ''}
            if ($($hasremediation.count) -gt 0)
            {
                $this.MCCARemediationInfo = New-Object -TypeName MCCARemediationInfo -Property @{
                    RemediationAvailable = $True
                    RemediationText      = "You need to connect to Security & Compliance Center PowerShell to execute the below commands. Please follow steps defined in <a href = 'https://docs.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps'> Connect to Security & Compliance Center PowerShell</a>."
                }
            }
            $this.Completed = $True
        
        }
        
    }

}

