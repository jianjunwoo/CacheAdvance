//
//  Created by Dan Federman on 12/3/19.
//  Copyright © 2019 Dan Federman.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

/// A protocol representing an integer that can be encoded as data.
protocol BigEndianHostSwappable where Self: FixedWidthInteger {

    /// Converts the big-endian value in x to the current endian format and returns the resulting value.
    static func swapToHost(_ x: Self) -> Self

}

extension BigEndianHostSwappable {

    /// Initializes encodable data from a data blob.
    ///
    /// - Parameter data: A data blob representing encodable data. Must be of length `Self.storageLength`.
    init(_ data: Data) {
        let decodedSize = data.withUnsafeBytes {
            return $0.load(as: Self.self)
        }
        self = Self.swapToHost(decodedSize)
    }

    /// The length of a contiguous data blob required to store this type.
    static var storageLength: Int { MemoryLayout<Self>.size }

}

extension Data {

    /// Initializes Data from a numeric value. The data will always be of length `Number.storageLength`.
    /// - Parameter value: the value to encode as data.
    init<Number: BigEndianHostSwappable>(_ value: Number) {
        var valueToEncode = value.bigEndian
        self.init(bytes: &valueToEncode, count: Number.storageLength)
    }

}
