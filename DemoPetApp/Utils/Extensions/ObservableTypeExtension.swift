//
//  ObservableTypeExtension.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 12.11.2023.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
