//
//  AppDelegate.swift
//  CallParser Demo
//
//  Created by Peter Bourget on 6/6/20.
//  Copyright © 2020 Peter Bourget. All rights reserved.
//

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
    let callLookup = CallLookup(prefixList: callParser.prefixList, childPrefixList: callParser.childPrefixList)
    let contentView = ContentView()
      .environmentObject(callParser)
      .environmentObject(callLookup)
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

