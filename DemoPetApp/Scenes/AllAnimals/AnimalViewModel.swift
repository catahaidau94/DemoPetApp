//
//  AnimalViewModel.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 11.11.2023.
//

import Foundation

class AnimalViewModel {
    let animal: Animal
    let name: String
    
    init(with animal: Animal) {
        self.animal = animal
        self.name = animal.name
    }
}
