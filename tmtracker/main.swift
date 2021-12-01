//
//  main.swift
//  tmtracker
//
//  Created by Artem Kuchyn on 01.12.2021.
//

import Foundation

print("Hello, World!")

let utils = Utils()

let path = NSString(string: "~/MyDev").expandingTildeInPath
let fsEventsService = FSEventsService(pathsToWatch: [path]) { event in
    if utils.isDir(event: event)
               && utils.isCreated(event: event)
               && !utils.isXattrMod(event: event)
               && utils.isTrash(event: event) {
//        utils.printFlags(event.flags)
        print("Excluding folder: \(event.path) - \(event.flags)")
        utils.shell("tmutil", "addexclusion", event.path)
    }
}
fsEventsService.start()
CFRunLoopRun()
fsEventsService.stop()