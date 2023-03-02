//
//  AvengerDetailTableViewCell.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/2/23.
//

import UIKit

class AvengerDetailTableViewCell: UITableViewCell {

    //MARK: - OUTLETS
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!
    
    
    //MARK: - FUNCTIONS
    override func prepareForReuse() {
        super.prepareForReuse()
        comicTitleLabel.text = nil
        comicImageView.image = nil
    }
    
    
    func updateUI(forComic comic: Comic) {
        comicTitleLabel.text = comic.comicTitle
        ComicService.fetchComicThumbnail(forComic: comic) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.comicImageView.image = image
                }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unknownError)
            }
        }
    }
}
