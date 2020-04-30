//
//  SearchCatalogViewModel.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import Foundation

final class SearchCatalogViewModel {
    var numberOfSections: Int {
        return sections.count
    }
    private(set) var favorites = [Media]()
    
    private var sections = [Section]()
    private let api = API()

    func searchMediaWith(keyword: String, completion:@escaping (() -> Void)) {
        api.searchTerm(keyword) {[weak self] (response) in
            guard let self = self else {
                return
            }
            
            self.sections.removeAll()

            if !response.albums.isEmpty {
                let sectionTitle = "Albums"
                self.sections.append(Section(title: sectionTitle, rows: response.albums))
            }
            
            if !response.songs.isEmpty {
                let sectionTitle = "Songs"
                self.sections.append(Section(title: sectionTitle, rows: response.songs))
            }

            if !response.books.isEmpty {
                let sectionTitle = "Books"
                self.sections.append(Section(title: sectionTitle, rows: response.books))
            }

            if !response.coached_audios.isEmpty {
                let sectionTitle = "Coached audios"
                self.sections.append(Section(title: sectionTitle, rows: response.coached_audios))
            }
            
            if !response.interactive_booklets.isEmpty {
                let sectionTitle = "Interactive booklets"
                self.sections.append(Section(title: sectionTitle, rows: response.interactive_booklets))
            }

            if !response.music_videos.isEmpty {
                let sectionTitle = "Music videos"
                self.sections.append(Section(title: sectionTitle, rows: response.music_videos))
            }
            
            if !response.pdfs.isEmpty {
                let sectionTitle = "PDFs"
                self.sections.append(Section(title: sectionTitle, rows: response.pdfs))
            }
            
            if !response.podcasts.isEmpty {
                let sectionTitle = "Podcasts"
                self.sections.append(Section(title: sectionTitle, rows: response.podcasts))
            }
            
            if !response.podcast_episodes.isEmpty {
                let sectionTitle = "podcast episodes"
                self.sections.append(Section(title: sectionTitle, rows: response.podcast_episodes))
            }
            
            if !response.software_packages.isEmpty {
                let sectionTitle = "software packages"
                self.sections.append(Section(title: sectionTitle, rows: response.software_packages))
            }
            
            if !response.featured_movies.isEmpty {
                let sectionTitle = "Featured movies"
                self.sections.append(Section(title: sectionTitle, rows: response.featured_movies))
            }
            
            if !response.unknown.isEmpty {
                let sectionTitle = "Unknown"
                self.sections.append(Section(title: sectionTitle, rows: response.unknown))
            }
            
            completion()
        }
    }
    
    func numberOfRowsInSection(at index: Int) -> Int {
        guard (sections.startIndex..<sections.endIndex).contains(index) else {
            return 0
        }

        return sections[index].rows.count
    }
    
    func titleForSection(at index: Int) -> String? {
        guard (sections.startIndex..<sections.endIndex).contains(index) else {
            return nil
        }
        
        return sections[index].title
    }
    
    func media(at index: IndexPath) -> Media {
        return sections[index.section].rows[index.row]
    }
    
    func toggleFavorite(at index: IndexPath) {
        let media = sections[index.section].rows[index.row]
            
        media.favorite.toggle()
        
        if media.favorite {
            favorites.append(media)
        }
        else {
            let possibleIdex = favorites.firstIndex {
                $0.id == media.id
            }
            
            guard let index = possibleIdex else {
                return
            }
            
            favorites.remove(at: index)
        }
    }
}


final class Section {
    var title: String
    var rows: [Media]
    
    init(title: String, rows: [Media]) {
        self.title = title
        self.rows = rows
    }
}
