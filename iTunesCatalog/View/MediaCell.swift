//
//  MediaCell.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

final class MediaCell: UITableViewCell {
    @IBOutlet private var artwork: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var genre: UILabel!
    @IBOutlet private var url: UILabel!
    
    func configureWith(media: Media) {
        self.title.text = media.name
        self.genre.text = media.genre
        self.url.text = media.url.absoluteString
        
        guard let artworkURL = media.artwork else {
            return
        }
        
        AF.request(artworkURL).responseImage {[weak self] (response) in
            guard let self = self else {
                return
            }
            
            if case let .success(image) = response.result {
                self.artwork.image = image
            }
        }
        
    }
}
