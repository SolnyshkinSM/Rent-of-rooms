//
//  AppGroup.swift
//  Rent of rooms
//
//  Created by Administrator on 10.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import Foundation

var collectionFeedResult = Array<FeedResult>()
var cacheImage = NSCache<FeedResult, AnyObject>()

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

class FeedResult: Decodable {
    var name = ""
    var artworkUrl100 = ""
    var artistUrl = ""
}
