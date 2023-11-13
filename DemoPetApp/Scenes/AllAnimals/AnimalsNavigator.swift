//
//  AnimalsNavigator.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import UIKit

protocol AnimalsNavigator {
    func toAnimalDetails(_ animal: Animal)
    func toAllAnimals()
}

class DefaultAnimalsNavigator: AnimalsNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider

    init(services: UseCaseProvider,
         navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toAllAnimals() {
        let vc = storyBoard.instantiateViewController(ofType: AnimalsViewController.self)
        vc.viewModel = AnimalsViewModel(useCase: services.makeAnimalsUseCase(),
                                      navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAnimalDetails(_ animal: Animal) {
        let navigator = DefaultAnimalDetailsNavigator(navigationController: navigationController)
        let viewModel = AnimalDetailsViewModel(animal: animal, useCase: services.makeAnimalsUseCase(), navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: AnimalDetailsViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
