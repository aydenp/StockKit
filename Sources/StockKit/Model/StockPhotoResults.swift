//
//  StockPhotoResults.swift
//  StockKit
//
//  Created by Ayden Panhuyzen on 2020-01-04.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Foundation

public struct StockPhotoResults {
    /// The photos retrieved as part of this request.
    public let photos: [StockPhoto]
    
    /**
     A token that can be used to provide information required to retrieve the next page, such as the last photo's ID or the offset from the previous request.
     
     If not provided, pagination cannot be performed, such as if a service does not perform pagination or has reached the end of the returnable photos.
     */
    public let paginationToken: String?
}
