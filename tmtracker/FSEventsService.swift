import Foundation

class FSEventsService {
    var callback: ((FSEvent) -> Void)?
    let pathsToWatch: [String]

    private var stream: FSEventStreamRef!

    private let eventCallback: FSEventStreamCallback = {
        (stream: ConstFSEventStreamRef,
         contextInfo: UnsafeMutableRawPointer?,
         numEvents: Int,
         eventPaths: UnsafeMutableRawPointer,
         eventFlags: UnsafePointer<FSEventStreamEventFlags>,
         eventIds: UnsafePointer<FSEventStreamEventId>) in

        guard let contextInfo = contextInfo else { return }
        let mySelf = Unmanaged<FSEventsService>.fromOpaque(contextInfo).takeUnretainedValue()

        guard
                let callback = mySelf.callback,
                let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String]
                else {
            return
        }

        for index in 0 ..< numEvents {
            let event = FSEvent(identifier: eventIds[index],
                    path: paths[index],
                    flags: eventFlags[index])
            callback(event)
        }
    }

    init(pathsToWatch: [String], callback: @escaping (FSEvent) -> Void) {
        self.pathsToWatch = pathsToWatch
        self.callback = callback
    }

    deinit {
        stop()
    }

    func start() {
        var context = FSEventStreamContext(version: 0,
                info: nil,
                retain: nil,
                release: nil,
                copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()

        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)

        stream = FSEventStreamCreate(kCFAllocatorDefault,
                eventCallback,
                &context,
                pathsToWatch as CFArray,
                FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
                0,
                flags)

        FSEventStreamScheduleWithRunLoop(stream,
                CFRunLoopGetMain(),
                CFRunLoopMode.defaultMode.rawValue)
        FSEventStreamStart(stream)
    }

    func stop() {
        print("Stopping event tracking")
        FSEventStreamStop(stream)
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        stream = nil
    }
}
