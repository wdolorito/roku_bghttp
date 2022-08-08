# Super contrived BrightScript http service

## TL;DR
```
var = SendRequest(https://interesting.data, headers)  ' defaults to get
m.bg_service.StartTask(var)                           ' start the task

while m.bg_service.GetTaskStatus(var) = False         ' poll in your main loop
  m.bg_service.CheckTasks()
end while

varRaw = m.bg_service.GetTaskResponse(var)            ' get your data
m.bg_service.DelTaks(var)                             ' cleanup
```

This is a breakout of a solution for a problem with network requests from a previously published Roku channel.  But first of all, consider this a legacy solution, since there have been developments in the Roku world since this has been in use to solve this problem more easily.  In other words, a better solution will more likely than not be found using SceneGraph.  That said, if you're working on an older Roku device that does not support the newer features of BrightScript and SceneGraph, this might be worth trying to understand.

This project creates a global object that stores network calls as tasks that can get checked easily from the main loop.  The main idea was to create a central store to handle generic async network calls.  This implementation was used exclusively for `GET` requests, as the Roku was used primarily for data consumption and information display and not seriously considered as a data input device (And it really shouldn't be to this day.  Five buttons for input?!? ***\<cringe\>***).  However, a different request type can be set to anything that [ifUrlTransfer](https://developer.roku.com/docs/references/brightscript/interfaces/ifurltransfer.md) supports if you're a masochist using a Roku to update GBs of data in your DB.  

To drop this solution in to a different project, the only files needed are `HTTP.brs`, `Debug.brs`, `StringUtils.brs`, `Types.brs` and possibly `Convenience.brs` for a utility function that has been a savior of a bunch of headaches trying to locate where things have broken in a channel.  That file usually contains even more utility functions for orphan logic that are used across different files.  Which really doesn't matter since one can copy and paste everything from every file in to one mega BRS file (which is exactly what the `build.sh` script does without the `-d` switch) if you have the big brain to keep track of hundreds if not thousands of lines of code.  I do not, so it's organized as presented.  It's really not as serious as it's made out to be, since a `-p` switch can also be passed to `build.sh` to preserve that giant BRS file.  Three more characters to type on the command line tho, you feel me?

## File listing
```
├── assets
│   ├── focus_fhd.png
│   ├── focus_hd.png
│   ├── focus_sd.png
│   ├── splash_fhd.png
│   ├── splash_hd.png
│   └── splash_sd.png
├── build.sh
├── manifest
├── README.md
└── source
    ├── lib
    │   ├── Convenience.brs
    │   ├── Debug.brs
    │   ├── StringUtils.brs
    │   └── Types.brs
    ├── Main.brs
    └── utility
        ├── APIRequests.brs
        ├── HTTP.brs
        └── MVars.brs
```
