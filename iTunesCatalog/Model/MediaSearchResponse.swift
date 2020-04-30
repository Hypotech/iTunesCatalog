//
//  MediaSearchResponse.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import Foundation

struct MediaSearchResponse: Equatable, Identifiable {
    let id = UUID().uuidString
    var books  = [Media]()
    var albums  = [Media]()
    var coached_audios  = [Media]()
    var interactive_booklets  = [Media]()
    var music_videos  = [Media]()
    var pdfs  = [Media]()
    var podcasts  = [Media]()
    var podcast_episodes  = [Media]()
    var software_packages  = [Media]()
    var songs  = [Media]()
    var featured_movies = [Media]()
    var unknown = [Media]()
    
    init(results: [[String: Any]]) {
        for result in results {
            let kind = result["kind"] as? String ?? "unknown"
            let media = MediaSearchResponse.convertToMedia(result: result)

            if kind == "book" {
                books.append(media)
            }
            
            if kind == "album" {
                albums.append(media)
            }
            
            if kind == "coached-audio" {
                coached_audios.append(media)
            }
            
            if kind == "interactive-booklet" {
                interactive_booklets.append(media)
            }
            
            if kind == "music-video" {
                music_videos.append(media)
            }
            
            if kind == "pdf" {
                pdfs.append(media)
            }
            
            if kind == "podcast" {
                podcasts.append(media)
            }
            
            if kind == "podcast-episode" {
                podcast_episodes.append(media)
            }
            
            if kind == "software-package" {
                software_packages.append(media)
            }

            if kind == "featured-movie" {
                featured_movies.append(media)
            }

            if kind == "song" {
                songs.append(media)
            }

            if kind == "unknown" {
                unknown.append(media)
            }

        }
    }
    
    func isEmpty() -> Bool {
        if !books.isEmpty ||
            !albums.isEmpty ||
            !coached_audios.isEmpty ||
            !interactive_booklets.isEmpty ||
            !music_videos.isEmpty ||
            !pdfs.isEmpty ||
            !podcasts.isEmpty ||
            !podcast_episodes.isEmpty ||
            !software_packages.isEmpty ||
            !songs.isEmpty ||
            !featured_movies.isEmpty {
            return false
        }
        
        return true
    }
    
    static func == (lhs: MediaSearchResponse, rhs: MediaSearchResponse) -> Bool {
        return lhs.id == rhs.id
    }
    
    static private func convertToMedia(result: [String: Any]) -> Media {
        let kind = result["kind"] as? String ?? "unknown"
        
        let name = result["trackName"] as? String ?? ""
        let artwork: URL? = {
            var URLString: String?
            
            if let possibleURLString = result["artworkUrl100"] as? String {
                URLString = possibleURLString
            }
            else if let possibleURLString = result["artworkUrl60"] as? String {
                URLString = possibleURLString
            } else if let possibleURLString = result["artworkUrl30"] as? String {
                URLString = possibleURLString
            }

            guard URLString != nil else {
                return nil
            }
            
            return URL(string: URLString!)
        }()
        
        let url: URL = {
            if let urlString = result["trackViewUrl"] as? String {
                return URL(string: urlString)!
            }

            if let urlString = result["artistViewUrl"] as? String {
                return URL(string: urlString)!
            }

            if let urlString = result["collectionViewUrl"] as? String {
                return URL(string: urlString)!
            }

            return URL(string: "")!
        }()
        
        return Media(name: name, artwork: artwork, genre: kind, url: url)
    }
}

struct Media {
    let id = UUID()
    var name: String
    var artwork: URL?
    var genre: String
    var url: URL
}
