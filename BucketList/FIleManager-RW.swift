//
//  FIleManager-RW.swift
//  BucketList
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation

extension FileManager {
    enum Errors: Error {
        case readFailure
    }
    
    func write<T: Codable>(object: T, to fileName: String) {
        let url = URL.documentsDirectory.appending(path: "\(fileName).txt")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print(error)
        }
    }
    
    func read<T: Codable>(from fileName: String) throws -> T {
        let url = URL.documentsDirectory.appending(path: "\(fileName).txt")
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            print(error)
        }
        throw Errors.readFailure
    }
}
