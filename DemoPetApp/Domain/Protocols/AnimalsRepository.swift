//
//  AnimalsRepository.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 11.11.2023.
//

import Foundation
import RxSwift

protocol AnimalsRepository {
    func fetchAnimals() -> Observable<[Animal]>
    func fetchDetails(for animal: Animal) -> Observable<Animal>
}
