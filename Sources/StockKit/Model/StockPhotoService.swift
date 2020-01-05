//
//  StockPhotoService.swift
//  Stock MessagesExtension
//
//  Created by Ayden Panhuyzen on 2019-07-19.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

public protocol StockPhotoService: class {
    /// An internal identifier for this service.
    static var identifier: String { get }
    
    /// The user-friendly name of this stock photo service (e.g. Shutterstock).
    static var name: String { get }
    
    /**
    Get stock photos with the provided information.

    - parameter query: The string to query the service with.
    - parameter paginationToken: If applicable, a token with context about pagination, from the last retrieved results. See more on `StockPhotoResults.paginationToken`.
    - parameter completion: A block to run on completion.
     
     - returns: An object representing the search request being made. See `StockPhotoSearchRequest`.
         */
    func search(with query: String, count: Int, after paginationToken: String?, completion: @escaping StockPhotoSearchCompletionBlock) -> StockPhotoSearchRequest?
}

public typealias StockPhotoSearchCompletionBlock = (Result<StockPhotoResults, Error>) -> Void
