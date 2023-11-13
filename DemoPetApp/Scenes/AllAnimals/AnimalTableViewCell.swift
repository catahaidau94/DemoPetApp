//
//  AnimalTableViewCell.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 11.11.2023.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func bind(_ viewModel: AnimalViewModel) {
        self.nameLabel.text = viewModel.name
    }
}
