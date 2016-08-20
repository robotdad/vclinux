#!/bin/bash
# Here for latest: https://github.com/robotdad/vclinux
#
# This script generates a filter file for organizing source files in a VC Linux project based on the directory structure.
# The filter file must be the same name as your project file + .filters. 
# So if your project file is preciouscode.vcxproj your filter file needs to be named preciouscode.vcxproj.filters. 
#
# The assumption this script has is that your source code is on a Linux machine and that
#  this directory has been mapped to Windows so the code can be edited in Visual Studio.
# To generate a project file for your source code see genvcxproj.sh
#
# You can find out more about VC++ for Linux here: http://aka.ms/vslinux
#
# Usage:
# $1 is the directory of source code to create project filters from
# $2 is file name to create, should be projectname.vcxproj.filters
# $3 is the root of your Windows fodler where these files will be mapped
# the meat of this is after the printheader/footer functions

function printheader(){
 echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<Project ToolsVersion=\"4.0\" xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">"
}

function printfooter(){
 echo "</Project>"
}

function listfilters(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type d)
 do
   f=${i##./}
   f=${f//\//\\}
   uuid="$(cat /proc/sys/kernel/random/uuid)"
   printf "    <Filter Include=\"%s\">\n" "$f"
   printf "      <UniqueIdentifier>{%s}</UniqueIdentifier>\n" "$uuid"
   printf "    </Filter>\n"
 done
 echo "  </ItemGroup>"
}

function listothers(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f ! -iname "*.c" ! -iname "*.cpp" ! -iname "*.h" ! -iname "*.txt" ! -iname "*.o" ! -iname "*.vcxproj")
 do
   d=${i%/*}
   fd=${d##*/}
   fp=${d##./}
   fp=${fp//\//\\}
   d=${d//\//\\}
   d=${d/./$windir}
   f=${i##*/}
   if [ $fd = "." ]
   then
     printf "    <None Include=\"%s\\%s\" />\n" "$d" "$f"
   else
     printf "    <None Include=\"%s\\%s\" >\n" "$d" "$f"
     printf "      <Filter>%s</Filter>\n" "$fp"
     printf "    </None>\n"
   fi
 done
 echo "  </ItemGroup>"
}

function listtxt(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.txt")
 do
   d=${i%/*}
   fd=${d##*/}
   fp=${d##./}
   fp=${fp//\//\\}
   d=${d//\//\\}
   d=${d/./$windir}
   f=${i##*/}
   if [ $fd = "." ]
   then
     printf "    <Text Include=\"%s\\%s\" />\n" "$d" "$f"
   else
     printf "    <Text Include=\"%s\\%s\">\n" "$d" "$f"
     printf "      <Filter>%s</Filter>\n" "$fp"
     printf "    </Text>\n"
   fi
 done
 echo "  </ItemGroup>"
}

function listcompile(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.c" -or -iname "*.cpp")
 do
   d=${i%/*}
   fd=${d##*/}
   fd=${d##*/}
   fp=${d##./}
   fp=${fp//\//\\}
   d=${d//\//\\}
   d=${d/./$windir}
   f=${i##*/}
   if [ $fd = "." ]
   then
     printf "    <ClCompile Include=\"%s\\%s\" />\n" "$d" "$f"
   else
     printf "    <ClCompile Include=\"%s\\%s\">\n" "$d" "$f"
     printf "      <Filter>%s</Filter>\n" "$fp"
     printf "    </ClCompile>\n" "$d" "$f"
   fi 
done
 echo "  </ItemGroup>"
}


function listinclude(){
 echo "  <ItemGroup>"
 for i in $(find . -not -path '*/\.*' -type f -iname "*.h")
 do
   d=${i%/*}
   fd=${d##*/}
   fd=${d##*/}
   fp=${d##./}
   fp=${fp//\//\\}
   d=${d//\//\\}
   d=${d/./$windir}
   f=${i##*/}
   if [ $fd = "." ]
   then
     printf "    <ClInclude Include=\"%s\\%s\" />\n" "$d" "$f"
   else
     printf "    <ClInclude Include=\"%s\\%s\">\n" "$d" "$f"
     printf "      <Filter>%s</Filter>\n" "$fp"
     printf "    </ClInclude>\n" 
   fi
 done
 echo "  </ItemGroup>"
}

cd $1 || exit 2;
touch $2 && test -w $2 || exit 2;
windir=$3
printheader > $2
listfilters >> $2
listothers >> $2
listtxt >> $2
listcompile >> $2
listinclude >> $2
printfooter >> $2
exit
