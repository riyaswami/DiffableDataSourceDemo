//
//  DataModel.swift
//  Demo List
//
//  Created by riyaswami on 21/12/23.
//

import Foundation

import Foundation

// MARK: - TodoObject
struct TodoObject: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}

