//
//  AnimalDetailsViewModel.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class AnimalDetailsViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let animal: Driver<Animal>
        let error: Driver<Error>
    }
    
    private let animal: Animal
    private let useCase: AnimalsUseCase
    private let navigator: AnimalDetailsNavigator
    
    init(animal: Animal, useCase: AnimalsUseCase, navigator: AnimalDetailsNavigator) {
        self.animal = animal
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
///         Usually you do not get all the details when fetching a list of items,
///         so by uncommenting these lines you basically call animals/{id} to get all details for a specific animal
///         and also remove .just() from Output
//        let animal = input.trigger.flatMapLatest {
//            return self.useCase
//                .animalDetails(for: self.animal)
//                .trackError(errorTracker)
//                .asDriverOnErrorJustComplete()
//        }

        let errors = errorTracker.asDriver()
        
        return Output(animal: .just(animal),
                      error: errors)
    }
}
