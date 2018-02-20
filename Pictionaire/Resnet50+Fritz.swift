//
//  Resnet50+Fritz.swift
//  Pictionaire
//
//  Created by Eric Hsiao on 2/6/18.
//  Copyright © 2018 Abhi Singh. All rights reserved.
//

import Fritz

extension Resnet50: SwiftIdentifiedModel {

    static let modelIdentifier = "<insert model id>"

    static let packagedModelVersion = 1

    static let session = Session(appToken: "<insert app token>")
}
