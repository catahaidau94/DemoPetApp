//
//  AllAnimalsRemote.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
//import RxSwift

final class AllAnimalsRemote {
    private let remote: Remote<Animal>

    init(remote: Remote<Animal>) {
        self.remote = remote
    }

    func fetchAllAnimals() -> [Animal] {
        return remote.getItems("animals")
    }
}
