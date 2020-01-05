//
//  StockPhotoSearchRequest.swift
//  StockKit
//
//  Created by Ayden Panhuyzen on 2020-01-04.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Foundation

/// Optional methods on the search request being made, such as cancellation.
public protocol StockPhotoSearchRequest {
    /// A method which will cancel the running request, if necessary.
    func cancel()
}

/// A pre-made search request that allows you to create a custom completion handler representing a network search's data task.
public class StockPhotoSearchNetworkRequest: StockPhotoSearchRequest {
    let dataTask: URLSessionDataTask
    
    init(dataTask: URLSessionDataTask) {
        self.dataTask = dataTask
        dataTask.resume()
    }
    
    convenience init(urlRequest: URLRequest, completion: @escaping (Result<Data, Error>, URLResponse?) -> Void) {
        self.init(dataTask: URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else { completion(.failure(error ?? StockPhotoSearchError.noData), response); return }
            completion(.success(data), response)
        })
    }
    
    convenience init(url: URL, completion: @escaping (Result<Data, Error>, URLResponse?) -> Void) {
        self.init(urlRequest: URLRequest(url: url), completion: completion)
    }
    
    convenience init<T: Decodable>(jsonType: T.Type, urlRequest: URLRequest, completion: @escaping (Result<T, Error>, URLResponse?) -> Void) {
        self.init(urlRequest: urlRequest, completion: { (result, response) in
            do {
                let data = try result.get()
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded), response)
            } catch let error {
                completion(.failure(error), response)
            }
        })
    }

    convenience init<T: Decodable>(jsonType: T.Type,url: URL, completion: @escaping (Result<T, Error>, URLResponse?) -> Void) {
        self.init(jsonType: jsonType, urlRequest: URLRequest(url: url), completion: completion)
    }
    
    convenience init<T: Decodable & StockPhotoResultsProviding>(jsonResultsProvidingType: T.Type, urlRequest: URLRequest, completion: @escaping (Result<StockPhotoResults, Error>) -> Void) {
        self.init(jsonType: T.self, urlRequest: urlRequest, completion: { (result, response) in
            switch result {
            case .success(let response): completion(.success(response.results))
            case .failure(let error): completion(.failure(error))
            }
        })
    }
    
    convenience init<T: Decodable & StockPhotoResultsProviding>(jsonResultsProvidingType: T.Type,url: URL, completion: @escaping (Result<StockPhotoResults, Error>) -> Void) {
        self.init(jsonResultsProvidingType: jsonResultsProvidingType, urlRequest: URLRequest(url: url), completion: completion)
    }
    
    public func cancel() {
        dataTask.cancel()
    }
}

public protocol StockPhotoResultsProviding {
    var results: StockPhotoResults { get }
}

public enum StockPhotoSearchError: Error {
    /// No data was retrieved during the search, but there is no more approprate error to display.
    case noData
    /// An unknown error occurred during deserialization.
    case deserializationError
    /// A URL could not be formed to create a network request.
    case noValidURL
}
