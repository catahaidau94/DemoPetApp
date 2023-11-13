//
//  AnimalsViewModel.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
import RxSwift
import RxCocoa

class AnimalsViewModel: ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let animals: Driver<[AnimalViewModel]>
        let selectedAnimal: Driver<Animal>
        let error: Driver<Error>
    }

    private let useCase: AnimalsUseCase
    private let navigator: AnimalsNavigator

    init(useCase: AnimalsUseCase, navigator: AnimalsNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let animals = input.trigger.flatMapLatest {
            return self.useCase
                .allAnimals()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { AnimalViewModel(with: $0) } }
        }

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedAnimal = input.selection
            .withLatestFrom(animals) { (indexPath, animals) -> Animal in
                return animals[indexPath.row].animal
            }
            .do(onNext: navigator.toAnimalDetails)

        return Output(fetching: fetching,
                      animals: animals,
                      selectedAnimal: selectedAnimal,
                      error: errors)
    }
}
