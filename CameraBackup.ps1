# Global Variables which need to be declared
$CameraSerialNumber = 'CA0DSAS003AD08C'
$PhotosFolder = 'H:\PhotosBackup\SonyA5100\'

# Log file location
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$logFilePath = $ScriptDir+'Logs\log.txt'

# First Idenitfy if the camera is connected
$USBDevices = get-disk | where bustype -eq 'usb'

$friendlyDeviceName = $USBDevices.FriendlyName
$serialNumberDevice = $USBDevices.SerialNumber


# Check each USB device is the required camera device 
ForEach ($items in $USBDevices){
if($items.SerialNumber -eq $CameraSerialNumber)
{
[bool] $CameraIsConnected = $true}
else{ $CameraIsConnected = $false } 
}

# Using the CameraIsConnected flag to get the path of the camera
if($CameraIsConnected -eq $true){

    $sh = New-Object -ComObject "Shell.Application"
    $USBPath = $sh.Namespace(0).Items() | ? {$_.Type -eq "USB Drive"}
    $CameraPath = $USBPath.Path

    # Camera storage may have partitions so we have to use pass the index for the array
    # Might need to be updated if the camera folder path has different values in the array
    $CameraPath = $CameraPath[0] + '\DCIM\100MSDCF'


# Get all image files in the CameraPath folder
$cameraFiles = Get-ChildItem -Path $CameraPath

# Lets find out which unique month the photos were taken on
$months = $files.LastWriteTime.Month | select -Unique  #Output is an array


ForEach($file in $cameraFiles){
    
    # REquired information to creating a desination folder
    $monthNumber = $file.LastWriteTime.Month
    $year = $file.LastWriteTime.Year
    $MonthText = (Get-Culture).DateTimeFormat.GetMonthName($monthNumber).ToString()
    $FolderNameToCreate = $MonthText.ToString() + '-' + $year.ToString()

    # Creating a desination folder path string
    $folderpath = $PhotosFolder + $FolderNameToCreate

    # Lets not create a folder if that folder path already created
    $folderexists = Test-Path $folderpath

    # Checking if the folder path exists, if not, create a new folder
    if($folderexists -eq $false){
        New-Item -Path $folderpath -ItemType Directory
    }else{Write-Host 'Folder path already exists in the desination directory.'}

    
    # Copying files to folder
    $checkString = (Get-Culture).DateTimeFormat.GetMonthName($file.LastWriteTime.Month).ToString() + '-' + $file.LastWriteTime.Year.ToString()
    $folderPathToCopy = $PhotosFolder + $checkString

    # Lets not copy the file which already exists
    $photodestinationPath = $folderPathToCopy + '\' + $file
    $fileexists = Test-Path $photodestinationPath

    # Generating the source file full path - with the file name
    $photoSourcePath = $CameraPath + '\' + $file

    # Checking if the file / photo exists, if not, copy the file
    if($fileexists -eq $false){
        Copy-Item $photoSourcePath -Destination $folderPathToCopy
	Write-Host $file + 'copied to desination folder ' + $folderPathToCopy 
    } else{Write-Host 'Photo already exists in the destination folder'
   }

}


}else {
# If another USB device was detected then just log it. 
$logDate = Get-Date
$logDate = $logDate.ToShortDateString() + '-' + $logDate.ToShortTimeString()
$logString = $logDate + ':' + 'The Camera with serial number ' + $CameraSerialNumber + ' is not connected. ' + $friendlyDeviceName.ToString() + ' (' +$serialNumberDevice + ')' + ' is connected.'
Add-Content $logFilePath $logString
}