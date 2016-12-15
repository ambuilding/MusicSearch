//
//  Track.swift
//  MusicSearch
//
//  Created by William on 2016/11/27.
//  Copyright © 2016年 William. All rights reserved.
//

import Foundation

typealias JSONType = [String: Any]

struct Track {
    var name: String
    var previewURL: String
    var imageURL: String
}

extension Track {
    init?(json: JSONType) {
        guard let name = json["name"] as? String,
            let previewURL = json["preview_url"] as? String,
            let albumJSON = json["album"] as? JSONType else {
                return nil
        }
        
        guard let images = albumJSON["images"] as? [JSONType],
            let imageData = images.first,
            let imageURL = imageData["url"] as? String
        else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.previewURL = previewURL
        self.imageURL = imageURL
    }
}



extension Track {
    static func tracks(matching query: String, completion: @escaping ([Track]) -> Void) {
        let url = "https://api.spotify.com/v1/search?q=\(query)&type=track"
        guard let urlAPI = URL(string: url) else { return  }
        let urlRequest = URLRequest(url: urlAPI)
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, _, _) in
            var tracks: [Track] = []
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(
                    with: data,
                    options: JSONSerialization.ReadingOptions.mutableContainers
                    ) as? [String: Any],
                let tracksJson = json?["tracks"] as? JSONType,
                let itemsJson = tracksJson["items"] as? [JSONType]
            else { return }
            
            for itemJson in itemsJson {
                if let newItem = Track(json: itemJson) {
                    tracks.append(newItem)
                }
            }
            completion(tracks)
        }).resume()
    }
}

/*
 extension Track {
 func resquest(_ query: String) -> URLRequest? {
 let url = "https://api.spotify.com/v1/search?q=\(query)&type=track"
 guard let urlAPI = URL(string: url) else { return nil  }
 return URLRequest(url: urlAPI)
 }
 }
 
 extension Track {
 static func fetchTracks(last urlRequest: URLRequest, completion: @escaping ([Track]) -> Void) {
 URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, _, _) in
 var tracks: [Track] = []
 guard let data = data,
 let json = try? JSONSerialization.jsonObject(
 with: data,
 options: JSONSerialization.ReadingOptions.mutableContainers
 ) as? [String: Any],
 let tracksJson = json?["tracks"] as? JSONType,
 let itemsJson = tracksJson["items"] as? [JSONType]
 else { return }
 
 for itemJson in itemsJson {
 if let newItem = Track(json: itemJson) {
 tracks.append(newItem)
 }
 }
 completion(tracks)
 }).resume()
 
 }
 }
 */

//            if let data = data,
//                let json = try? JSONSerialization.jsonObject(
//                    with: data,
//                    options: JSONSerialization.ReadingOptions.mutableContainers
//                    ) as? [String: Any] {
//                if let tracksJson = json?["tracks"] as? [JSONType] {
//                    for trackJson in tracksJson {
//                        if let newTrack = Track(json: trackJson) {
//                            tracks.append(newTrack)
//                        }
//                    }
//                }
//            }
