//
//  Result.swift
//  BucketList
//
//  Created by Maks Winters on 09.01.2024.
//

import Foundation

enum LoadingState {
    case loading, loaded, failed
}

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No description available"
    }
    
}
