//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Chris Mauldin on 8/7/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}
protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
