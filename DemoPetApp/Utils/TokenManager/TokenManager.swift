//
//  TokenManager.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 12.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

class TokenManager {
    static let shared = TokenManager()
    
    var token: Token?
    
    var accessToken: String {
        return token?.accessToken ?? ""
    }
    
    init() {}
}
