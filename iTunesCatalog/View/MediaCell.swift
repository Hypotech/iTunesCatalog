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
import RxCocoa
import RxSwift

final class MediaCell: UITableViewCell {
    var favoriteHandler: (() -> Void)?
    
    @IBOutlet private var artwork: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var genre: UILabel!
    @IBOutlet private var url: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    private var isFavorite = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    private var media: Media?

    override func awakeFromNib() {
        isFavorite.asObservable().subscribe (onNext: {
            let image = $0 ? UIImage(systemName: "star.fill") :
                UIImage(systemName: "star")
            
            self.favoriteButton.setImage(image, for: .normal)

        }).disposed(by: disposeBag)
    }
    
    func configureWith(media: Media) {
        self.media = media

        self.title.text = media.name
        self.genre.text = media.genre
        self.url.text = media.url.absoluteString
        self.isFavorite.accept(media.favorite)
        
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
    @IBAction func didSelectFavoriteButton(button: UIButton) {
        guard let media = media else {
            return
        }
        
        self.isFavorite.accept(!media.favorite)
        
        self.favoriteHandler?()
    }
}
