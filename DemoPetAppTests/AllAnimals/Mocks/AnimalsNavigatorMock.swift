//
//  AnimalsNavigatorMock.swift
//  DemoPetAppTests
//
//  Created by Catalin Haidau on 13.11.2023.
//

import Foundation
import RxSwift
@testable import DemoPetApp

class AnimalsNavigatorMock: AnimalsNavigator {
    
    var toAllAnimalsCalled = false
    func toAllAnimals() {
        toAllAnimalsCalled = true
    }
    
    var toAnimalDetailsCalled = false
    var toAnimalDetailsParameter: Animal?
    func toAnimalDetails(_ animal: DemoPetApp.Animal) {
        toAnimalDetailsCalled = true
        toAnimalDetailsParameter = animal
    }
}
