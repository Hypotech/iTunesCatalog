//
//  SearchCatalogVC.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchCatalogVC: UIViewController {
    var favorites: [Media] {
        return viewModel.favorites
    }

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var disposeBag = DisposeBag()
    private let viewModel = SearchCatalogViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        view.bringSubviewToFront(activityIndicator)

        searchBar.searchTextField.delegate = self
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] (searchTerm) in
                self?.activityIndicator.startAnimating()
                
                self?.viewModel.searchMediaWith(keyword: searchTerm) {
                    guard let self = self else {
                        return
                    }
                                        
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesShowSegue" {
            let destination = segue.destination as! FavoritesVC
             destination.configureWith(favorites: self.favorites)
        }
    }
    
    @IBAction func fooUnWindAction(unwindSegue: UIStoryboardSegue) {
        
    }
}

//MARK: - UITableViewDataSource
extension SearchCatalogVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(at: section)
    }
}

//MARK: - UITableViewDelegate
extension SearchCatalogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCellId", for: indexPath) as! MediaCell
        
        cell.favoriteHandler = {
            self.viewModel.toggleFavorite(at: indexPath)
        }
        
        let media = viewModel.media(at: indexPath)
        
        cell.configureWith(media: media)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = {
            let lb = UILabel()
            lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lb.backgroundColor = #colorLiteral(red: 0.9371626377, green: 0.9373196363, blue: 0.9414473176, alpha: 1)
            lb.frame = CGRect(x: 8, y: 0, width: self.view.frame.width - 16, height: 30)
            
            return lb
        }()
        
        label.text = viewModel.titleForSection(at: section)

        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let media = viewModel.media(at: indexPath)
        
        UIApplication.shared.open(media.url, options: [:], completionHandler: nil)
    }
}


//MARK: - UITextFieldDelegate
extension SearchCatalogVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
