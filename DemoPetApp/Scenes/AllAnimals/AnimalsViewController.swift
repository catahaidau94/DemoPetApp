//
//  AnimalsViewController.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import UIKit
import RxSwift
import RxCocoa

class AnimalsViewController: UIViewController {
    private let disposeBag = DisposeBag()

    var viewModel: AnimalsViewModel!
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }

    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .take(1) // remove this to call API everytime you enter the screen
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        let input = AnimalsViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                       selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        //Bind table view data
        output.animals.drive(tableView.rx.items(cellIdentifier: AnimalTableViewCell.reuseID,
                                                cellType: AnimalTableViewCell.self)) { tableView, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.selectedAnimal
            .drive()
            .disposed(by: disposeBag)
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            var message = ""
            switch error {
            case ServiceError.cannotParse:
                message = "Cannot parse response"
            case ServiceError.invalidURL:
                message = "Invalid URL"
            default:
                message = error.localizedDescription
            }
            
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}
