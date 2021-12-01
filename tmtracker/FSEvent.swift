//
// Created by Artem Kuchyn on 01.12.2021.
//

import Foundation

struct FSEvent {
    let identifier: FSEventStreamEventId
    let path: String
    let flags: FSEventStreamEventFlags
}
