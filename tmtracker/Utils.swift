import Foundation

class Utils {

    func isTrash(event: FSEvent) -> Bool {
        event.path.hasSuffix("/node_modules") || event.path.hasSuffix("/ccc1ccc")
    }

    func isDir(event: FSEvent) -> Bool {
        (event.flags & UInt32(kFSEventStreamEventFlagItemIsDir) != 0)
    }

    func isXattrMod(event: FSEvent) -> Bool {
        (event.flags & UInt32(kFSEventStreamEventFlagItemXattrMod) != 0)
    }

    func printFlags(_ flags: UInt32) {
        var flagsDict = ["kFSEventStreamEventFlagNone": kFSEventStreamEventFlagNone ,
        "kFSEventStreamEventFlagMustScanSubDirs": kFSEventStreamEventFlagMustScanSubDirs ,
        "kFSEventStreamEventFlagUserDropped": kFSEventStreamEventFlagUserDropped ,
        "kFSEventStreamEventFlagKernelDropped": kFSEventStreamEventFlagKernelDropped ,
        "kFSEventStreamEventFlagEventIdsWrapped": kFSEventStreamEventFlagEventIdsWrapped ,
        "kFSEventStreamEventFlagHistoryDone": kFSEventStreamEventFlagHistoryDone ,
        "kFSEventStreamEventFlagRootChanged": kFSEventStreamEventFlagRootChanged ,
        "kFSEventStreamEventFlagMount": kFSEventStreamEventFlagMount ,
        "kFSEventStreamEventFlagUnmount": kFSEventStreamEventFlagUnmount ,
        "kFSEventStreamEventFlagItemCreated": kFSEventStreamEventFlagItemCreated ,
        "kFSEventStreamEventFlagItemRemoved": kFSEventStreamEventFlagItemRemoved ,
        "kFSEventStreamEventFlagItemInodeMetaMod": kFSEventStreamEventFlagItemInodeMetaMod ,
        "kFSEventStreamEventFlagItemRenamed": kFSEventStreamEventFlagItemRenamed ,
        "kFSEventStreamEventFlagItemModified": kFSEventStreamEventFlagItemModified ,
        "kFSEventStreamEventFlagItemFinderInfoMod": kFSEventStreamEventFlagItemFinderInfoMod ,
        "kFSEventStreamEventFlagItemChangeOwner": kFSEventStreamEventFlagItemChangeOwner ,
        "kFSEventStreamEventFlagItemXattrMod": kFSEventStreamEventFlagItemXattrMod ,
        "kFSEventStreamEventFlagItemIsFile": kFSEventStreamEventFlagItemIsFile ,
        "kFSEventStreamEventFlagItemIsDir": kFSEventStreamEventFlagItemIsDir ,
        "kFSEventStreamEventFlagItemIsSymlink": kFSEventStreamEventFlagItemIsSymlink]

        flagsDict.forEach { (key, value) in
            if flags & UInt32(value) != 0 {
                print(key)
            }

        }
    }

    func isCreated(event: FSEvent) -> Bool {
        (event.flags & UInt32(kFSEventStreamEventFlagItemCreated) != 0)
    }

    @discardableResult
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }

}
