using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Connect-AzAccount -Identity

$resourceGroupsToTag = @()
$rgs = Get-AzResourceGroup

$expirestag = "expires"
foreach ($r in $rgs) {
    $tags = Get-AzTag -ResourceID $r.ResourceID
    try {
        if (-Not $tags.Properties.TagsProperty.ContainsKey($expirestag)) {
            $resourceGroupsToTag += $r.ResourceGroupName
        }
    }
    Catch {
        Write-Host "error " + $r.ResourceGroupName
    }
}

$body = $resourceGroupsToTag

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})