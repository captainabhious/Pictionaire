//
//  GlobalVariables.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/7/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//

import Foundation
import UIKit

class TheOneAndOnlyObservation {
    static let sharedInstance = TheOneAndOnlyObservation()
    var observation1 = String()
    private init() {}

}

class TheTwoAndOnlyObservation {
    static let sharedInstance = TheTwoAndOnlyObservation()
    var observation2 = String()
    private init() {}

}

//class LockButton {
//    var unlocked: Bool = true
//    var locked: Bool = false
//
//}



















