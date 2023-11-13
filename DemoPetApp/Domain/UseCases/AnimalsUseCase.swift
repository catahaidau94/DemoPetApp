//
//  AnimalsUseCase.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol AnimalsUseCase {
    func allAnimals() -> Observable<[Animal]>
    func animalDetails(for animal: Animal) -> Observable<Animal>
}

struct DefaultAnimalUseCase: AnimalsUseCase {
    let repository: AnimalsRepository
    
    func allAnimals() -> Observable<[Animal]> {
        repository.fetchAnimals()
    }
    
    func animalDetails(for animal: Animal) -> Observable<Animal> {
        repository.fetchDetails(for: animal)
    }
}
