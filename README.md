# vclinux
Unofficial scripts and stuff related to the [Visual C++ for Linux Development extension](http://aka.ms/vslinux). 

Yes I'm the program manger for that but this is stuff I've made on the side. Think about it. If this was good enough to ship it'd be in the box right?

I hope you find this useful, especially for modifying to fit for your needs. If you have any comments or suggestions I'd love to hear them.

## Project generation bash scripts

### genvcxproj.sh
This script generates a VC Linux project file that includes your source files from the directory specified. The project type is makefile and it is set to not copy sources since the assumption here is the files have been mapped to a Windows drive.

This leaves your source in a flat list. To organize your files as seen in your directory use genfilters.sh to generate an accompanying filter file.

The assumption this script has is that your source code is on a Linux machine and that this directory has been mapped to Windows so the code can be edited in Visual Studio.

Input for this script is:
1. is the directory of source code to create a project file for
2. is file name to create, should be projectname.vcxproj

Example usage:
```
$ ./genvcxproj.sh ~/repos/preciouscode/ preciouscode.vcxproj
```

Once you have your project open in Visual Studio connect to your Linux machine using the extension, [as shown here](https://blogs.msdn.microsoft.com/vcblog/2016/03/30/visual-c-for-linux-development/#consoleapp).
Now add any paths needed for your includes to light up intellisense, and setup your remote build command line on the property page. This is specific to your project but would be something like:
```
cd ~/repos/preciouscode/; make
```
As you can see multiple commands can be used ; seperated.

### genfilters.sh
This script generates a filter file for organizing source files in a VC Linux project based on the directory structure. The filter file must be the same name as your project file + .filters. So if your project file is preciouscode.vcxproj your filter file needs to be named preciouscode.vcxproj.filters. 

The assumption this script has is that your source code is on a Linux machine and that this directory has been mapped to Windows so the code can be edited in Visual Studio.

To generate a project file for your source code see genvcxproj.sh

1. is the directory of source code to create project filters from
2. is file name to create, should be projectname.vcxproj.filters

Example usage:
```
$ ./genfilters.sh ~/repos/preciouscode/ preciouscode.vcxproj.filters
```


# Debugging a linux project on Windows

## Prerequisites
### Windows
1. Visual Studio 2017

### Linux
1. Samba
2. GDB
3. gdbserver
4. vclinux(this project)
5. Target project source

## Steps

We assume the directory structure of target project as follow :
```
MyProject
\
 |src
 |  \
 |   |main.c
 |   |hello.h
 |obj
 |other
 |Makefile
```

And We assume that the location of target project and vclinux are both at home directory (~)
1. Make the target project and run it
```
make
bin\a.out
```
2. generate vcxproj
```
~\vclinux\bash\genvcxproj.sh ~\MyProject\ MyProject.vcxproj
```
3. generate filters
```
~\vclinux\bash\genfilters.sh ~\MyProject\ MyProject.vcxproj.filters
```
4. copy the headers of dependence to project. we assume that the target project depend with dep.h
```
cp dep.h ~\MyProject\deps\
```

Now, the directory structure of target project becomes as follow:
```
MyProject
\
 |src
 |  \
 |   |main.c
 |   |hello.h
 |deps
 |  \
 |  |dep.h
 |MyProject.vcxproj
 |MyProject.vcxproj.filters
 |obj
 |other
 |Makefile
 |bin
 |  \
 |  |a.out
```

5. share the directory of target project by samba
6. open MyProject.vcxproj by Visual Studio 2017 on Windows
7. set dependence at Visual Studio
```
    right click Project->Properties->Configuration Properties->C/C++->IntelliSense->Include Search Path
  add MyProject/deps folder to it
```

8. Debugging by Visual Studio 2017 at Windows
```
Debug->Attach to Process

Connection Type : SSH
Connection Target : username@ip

Select the process (a.out) at [Available Processes]

Attach
```

## Troubleshoot

1. Make sure that you have enough permission to debug target process
2. Make sure that the version of source is matched with running process