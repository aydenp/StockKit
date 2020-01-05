//
//  StockPhoto.swift
//  Stock MessagesExtension
//
//  Created by Ayden Panhuyzen on 2019-07-20.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

public struct StockPhoto: Codable, Hashable {
    public let thumbnailURL: URL?, fullImageURL: URL
    public let alternativeText: String?
}
