//
//  AnimalsUseCaseMock.swift
//  DemoPetAppTests
//
//  Created by Catalin Haidau on 13.11.2023.
//

import Foundation
import RxSwift
@testable import DemoPetApp

class AnimalsUseCaseMock: AnimalsUseCase {
    
    var allAnimalsCalled = false
    var allAnimalsReturnValue: Observable<[Animal]> = .just([])
    func allAnimals() -> RxSwift.Observable<[DemoPetApp.Animal]> {
        allAnimalsCalled = true
        return allAnimalsReturnValue
    }
    
    var animalDetailsCalled = false
    func animalDetails(for animal: DemoPetApp.Animal) -> RxSwift.Observable<DemoPetApp.Animal> {
        animalDetailsCalled = true
        return .just(mockAnimal())
    }
    
    private func mockAnimal() -> Animal {
        return Animal(id: 0,
                      breeds: Breeds(primary: "breed", secondary: nil),
                      gender: "gender",
                      size: "size",
                      name: "name",
                      status: "status",
                      distance: 10)
    }
}
