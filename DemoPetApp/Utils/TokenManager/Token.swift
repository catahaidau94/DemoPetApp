//
//  Token.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 12.11.2023.
//

import Foundation

// MARK: - Token
struct Token: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
            
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
}

