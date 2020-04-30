//
//  ViewController.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private let viewModel = SearchCatalogViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.searchTextField.delegate = self
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] (searchTerm) in
                self?.viewModel.searchMediaWith(keyword: searchTerm) {
                    guard let self = self else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
    }

}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(at: section)
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCellId", for: indexPath) as! MediaCell
        
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
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
