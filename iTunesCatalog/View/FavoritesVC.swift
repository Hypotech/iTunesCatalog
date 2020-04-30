//
//  FavoritesVC.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    @IBOutlet private  var tableView: UITableView!
    private var favorites = [Media]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func configureWith(favorites: [Media]) {
        self.favorites = favorites
    }
}

//MARK: - UITableViewDataSource
extension FavoritesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
}

//MARK: - UITableViewDelegate
extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCellId", for: indexPath) as! FavoritesCell
        
        let media = favorites[indexPath.row]
        
        cell.configureWith(media: media)
        
        return cell
    }
}
