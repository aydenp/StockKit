//
//  StockPhotoSearchManager.swift
//  Stock MessagesExtension
//
//  Created by Ayden Panhuyzen on 2019-07-20.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

private let blacklistedServiceIdentifiersDefaultsKey = "blacklistedServices"

public class StockPhotoSearchManager {
    public static let shared = StockPhotoSearchManager()
    private init() {}
    
    public func search(intent: SearchIntent, completion: @escaping StockPhotoSearchCompletionBlock) {
        let service = allServices[intent.allServicesIndex]
        intent._request = service.search(with: intent.query, count: idealSearchResultsCountPerService, after: intent.paginationToken, completion: completion)
    }
    
    public func getStartingIntents(for query: String) -> [SearchIntent] {
        return allServices.enumerated()
            .filter { !blacklistedServiceIdentifiers.contains(type(of: $0.element).identifier) }
            .shuffled()
            .map { (index, _) in SearchIntent(query: query, paginationToken: nil, allServicesIndex: index) }
    }
    
    // MARK: - Services & Availability
    
    public let allServices: [StockPhotoService] = [ShutterstockService(), BigstockPhotoService(), iStockPhotoService(), AdobeService()]
    
    public var blacklistedServiceIdentifiers: Set<String> {
        get { return Set(UserDefaults.standard.array(forKey: blacklistedServiceIdentifiersDefaultsKey) as? [String] ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: blacklistedServiceIdentifiersDefaultsKey) }
    }
    
    /// The ideal amount of search results to have returned after loading is complete
    public var idealSearchResultsCount = 40
    
    private var idealSearchResultsCountPerService: Int {
        return max(3, idealSearchResultsCount / (allServices.count - blacklistedServiceIdentifiers.count))
    }
}

extension StockPhotoSearchManager {
    public class SearchIntent: NSObject {
        let query: String, paginationToken: String?
        fileprivate let allServicesIndex: Int
        fileprivate var _request: StockPhotoSearchRequest?
        
        init(query: String, paginationToken: String?, allServicesIndex: Int) {
            self.query = query
            self.paginationToken = paginationToken
            self.allServicesIndex = allServicesIndex
        }
        
        public func createNextPaginationIntent(paginationToken: String) -> SearchIntent {
            return SearchIntent(query: query, paginationToken: paginationToken, allServicesIndex: allServicesIndex)
        }
        
        public func cancel() {
            _request?.cancel()
        }
    }
}
