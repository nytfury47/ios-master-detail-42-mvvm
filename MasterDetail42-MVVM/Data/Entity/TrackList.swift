//
//  TrackList.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation

// MARK: - TrackList

struct TrackList: Decodable {
    
    var count: Int
    var tracks: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case count = "resultCount"
        case tracks = "results"
    }
    
    struct Track: Decodable {
        var name: String
        var imageURL: String
        var price: Double?
        var genre: String
        var longDescription: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "trackName"
            case imageURL = "artworkUrl100"
            case price = "trackPrice"
            case genre = "primaryGenreName"
            case longDescription
        }
    }
    
}
