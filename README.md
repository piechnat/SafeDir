# SafeDir

SafeDir.cmd is a batch script that creates a hidden location in NTFS.
A folder (one per partition) that cannot be accessed from the windows shell.
After entering the password, a directory junction is created in the current folder,
which is the gateway to this secure location. The password can be modified and is 
stored in [ADS](https://en.wikipedia.org/wiki/NTFS#Alternate_data_streams_(ADS)).

This script is not fully tested. You use it at your own risk.
