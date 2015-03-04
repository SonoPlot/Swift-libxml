# Hooking Up libxml2 To Your Xcode Project

libXML is included on your machine, but it isn’t included by default in Xcode. It will need to be important and linked to your project for Xcode to be able to see it.

Go to your project and find your Build Settings in your Project. Search your Build Settings for <em>Header Search Paths.</em> In your project’s search paths, add the following:

> $(SDKROOT)/usr/include/libxml2

While still in your Build Settings, search for **Other Linker Flags.** Add this line to your linker flags:

> -lxml2

Now go to your Targets and find your Build Phases. Find the tab that says **Link Binaries with Library**. Click on the “+” sign to load a new library to link to the project. Search for “libxml2.” There should be two results. Add both of those results to your project.

Lastly, you will need to import an Objective-C bridging header into your project. The Objective-C bridging header is a file that exists in this project, so you just need to drag it from the sample project over to your project.

After the bridging header is added to your project, go back to your Build Settings and search for **Objective-C Bridging Header**. You will need to add a line that has your project name and the bridging header name in it. For example, in the sample project LibXMLWrapperExample, the line added to the bridging header was: 

> LibXMLWrapperExample/Bridging-Header.h
