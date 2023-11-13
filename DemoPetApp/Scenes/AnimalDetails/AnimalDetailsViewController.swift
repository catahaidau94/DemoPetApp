//
//  AnimalDetailsViewController.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class AnimalDetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var viewModel: AnimalDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = AnimalDetailsViewModel.Input(trigger: viewWillAppear)
        let output = viewModel.transform(input: input)

        output.animal.drive(animalBinding).disposed(by: disposeBag)
        output.error.drive(errorBinding).disposed(by: disposeBag)
    }

    var animalBinding: Binder<Animal> {
        return Binder(self, binding: { (vc, animal) in
            vc.nameLabel.text = animal.name
            vc.breedLabel.text = animal.breeds.primary
            vc.sizeLabel.text = animal.size
            vc.genderLabel.text = animal.gender
            vc.statusLabel.text = animal.status
            vc.distanceLabel.text = animal.distance != nil ? String(animal.distance!) : "N/A"
        })
    }

    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            // show alert based on received error
            let alert = UIAlertController(title: "Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}
