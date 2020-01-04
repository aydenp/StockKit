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

public struct StockPhotoResults {
    /// The photos retrieved as part of this request.
    public let photos: [StockPhoto]
    /**
     A token that can be used to provide information required to retrieve the next page, such as the last photo's ID or the offset from the previous request.
     
     If not provided, pagination cannot be performed, such as if a service does not perform pagination or has reached the end of the returnable photos.
     */
    public let paginationToken: String?
}
