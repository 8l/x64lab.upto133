
Hi,Welcome to x64lab group.
My name is Marc, i am a German assembly programmer.

You find me as "hopcode" on

 - http://sites.google.com/site/x64lab
 - http://groups.google.com/group/x64lab

 - board http://board.flatassembler.net/index.php
 - and on comp.lang.asm.x86 newsgroup

  -----------------------------------------------------------------

Summary:

  -1 What is exactly x64lab ?

  -2 Why mostly assembly coding ?

  -3 Why x64lab is free and opensource ?

  -4 Is it only Windows ?

  -5 Where can i find x64lab code ?

  -6 INSTALL notes

  -7 COMPILE notes

  -8 LICENSE

   -----------------------------------------------------------------

-1 What is exactly x64lab ?
   x64lab is an assembler framework. it is written
   completely in assembly using fasm and other tools. 
   it is aimed mainly as a framework for assembly programmers.

-2 Why mostly assembly coding ?
   because assembly is the most successful method
   to control the machine. after having understood the basically 
   concepts assembly coding speed up your coding of hundreds times.
   I speak for personal experience; what we need now is
   organization of our tools and facility when
   editing files. This is what x64lab is for.

-3 Why x64lab is free and opensource ?
   Because it aims to be technology. Technology
   is the expression of human capabilities. Technology
   should be free for all to learn improve and apply.

-4 Is it only Windows ?
   Yes, at the moment. I have no idea how *NXes work.
   If You develop on other OS, make a designed proposal.
   Nothing is impossible.

-5 Where can i find x64lab code ?
   online cloning the Mercurial from
     https://code.google.com/p/x64lab/

   or donwnload the latest (.7z) zipped version from
   http://code.google.com/p/x64lab/downloads/list

   -----------------------------------------------------------------

-6 Install notes:
   - download the latest version of fasm assembler
     from http://flatassembler.net/download.php
     and extract the package in a folder created just for it.
   
   - Create a local directory named "x64lab" and clone the project
     in there from the Mercurial repository online.
     Alternatively,create a subdirectory \develop in x64lab.

      the "bin" prefixed package should be unpacked in x64lab
      the "src" prefixed package should be unpacked in x64lab\develop

   - edit the file [x64lab\develop\setenv.bat]
     to set the path for fasm. if you have fasm.exe
     in [E:\fasm], then set the path to it in this way
     
     path=%path%;E:\fasm

   - set the environment variable for x64lab that allows
     sources to be compiled. if you have x64lab in
     [E:\x64lab] then

     set x64devdir=E:\x64lab\develop

   - save the file [x64lab\develop\setenv.bat]

   -----------------------------------------------------------------

-7 Compile notes:
   - Having installed x64lab, and edited the [develop\setenv.bat]
     you will find some other batch files in the [develop\] folder.

     - build_all.bat : to rebuild the whole package

     - setlang.bat   : to rebuild and set the lang.dll file

     - version.vbs   : to increment the version number
       it creates or update a version.txt file

     - lab_update.bat : to set the current build as the
       working version.

     - repack.bat     : to pack src/bin zipped file


-8 License
   - x64lab is licensed under the MPL2.0 license. Please, read it 
     online from http://www.mozilla.org/MPL/2.0/
     or in the file LICENSE.HTM

   - x64lab is Copyright © 2009-2012,Marc Rainer Kranz

   - dock64,top64 plugins are under the MPL2.0 license as above

   - Fasm is Copyright © 2004-2012, Tomasz Grysztar.

   - Scilexer,Scintilla is Copyright 1998-2003 by Neil Hodgson

   - files in the [equates\] folder are my own modifications from
     public domain provided by madmatt.

   - file macro\unsupported.inc is public domain
	 



