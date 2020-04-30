//
//  API.swift
//  iTunesCatalog
//
//  Created by Christian Hipolito on 30/04/20.
//  Copyright © 2020 Christian Hipolito. All rights reserved.
//

import Foundation

final class API {
    func searchTerm(_ term: String, completion: @escaping (MediaSearchResponse) -> Void) {
        guard term != "" else {
            completion(MediaSearchResponse(results: []))
            return
        }
        
        let searchTermURL = "https://itunes.apple.com/search?term=" + urlEncode(string: term) + "&limit=200"

        let task = URLSession.shared.dataTask(with: URL(string: searchTermURL)!) { (data, response, error) in
            guard error == nil else {
                print("error performing search \(error!)")
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }
            
            do {
                let resposeDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init()) as? [String: Any]
                
                guard let resultsArray = resposeDic?["results"] as? [[String: Any]], !resultsArray.isEmpty else {
                    print("Not results")
                    return
                }
                
                let mediaResponse = MediaSearchResponse(results: resultsArray)
                
                completion(mediaResponse)
            }
            catch let errorSerializing {
                print("Error serializing response " + errorSerializing.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    private func urlEncode(string: String) -> String {
        let charactersNotAllowed = "!*'();:@&=+$,/?%#[]{}\" "
        
        let allowedCharaters = CharacterSet(charactersIn: charactersNotAllowed).inverted
        
        let urlEncoding = string.addingPercentEncoding(withAllowedCharacters: allowedCharaters)!
        
        return urlEncoding
    }

}
