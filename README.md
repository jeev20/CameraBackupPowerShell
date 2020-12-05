# Camera Backup via Powershell
## Why use this script? 
Most of us do not look forward to transfer and organize photos after capturing them on a DSLR or a Point and shoot camera. The art of taking good pictures is one thing, but to quickly copy them to a destination folder is a dreaded task! End of the day, we are left with a lot of images in the SD card and we have no idea, which ones have we already copied! 

## Solution
Through this PowerShell script, I have tried to make the process of coping photos from a camera SD card to a destination folder into a easy plug-and-play PowerShell script and Windows task scheduler. 

## What does CameraBackup.ps1 script do?
- Checks if the correct camera (the camera you are interested in) is inserted by checking the Camera Serial number. Else the unmatched Serial number of the USB is logged to a log.txt file. 
- If it is the correct camera, the script will read the properties of all files in the "\DCIM" or the target folder in the camera
- It makes a list of unique months when the photos where taken
- Navigates to the destination folder and creates folders (Month-Year) only if such a folder does not exist from before
- It checks each image file and according to the creation dates, copies then to the correct folder (Month-Year) in the destination folder
- If the image file already exists in the destination folder, the images are not overwritten


## Preconditions 
Ensure you setup your PowerShell instance to be able to run external scripts. It essentially will ensure that you can run the script (CameraBackup.ps1).

Step 1. Open PowerShell and run this command:

```
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```
You can read more about PowerShell [ExecutionPolicy here.](https://docs.microsoft.com/en-us/PowerShell/module/microsoft.PowerShell.security/set-executionpolicy?view=PowerShell-7.1)

You can now verify the ExecutionPolicy by using the following command:
```
    Get-ExecutionPolicy 
```
Step 2. Finding the serial number of your camera (Connect the camera to the computer using USB), open PowerShell and run the following commands. You will get the Serial Number of your camera device. Note this for later use.

```
$USBDevices = get-disk | where bustype -eq 'usb'

$friendlyDeviceName = $USBDevices.FriendlyName
$serialNumberDevice = $USBDevices.SerialNumber
```

## Running the script 

Step 1. Copy or Clone the contents of this repository 

Step 2. Open the CameraBackup.ps1 script in any text editor and edit the first two variables to suit your camera and destination folder and save the CameraBackup.ps1 file.
```
# Your camera serial number
$CameraSerialNumber = 'CASSD00ASDAD08C' 

# Your choice of destination folder
$PhotosFolder = 'H:\PhotosBackup\SonyA5100\' 
```
**You may also have to edit line 33 in the script as different camera manufacturers have different folder structures where the images are stored.** 

Step 3. Open PowerShell by holding Shift+Right mouse click in the folder menu and choose
```
Open PowerShell window here
```
Step 4. CD in to the cloned repository. For example,

```
cd "c\Users\USERNAME\Downloads\CloneGITHUBFolder"
```
Step 5. Run the CameraBackup.ps1 script using
```
.\CameraBackup.ps1
```

## Automating the execution of the script on USB event
### Using Windows Task Scheduler
1. Open Task scheduler from start menu and create a new basic task. 
![CreateTask](https://github.com/jeev20/CameraBackupPowerShell/blob/main/Images/CreateTask.PNG)

2. Enter the name of the task and click ok

![GiveaName](https://github.com/jeev20/CameraBackupPowerShell/blob/main/Images/NameandClickOK.PNG)

3. Go to the triggers section and add a new trigger based on an windows event

![SetTrigger](https://github.com/jeev20/CameraBackupPowerShell/blob/main/Images/SetTrigger.PNG)

4. Go to the actions tab and a new action
Select ```Start a Program```

5. In Program / script enter field add ``` "C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe" ```

6. In Add argument field add (remember to have double quotes) ``` "The full path of the CameraBackup.ps1 script" ```

![CreateAction](https://github.com/jeev20/CameraBackupPowerShell/blob/main/Images/SetAction.PNG)

7. Finally, your task will look something like this: 

![CreatedTask](https://github.com/jeev20/CameraBackupPowerShell/blob/main/Images/TaskCreated.PNG)

So now it is time to test this. Connect the camera to the PC via the USB connection and just wait! All the image files should be organized neatly in the destination folder you provided. 


## Contributors
* [jeev20]("https://github.com/jeev20")
