# Solo Update Packages

This is the repository for Solo updates as delivered by Solex.

## File Format

The file format for a Solo update package is pretty simple: It's a zip file containing some specific subdirectories, which 
contain files to either be installed on the Solo, loaded into the Solo, or to do things on the Solo.

### ```scripts/```
Scripts go here. If you need to run commands before or after installation, you can make scripts to do that, and 
put them in this directory. They're referenced from the ```package.properties``` file, described below.

If any extra preparation (creating directories, etc) needs to be done, it's this script that does it.

### ```params/```
Parameter files go here. You can have any number of them, but you'll typically just have one. Parameter files are 
in the expected format, where lines look something like this:
```
AHRS_TRIM_Y,-0.00460798
AHRS_TRIM_Z,0.00000000
AHRS_WIND_MAX,0
AHRS_YAW_P,0.20000000
ANGLE_MAX,2950
ARMING_CHECK,1
ATC_ACCEL_P_MAX,57600.00000000
```

### ```install/```
The installable files go in this subdirectory. Everything needs to be in a subdirectory under ```install/```, so Solex knows where to put a file on the Solo while it's copying files.

Suppose you have 4 python files that go into `/usr/bin` and a .px4 file that needs to be updated as the Solo's firmare. In that case, 
you put the python files in ```install/usr/bin``` and the firmware file in ```install/firmware```. Your zip file would look like this:

```
install/
    firmware/
        SomeUpdateFile-v1.0.px4
    usr/
        bin/
            follow.py
            buttonManager.py
            multipoint.py
            shotManager.py
            someNewSmartShot.py
manifest.txt
package.properties
```

## Files

### ```manifest.txt```
This is a file that contains some info about the package. Just general information, possibly special instructions you expect the 
user to read, that sort of thing.

Here's a sample:
```
Awesome Update Number Three

This update is awesome. It fixes yaw in a few of the smart shots, and adds a new Smart Shot to the Solo. 
Also it updates the firmware on the Solo so all of the LEDs glow red.
```


### ```package.properties```
This is a file Solex uses as a guide for how to treat an update package. Here are the legal values for ```package.properties```:
*   ```preinstall```: Specify the root name (not the directory) of a script to run _before_ installation of other files.
*   ```postinstall```: Specify the root name of a script to run _after_ installation of other files.
*   ```reboot```: If ```true```, prompt the user to reboot after installation completes.
*   ```postinstall.instructions```: Instructions for the user after they install the package. Could be anything, really.
*   ```target.device```: Specifies which device the update should be installed to. Valid values are ```solo```, ```artoo```. If it's omitted, it defaults to ```solo```.
*   ```compat```: Specifies compatibility of this package. There are 3 possible values:
    *   ```2.0```: Package can only be installed on old "black cube" Solos.
    *   ```2.1```: Package can only be installed on new Solos with a 2.1 Cube (green or black)
    *   ```all```: Package can be installed on either Solo version. This is the default.
*   ```required.param```: Deprecated. If present, specifies a parameter that must be present in order to install this package. You should prefer to use the ```compat``` property over this one, although you can specify both for maximum pickiness.

Here's a sample:
```
preinstall=preinstall.sh
postinstall=postinstall.sh
reboot=true
postinstall.instructions=Dunk your Solo in cold water. Then lay it out in the sun to dry.
compat=2.1
```

When you download this file and tell Solex to install it, the following happens:

1.  The file is unzipped to a temp directory.
2.  The `preinstall` script, if any, is run. If it needs to abort the installation for some reason, it can return a non-zero
    exit code. This will abort the entire installation process. Otherwise, it needs to return 0 for the installation to continue.
3.  The directories under `install` are enumerated, and files found in each are `scp`ed to the corresponding directory on the Solo.
4.  The `parameters.param` file, if present, is loaded and each of the parameters specified in it are set on the Solo.
5.  The `postinstall` script, if any, is run. Like the `preinstall` script, it can abort the installation with a nonzero
    exit code. But by this time, the files have already been copied and parameters loaded. So aborting an installation at this stage is unusual for a script to do. And if it needs to do it, it should take care to undo everything that's been done up to that point.

That's about it.



