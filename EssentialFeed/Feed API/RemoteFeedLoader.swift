//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Chris Mauldin on 8/8/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader { 
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case let .success(data, response):
                    if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.items))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure(_):
                    completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}


/*
 --- func returnError(error: Error) -> Int {
 }
 
 --- (error: Error) -> Int
 
 --- (Error) -> Int
 
 --- { error in }
 
 FUNCTION DEFINITION
 
 --- func load(completion: (Error) -> Void) {}
 
 --- func load(completion: returnError)
 
 FUNCTION INVOKATION
 
 --- func load { error in }
 
 
 
 sorted(by: (Self.Element, Self.Element) -> Bool)
 */


