//	
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

extension Array {
    mutating func moveItem(from oldIndex: Int, to newIndex: Int) {
        insert(remove(at: oldIndex), at: newIndex)
    }
}
