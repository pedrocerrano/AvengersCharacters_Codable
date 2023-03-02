//
//  AvengerDetailVC.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import UIKit

class AvengerDetailVC: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var avengerImageView: UIImageView!
    @IBOutlet weak var avengerNameLabel: UILabel!
    @IBOutlet weak var comicsApperingInLabel: UILabel!
    @IBOutlet weak var comicListTableView: UITableView!
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        comicListTableView.dataSource = self
        comicListTableView.delegate = self
        updateUI()
    }
    
    
    //MARK: - PROPERTIES
    var avenger: Avenger?
    
    
    //MARK: - FUNCTIONS
    func updateUI() {
        guard let avenger = avenger else { return }
        AvengerService.fetchAvengerImage(forAvenger: avenger) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.avengerImageView.image     = image
                    self?.avengerNameLabel.text      = avenger.avengerName.uppercased()
                    self?.comicsApperingInLabel.text = "Appears in \(avenger.avengerComics.available) comics:"
                }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unknownError)
            }
        }
    }
} //: CLASS


//MARK: - EXT: TableView DataSource
extension AvengerDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicListTableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath)
        
        return cell
    }
    
    
}
