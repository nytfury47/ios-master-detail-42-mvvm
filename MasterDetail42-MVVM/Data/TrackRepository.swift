//
//  TrackRepository.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation

// MARK: - TrackRepository

class TrackRepository {
    
    // MARK: - Class methods
    
    static func loadTracks(completionHandler: @escaping ([Track]?, Bool?) -> Void) {
        var isLoadComplete = false
        
        // Get from CoreData if available
        if let tracks = CoreDataManager.shared.getTracks(),
               tracks.count != 0 {
            isLoadComplete = true
            completionHandler(tracks, true)
        }
        
        // Update CoreData with latest data from remote source
        TrackListService.fetchTrackList(type: TrackList.self) { (trackList, success) in
            guard success == true else {
                if (!isLoadComplete) {
                    completionHandler(nil, false)
                }
                return
            }
            
            // Replace existing CoreData with latest data
            CoreDataManager.shared.deleteTracks()
            CoreDataManager.shared.insertTracks(trackList: trackList)
            
            if (!isLoadComplete) {
                // Get from CoreData if available
                if let tracks = CoreDataManager.shared.getTracks() {
                    isLoadComplete = true
                    completionHandler(tracks, true)
                } else {
                    completionHandler(nil, false)
                }
            }
        }
    }
    
}
