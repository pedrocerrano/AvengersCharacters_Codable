//
//  AvengerListViewController.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import UIKit

class AvengerListViewController: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var avengersListTableView: UITableView!
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        avengersListTableView.dataSource = self
        avengersListTableView.delegate = self
        fetchAvengerList()
    }
    
    
    //MARK: - PROPERTIES
    var topLevel: AvengersListTopLevelDictionary?
    var avengers: [Avenger] = []
    var offset = 0
    
    
    //MARK: - FUNCTIONS
    func fetchAvengerList() {
        AvengerService.fetchAvengerList(paginationOffset: String(offset)) { [weak self] result in
            switch result {
            case .success(let topLevel):
                self?.topLevel = topLevel
                self?.avengers = topLevel.listData.listResults.filter ({ avenger in
                    !avenger.avengerImage.imagePath.contains("image_not_available")
                    && !avenger.avengerImage.imageExtention.contains("gif")
                    && avenger.avengerComics.available != 0
                })
                
                DispatchQueue.main.async {
                    self?.avengersListTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unknownError)
            }
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAvengerDetailVC" {
            guard let index = avengersListTableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? AvengerDetailVC else { return }
            let avenger = avengers[index.row]
            destinationVC.avenger = avenger
        }
    }
} //: CLASS


//MARK: - EXT: TableView DataSource
extension AvengerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avengers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "avengerCell", for: indexPath) as? AvengerListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let avenger = avengers[indexPath.row]
        cell.updateUI(forAvenger: avenger)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == avengers.count - 1 {
            offset += 50
            AvengerService.fetchAvengerList(paginationOffset: String(offset)) { [weak self] result in
                switch result {
                case .success(let topLevel):
                    self?.topLevel = topLevel
                    let newAvengers = topLevel.listData.listResults.filter ({ avenger in
                        !avenger.avengerImage.imagePath.contains("image_not_available") && !avenger.avengerImage.imageExtention.contains("gif")
                    })
                    self?.avengers.append(contentsOf: newAvengers)
                    DispatchQueue.main.async {
                        self?.avengersListTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.errorDescription ?? Constants.Error.unknownError)
                }
            }
        }
    }
}
