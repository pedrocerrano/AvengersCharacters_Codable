//
//  AvengerListTableViewCell.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import UIKit

class AvengerListTableViewCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var avengerNameLabel: UILabel!
    @IBOutlet weak var avengerImageView: UIImageView!
    
    
    //MARK: - FUNCTIONS
    override func prepareForReuse() {
        super.prepareForReuse()
        avengerNameLabel.text  = nil
        avengerImageView.image = nil
    }
    
    
    func updateUI(forAvenger avenger: Avenger) {
        avengerNameLabel.text = avenger.avengerName
        fetchAvengerImage(forAvenger: avenger)
    }
    
    
    func fetchAvengerImage(forAvenger avenger: Avenger) {
        AvengerService.fetchAvengerImage(forAvenger: avenger) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.avengerImageView.image = image
                }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unknownError)
            }
        }
    }
}

