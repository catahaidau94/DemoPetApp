//
//  ViewModelType.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
