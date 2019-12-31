//
//  Created by Dan Federman on 11/10/19.
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

/// A storage unit that counts bytes. Used for describing a maximum cache size.
///
/// This type should only be used when interacting with public API. This type enables changing how
/// the maximum file size is stored in a future breaking change without changing much code internally.
///
/// - Warning: If this value is changed, previously persisted message encodings will not be readable.
public typealias Bytes = UInt64
