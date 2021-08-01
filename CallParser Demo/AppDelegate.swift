//
//  AppDelegate.swift
//  CallParser Demo
//
//  Created by Peter Bourget on 6/6/20.
//  Copyright © 2020 Peter Bourget. All rights reserved.
//


/*
 Ideally the result of the callsign analysis should be a single structure that contains all available info. In my Delphi code,
 I use the structure defined in the attached CallInf.pas unit. The main purpose of the analysis is to determine what awards a
 QSO with the given callsign is good for. Other purposes are to determine the station's location to show it on the map, and to
 provide to the operator some info useful during the QSO, such as correspondent's name.

 Callsign analysis is a 3-step process. First, a lookup of the callsign in the callbook (described below) is performed.
 The callbook typically contains only the data that cannot be inferred from the prefix. At step 2, prefix analysis is done,
 and the info from the callbook and prefix is merged. Finally, some cross-inference is performed, e.g, the IOTA group is
 inferred from the DXCC entity and vice versa when possible. The code for this analysis is in the attached CallAnalz.pas
 unit (it makes use of the prefix analyzer that I sent you earlier). Please pay attention to the MergeAllHits and
 ComplementCb methods that combine data into one structure.

 The callbook that I use, code name Active Callbook, is one of my unpublished projects. After the installation, the callbook
 is emptly, the first thing the program does is downloads all publicly available callsign datasets, such as FCC and RAC directories,
 national callbooks, etc. The Callbook runs in the background and downloads the updates of all data by schedule.

 I have used this system for several years in my unpublished software that I used only in my own shack. I would like to have the
 same functionality in HamCockpit, this requires re-writing of all code in dot-NET. If you are interested in doing the whole callsign
 analysis thing, of which your prefix analyzer would be a part, I can sent you all of my Delphi code.
 */

import Cocoa
import SwiftUI
import CallParser

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    // Pass in the environment radio instance
    let callParser = PrefixFileParser()
    let callLookup = CallLookup(prefixFileParser: callParser)
    let contentView = ContentView()
      .environmentObject(callParser)
      .environmentObject(callLookup)
      //.environmentObject(callParser2)
    //let contentView = ContentView()

    // Create the window and set the content view. 
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
      return true
  }

}

