####################################################
# HDInsight Lab                                    #
#                                                  #
# Instructions:                                    #
#     Replace the value for $clusterName           #
#     with your own cluster name                   #
####################################################

$clusterName = "hdi2016"

####################################################
# Do not change anything below this line           #
####################################################
$creds=Get-Credential

$sub = Get-AzureRmSubscription -ErrorAction SilentlyContinue
if(-not($sub))
{
    Add-AzureRmAccount
}

$queryString = "SELECT IsDefault, YearsOfEmployment, AVG(HouseAge) AS HouseAge, AVG(CCDebt) AS CCDebt FROM hdinsightlab.mortgagedefaults GROUP BY IsDefault, YearsOfEmployment;"

$hiveJobDefinition = New-AzureRmHDInsightHiveJobDefinition -Query $queryString 

Write-Host "Starting Hive job..." -ForegroundColor Green

$hiveJob = Start-AzureRmHDInsightJob -ClusterName $clusterName -JobDefinition $hiveJobDefinition -ClusterCredential $creds

Write-Host "Executing Hive job..." -ForegroundColor Green
Wait-AzureRmHDInsightJob -ClusterName $clusterName -JobId $hiveJob.JobId -ClusterCredential $creds

$clusterInfo = Get-AzureRmHDInsightCluster -ClusterName $clusterName
$resourceGroup = $clusterInfo.ResourceGroup
$storageAccountName=$clusterInfo.DefaultStorageAccount.split('.')[0]
$container=$clusterInfo.DefaultStorageContainer
$storageAccountKey=Get-AzureRmStorageAccountKey `
    -Name $storageAccountName `
    -ResourceGroupName $resourceGroup `
    | %{ $_.Key1 }

Write-Host "Displaying output..." -ForegroundColor Green
Get-AzureRmHDInsightJobOutput `
    -Clustername $clusterName `
    -JobId $hiveJob.JobId `
    -DefaultContainer $container `
    -DefaultStorageAccountName $storageAccountName `
    -DefaultStorageAccountKey $storageAccountKey `
    -HttpCredential $creds