//
//  AnimalDetailsNavigator.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import UIKit

protocol AnimalDetailsNavigator {
    func toAllAnimals()
}

final class DefaultAnimalDetailsNavigator: AnimalDetailsNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toAllAnimals() {
        navigationController.popViewController(animated: true)
    }
}
