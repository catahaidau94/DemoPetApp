//
//  AnimalsViewModelTests.swift
//  DemoPetAppTests
//
//  Created by Catalin Haidau on 13.11.2023.
//

import XCTest
import Foundation
import RxSwift
@testable import DemoPetApp

class AnimalsViewModelTests: XCTestCase {
    
    var animalsUseCase: AnimalsUseCaseMock!
    var animalsNavigator: AnimalsNavigatorMock!
    var viewModel: AnimalsViewModel!
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        animalsUseCase = AnimalsUseCaseMock()
        animalsNavigator = AnimalsNavigatorMock()
        
        viewModel = AnimalsViewModel(useCase: animalsUseCase,
                                     navigator: animalsNavigator)
    }
    
    func test_transform_triggerInvoked_allAnimalsEmited() {
        // arrange
        let trigger = PublishSubject<Void>()
        let input = createInput(trigger: trigger)
        let output = viewModel.transform(input: input)
        
        // act
        output.animals.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        // assert
        XCTAssert(animalsUseCase.allAnimalsCalled)
    }
    
    func test_transform_trackFetching() {
        // arrange
        let trigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(trigger: trigger))
        let expectedFetching = [true, false]
        var actualFetching: [Bool] = []
        
        // act
        output.fetching
            .do(onNext: { actualFetching.append($0) },
                onSubscribe: { actualFetching.append(true) })
            .drive()
            .disposed(by: disposeBag)
        
        trigger.onNext(())
        
                // assert
                XCTAssertEqual(actualFetching, expectedFetching)
                }
    
    func test_transform_emitError_trackError() {
        // arrange
        let trigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(trigger: trigger))
        animalsUseCase.allAnimalsReturnValue = Observable.error(TestError.test)
        
        var recordedEvent: Event<Error>? = nil
        let errorObserver: AnyObserver<Error> = AnyObserver { event in
            recordedEvent = event
        }
        // act
        output.animals.drive().disposed(by: disposeBag)
        output.error.drive(errorObserver).disposed(by: disposeBag)
        trigger.onNext(())
        
        let error = recordedEvent?.element
        
        // assert
        XCTAssertNotNil(error)
    }
    
    func test_transform_triggerInvoked_mapAnimalsToViewModels() {
        // arrange
        let trigger = PublishSubject<Void>()
        let output = viewModel.transform(input: createInput(trigger: trigger))
        animalsUseCase.allAnimalsReturnValue = Observable.just(createAnimals())
        
        var recordedEvent: Event<[AnimalViewModel]>? = nil
        let observer: AnyObserver<[AnimalViewModel]> = AnyObserver { event in
            recordedEvent = event
        }
        // act
        output.animals.drive(observer).disposed(by: disposeBag)
        trigger.onNext(())
        
        // assert
        XCTAssertEqual(recordedEvent?.element?.count, 2)
    }
    
    func test_transform_selectedAnimalInvoked_navigateToAnimalDetails() {
        // arrange
        let select = PublishSubject<IndexPath>()
        let output = viewModel.transform(input: createInput(selection: select))
        let animals = createAnimals()
        animalsUseCase.allAnimalsReturnValue = Observable.just(animals)
        
        // act
        output.animals.drive().disposed(by: disposeBag)
        output.selectedAnimal.drive().disposed(by: disposeBag)
        select.onNext(IndexPath(row: 1, section: 0))
        
        // assert
        XCTAssertTrue(animalsNavigator.toAnimalDetailsCalled)
        XCTAssertEqual(animalsNavigator.toAnimalDetailsParameter?.id, animals[1].id)
        XCTAssertEqual(animalsNavigator.toAnimalDetailsParameter?.name, animals[1].name)
        XCTAssertEqual(animalsNavigator.toAnimalDetailsParameter?.gender, animals[1].gender)
        XCTAssertEqual(animalsNavigator.toAnimalDetailsParameter?.status, animals[1].status)
    }
    
    private func createInput(trigger: Observable<Void> = Observable.just(()),
                             selection: Observable<IndexPath> = Observable.never()) -> AnimalsViewModel.Input {
        return AnimalsViewModel.Input(
            trigger: trigger.asDriverOnErrorJustComplete(),
            selection: selection.asDriverOnErrorJustComplete())
    }
    
    private func createAnimals() -> [Animal] {
        return [
            Animal(id: 1,
                   breeds: Breeds(primary: "breed", secondary: nil),
                   gender: "gender",
                   size: "size",
                   name: "name",
                   status: "status",
                   distance: 10),
            Animal(id: 2,
                   breeds: Breeds(primary: "breed", secondary: nil),
                   gender: "gender",
                   size: "size",
                   name: "name",
                   status: "status",
                   distance: 10)
        ]
    }
}

enum TestError: Error {
    case test
}
