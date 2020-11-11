//
//  TrackListService.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation
import Alamofire

// MARK: - TrackListService

class TrackListService {
    
    // MARK: - Class methods

    static func fetchTrackList<T: Decodable>(type: T.Type,
                                             completionHandler: @escaping (T?, Bool) -> Void) {
        AF.request("https://itunes.apple.com/search?term=star&country=au&media=movie")
            .validate()
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                    case .success:
                        print("Validation Successful")
                        completionHandler(response.value, true)
                    case let .failure(error):
                        print(error)
                        completionHandler(nil, false)
                }
            }
    }

}
