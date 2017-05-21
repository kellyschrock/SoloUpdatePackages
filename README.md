# Solo Update Packages

This is the repository for Solo updates as delivered by Solex.

## File Format

The file format for a Solo update package is pretty simple: It's a zip file containing the files that make up an update, along with
the directory structure the files go in.

Suppose you have 4 python files that go into `/usr/bin` and a .px4 file that needs to be updated as the Solo's firmare. In that case, 
your zip file would look like this:

```
firmware/
    SomeUpdateFile-v1.0.px4
usr/
    bin/
        follow.py
        buttonManager.py
        multipoint.py
        someOtherFile.py
manifest.txt
parameters.param
```

When you download this file and tell Solex to install it, the following happens:

1.  The file is unzipped to a temp directory.
2.  The directories are enumerated, and files found in each are `scp`ed to the corresponding directory on the Solo.
3.  The `parameters.param` file, if present, is loaded and each of the parameters specified in it are set on the Solo.

That's about it.


