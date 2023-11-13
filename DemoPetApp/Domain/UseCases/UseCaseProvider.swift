//
//  UseCaseProvider.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation

protocol UseCaseProvider {
    func makeAnimalsUseCase() -> AnimalsUseCase
}

struct DefaultUseCaseProvider: UseCaseProvider {
    func makeAnimalsUseCase() -> AnimalsUseCase {
        let remote = Remote("https://api.petfinder.com/v2/")
        let remoteRepository = RemoteAnimalsRepository(remote: remote)
        return DefaultAnimalUseCase(repository: remoteRepository)
    }
}
