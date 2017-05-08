#!/bin/bash
# Here for latest: https://github.com/robotdad/vclinux 
#
# This script generates a VC Linux project file that includes your source files from the directory specified.
# The project type is makefile and it is set to not copy sources since the assumption here is the files have 
#  been mapped to a Windows drive.
#
# This leaves your source in a flat list. 
# To organize your files as seen in your directory use genfilters.sh to generate an accompanying filter file.
#
# The assumption this script has is that your source code is on a Linux machine and that
#  this directory has been mapped to Windows so the code can be edited in Visual Studio.
#
# You can find out more about VC++ for Linux here: http://aka.ms/vslinux
# Usage:
# $1 is the directory of source code to create a project file for
# $2 is file name to create, should be projectname.vcxproj

function printheader(){
 echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<Project DefaultTargets=\"Build\" ToolsVersion=\"14.0\" xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">
  <ItemGroup Label=\"ProjectConfigurations\">
    <ProjectConfiguration Include=\"Debug|ARM\">
      <Configuration>Debug</Configuration>
      <Platform>ARM</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Release|ARM\">
      <Configuration>Release</Configuration>
      <Platform>ARM</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Debug|x86\">
      <Configuration>Debug</Configuration>
      <Platform>x86</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Release|x86\">
      <Configuration>Release</Configuration>
      <Platform>x86</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Debug|x64\">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Release|x64\">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <PropertyGroup Label=\"Globals\">
    <ProjectGuid>{d14472f1-e80c-4d22-a2b5-6694cdc04c48}</ProjectGuid>
    <Keyword>Linux</Keyword>
    <RootNamespace>makefile</RootNamespace>
    <MinimumVisualStudioVersion>14.0</MinimumVisualStudioVersion>
    <ApplicationType>Linux</ApplicationType>
    <ApplicationTypeRevision>1.0</ApplicationTypeRevision>
    <TargetLinuxPlatform>Generic</TargetLinuxPlatform>
    <LinuxProjectType>{FC1A4D80-50E9-41DA-9192-61C0DBAA00D2}</LinuxProjectType>
  </PropertyGroup>
  <Import Project=\"\$(VCTargetsPath)\Microsoft.Cpp.Default.props\" />
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|ARM'\" Label=\"Configuration\">
    <UseDebugLibraries>true</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|ARM'\" Label=\"Configuration\">
    <UseDebugLibraries>false</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x86'\" Label=\"Configuration\">
    <UseDebugLibraries>true</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x86'\" Label=\"Configuration\">
    <UseDebugLibraries>false</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x64'\" Label=\"Configuration\">
    <UseDebugLibraries>true</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x64'\" Label=\"Configuration\">
    <UseDebugLibraries>false</UseDebugLibraries>
    <ConfigurationType>Makefile</ConfigurationType>
  </PropertyGroup>
  <Import Project=\"\$(VCTargetsPath)\Microsoft.Cpp.props\" />
  <ImportGroup Label=\"ExtensionSettings\" />
  <ImportGroup Label=\"Shared\" />
  <ImportGroup Label=\"PropertySheets\" />
  <PropertyGroup Label=\"UserMacros\" />
    <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|ARM'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x64'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x86'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>
    <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|ARM'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x64'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x86'\">
    <LocalRemoteCopySources>false</LocalRemoteCopySources>
  </PropertyGroup>"
}

function printfooter(){
 echo "  <ItemDefinitionGroup />
  <Import Project=\"\$(VCTargetsPath)\Microsoft.Cpp.targets\" />
  <ImportGroup Label=\"ExtensionTargets\" />
</Project>"
}

function listothers(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f ! -iname "*.c" ! -iname "*.cpp" ! -iname "*.h" ! -iname "*.txt" ! -iname "*.o" ! -iname "*.vcxproj" ! -iname "*.filters")
 do
   d=${i%/*}
   d=${d//\//\\}
   f=${i##*/}
   printf "    <None Include=\"%s\\%s\" />\n" "$d" "$f"
 done
 echo "  </ItemGroup>"
}

function listtxt(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.txt")
 do
   d=${i%/*}
   d=${d//\//\\}
   f=${i##*/}
   printf "    <Text Include=\"%s\\%s\" />\n" "$d" "$f"
 done
 echo "  </ItemGroup>"
}

function listcompile(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.c" -or -iname "*.cpp")
 do
   d=${i%/*}
   d=${d//\//\\}
   f=${i##*/}
   printf "    <ClCompile Include=\"%s\\%s\" />\n" "$d" "$f"
 done
 echo "  </ItemGroup>"
}


function listinclude(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.h")
 do
   d=${i%/*}
   d=${d//\//\\}
   f=${i##*/}
   printf "    <ClInclude Include=\"%s\\%s\" />\n" "$d" "$f"
 done
 echo "  </ItemGroup>"
}

cd $1 || exit 2;
touch $2 && test -w $2 || exit 2;
printheader > $2
listothers >> $2
listtxt >> $2
listcompile >> $2
listinclude >> $2
printfooter >> $2
exit
