//
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 05.02.24.
//

import XCTest

extension XCTestCase {
    func checkForMemoryLeaks<T: AnyObject>(_ instance: T, file: StaticString = #filePath, line: UInt = #line) -> T {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "memory leak, instance should have been deallocated", file: file, line: line)
        }
        return instance
    }
}
