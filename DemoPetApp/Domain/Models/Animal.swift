//
//  Animal.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation

struct Animal: Codable {
    let id: Int
    let breeds: Breeds
    let gender: String?
    let size: String?
    let name: String
    let status: String?
    let distance: Int?
}

// MARK: - Breeds
struct Breeds: Codable {
    let primary: String?
    let secondary: String?
}
