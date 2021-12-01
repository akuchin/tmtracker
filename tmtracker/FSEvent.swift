import Foundation

struct FSEvent {
    let identifier: FSEventStreamEventId
    let path: String
    let flags: FSEventStreamEventFlags
}
