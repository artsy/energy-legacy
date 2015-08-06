Getting Confident
================

Once you've got a feel for the language, and some of the patterns here's some advice to start speeding you up in getting around the systems.

Use Reveal 
---------------
[Reveal](http://revealapp.com) is a tool for inspecting the view hierarchy. Folio was _featured_ on their website as an example of how pretty it looks. You should have Reveal installed, and when our app is loaded you select the simulator type in the top left of Reveal. See this [gist](https://gist.github.com/raven/8553761) for getting started, or be lazy: quit Xcode and run:


    mkdir -p ~/Library/Developer/Xcode/UserData/xcdebugger && curl https://gist.githubusercontent.com/raven/8553761/raw/Breakpoints_v2.xcbkptlist -o ~/Library/Developer/Xcode/UserData/xcdebugger/Breakpoints_v2.xcbkptlist


Use AppCode
---------------
AppCode is Xcode but with a lot of extra goodies because they don't have to say no to everything. It's a Java app and I _orta_ can understand when you wince but I can promise you that the 1%ers use it. You should too.

My install settings are in my [AppCode Repo](https://github.com/orta/AppCode), you can import them via _File > Import Settings_. They are a mix of TextMate + Xcode.

Use Base & Chairs
---------------
Core Data is nice to introspect as it's just a sqlite database, use this to your advantage by installing my gem _chairs_ to open the app's build folder then you can look in the Documents folder and open the DB in [Base](http://menial.co.uk) (or similar) for inspection.

Use Dash
---------------
Documentation is essential. Having quick access is even more useful. With Dash I partially type the class then guess the method name after pressing space. [Dash](http://kapeli.com) makes this very very fast.

If you insist on using Xcode
---------------
I kinda understand, it's worth the switch. Anyway.

* Use Xcode Plugins. The Git & FuzzyAutoComplete ones especially. See http://alcatraz.io
* Make "Open Quickly" command + t in Xcode
