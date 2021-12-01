import Foundation

let pathArg = CommandLine.arguments[1]

let utils = Utils()

let path = NSString(string: pathArg).expandingTildeInPath
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

print("Start tracking \(pathArg)")

fsEventsService.start()
CFRunLoopRun()
fsEventsService.stop()