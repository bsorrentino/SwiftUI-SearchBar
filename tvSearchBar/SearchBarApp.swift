//
//  tvSearchBarApp.swift
//  tvSearchBar
//
//  Created by softphone on 12/07/21.
//

import SwiftUI

var isInPreviewMode:Bool {
    (ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil)
}

#if targetEnvironment(simulator)
  // Simulator!
let isRunningOnSimulator = true
#else
let isRunningOnSimulator = false
#endif

import OSLog

let log = Logger(subsystem: "org.bsc.searchbox", category: "main")

@main
struct SearchBarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
