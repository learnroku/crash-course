# Introduction
Welcome to the crash course I wish I had when I started working on Roku apps.  This course is intended to quickly get you up to speed on Roku SceneGraph. It's aimed at an audience of developers who are familiar with streaming video applications but are unfamiliar with Roku.  
Keep in mind this course aims to provide the bare minimum to get developers familiar with Roku fundamentals.  In particular, I do not spend much time on the user interface customization options. 
I provide links to more information where I can, but don't mistake this course for a comprehensive encyclopedia of Roku wisdom. Furthermore, the app produced by this course is really dumb. It's the Hello World of video players.

Requirements:
- a Roku (preferably a newer, more powerful model for better performance)
- Know the basics of HTTP requests and responses
- Understanding of ports on your local network
- A local web server for demo content
- Ability to use the command line
- Ability to use git
- Familiarity with XML, JSON, dot notation, associative arrays, and basic programming principles
- You need to know what HLS is
- Willingness to code with the bare minimum of IDE support coupled with a primitive debugger

## Some notes:  
As of November 2017, the Roku does not have an emulator (and I doubt one is coming any time soon).  You must have a physical device, running where you can access its IP address, to launch and debug applications. Furthermore, there is no compiler, at least not on your development machine. Code is written in XML and Roku's proprietary language called BrightScript. Code and assets are compressed into a plain old zip file and sent to the device. Once loaded on the device, some compilation happens and egregious mistakes in syntax should be caught.  
SceneGraph apps are a mix of XML and BrightScript. BS is loosely typed, similar to JavaScript, but uses a syntax similar to Visual Basic. In general, the user interface elements are defined in XML files and the application logic is defined in the BrightScript `.brs` files.  
One important thing to note about BrightScript: it is case-insensitive. For example, a function defined as `function getChild()` can be accessed using `getchild()` or `GetChild()` or `gEtChIlD()`. The demos provided by Roku have a range of styles, with little consistency. I try to keep my property names and functions all-lowercase with underscores, but I'm not entirely consistent either.  
As for events, the design implemented by Roku is called "field observers", which is introduced in Lesson 3.  

## Setting Up The Dev Environment
Each of the numbered directories is a lesson. You must deploy a lesson by zipping the _contents_ of the directory in order to sideload the app. If you get manifest errors in the debugger, make sure you are deploying the correct files.  
This course assumes you have already hooked up your Roku and enabled developer mode. You will need the username and password for the device.  
For more information, go here: https://blog.roku.com/developer/developer-setup-guide  
You need to have a web server hosting the `roku_lessons` content, found in the `server` directory. This directory contains JSON files of content feeds and some images. Personally I use MAMP installed on macOS because it's easy to use, see https://www.mamp.info.  
To access the debugger, you need port 8085 open on your local network.  
You must have telnet installed on your machine. It may not be included with OSX/macOS, if not then I suggest you installed homebrew (https://brew.sh/) and then use it to install telnet using `brew install telnet`  

## Links
For development, I recommend the Atom editor (atom.io) with the following packages:  
https://atom.io/packages/roku-develop  
https://atom.io/packages/language-brightscript  
https://atom.io/packages/platformio-ide-terminal  
https://atom.io/packages/pretty-json  
Also, the built in markdown-preview package is great for viewing the docs.  

Helpful links you should bookmark, in descending order of usefulness:  
Official Documentation: https://sdkdocs.roku.com  
Developer Forum: https://forums.roku.com/viewforum.php?f=34  
Official Developer Blog: https://blog.roku.com/developer  
Repository of official sample apps: https://github.com/rokudev  
https://developer.roku.com/  
