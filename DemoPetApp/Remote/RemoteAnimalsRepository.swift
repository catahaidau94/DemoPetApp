//
//  RemoteAnimalsUseCase.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
import RxSwift

final class RemoteAnimalsRepository: AnimalsRepository {
        
    private let remote: Remote

    init(remote: Remote) {
        self.remote = remote
    }

    func fetchAnimals() -> Observable<[Animal]> {
        return remote.getItems("animals")
    }
    
    func fetchDetails(for animal: Animal) -> Observable<Animal> {
        return remote.getItem("animals", itemId: animal.id)
    }
}
