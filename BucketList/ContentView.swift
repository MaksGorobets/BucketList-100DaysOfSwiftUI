//
//  ContentView.swift
//  BucketList
//
//  Created by Maks Winters on 02.01.2024.
//

import SwiftUI

struct User: Identifiable, Comparable, Hashable, Codable {
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    var id = UUID()
    let firstName: String
    let lastName: String
    
}

struct ContentView: View {
    let users = [
        User(firstName: "Taylor", lastName: "Swift"),
        User(firstName: "Mike", lastName: "Tyson"),
        User(firstName: "Joe", lastName: "Rogan")
    ].sorted()
    
    @State private var readFile: User?
    
    var body: some View {
        ForEach(users) { user in
            Button("Write user \(user.firstName)") {
                FileManager.default.write(object: user, to: "user")
            }
        }
        Button("Read file") {
            do {
                readFile = try FileManager.default.read(from: "user")
            } catch {
                
            }
        }
        if readFile != nil {
            Text(readFile?.firstName ?? "None")
        }
    }
}

#Preview {
    ContentView()
}
