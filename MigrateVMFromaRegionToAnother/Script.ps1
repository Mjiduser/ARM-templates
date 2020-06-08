Select-AzureRmSubscription 'SourceSubscription'

### Source VHD - authenticated container ###
$srcUri = "https://sourcestorageaccount.blob.core.windows.net/vhds/nameoffile.vhd" 

### Source Storage Account ###
$srcStorageAccount = "sourcestorageaccount"
$srcStorageKey = "sourcestorageaccountkey=="

### Create the source storage account context ### 
$srcContext = New-AzureStorageContext  –StorageAccountName $srcStorageAccount `
                                        -StorageAccountKey $srcStorageKey

# Target Storage Account
Select-AzureRmSubscription 'DestinationSubscription'

### Target Storage Account ###
$destStorageAccount = "destinationstorageaccount"
$destStorageKey = "destinationstorageaccountkey=="


### Create the destination storage account context ### 
$destContext = New-AzureStorageContext  –StorageAccountName $destStorageAccount `
                                        -StorageAccountKey $destStorageKey  

### Destination Container Name ### 
$containerName = "copiedvhds"

### Create the container on the destination ### 
New-AzureStorageContainer -Name $containerName -Context $destContext 

### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob "destinationblob.vhd" `
                                    -DestContext $destContext


### Loop until complete ###                                    
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState 
  Start-Sleep 300
  ### Print out status ###
  $status
}
