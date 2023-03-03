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
    var comicTopLevel: ComicTopLevelDictionary?
    var comics: [Comic] = []
    var offset = 0
    
    
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
        
        fetchComicList(forAvenger: avenger)
    }
    
    
    func fetchComicList(forAvenger avenger: Avenger) {
        ComicService.fetchComicList(offset: String(offset), forAvenger: avenger) { [weak self] result in
            switch result {
            case .success(let topLevel):
                self?.comicTopLevel = topLevel
                self?.comics = topLevel.comicListData.comicResults
                DispatchQueue.main.async {
                    self?.comicListTableView.reloadData()
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
        return comics.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicListTableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as? AvengerDetailTableViewCell else { return UITableViewCell() }
        
        let comic = comics[indexPath.row]
        cell.updateUI(forComic: comic)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let avenger = avenger else { return }
        
        if indexPath.row == comics.count - 1 {
            offset += 50
            ComicService.fetchComicList(offset: String(offset), forAvenger: avenger) { [weak self] result in
                switch result {
                case .success(let comicTopLevel):
                    self?.comicTopLevel = comicTopLevel
                    let additionalComics = comicTopLevel.comicListData.comicResults
                    self?.comics.append(contentsOf: additionalComics)
                    DispatchQueue.main.async {
                        self?.comicListTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.errorDescription ?? Constants.Error.unknownError)
                }
            }
        }
    }
}
