//
//  MasterViewModel.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation

// MARK: - MasterViewModel

class MasterViewModel {
    
    // MARK: - Variables And Properties
    
    let tracks: Box<[Track]?> = Box(nil)
    let loadSuccess: Box<Bool?> = Box(nil)
    
    // MARK: - Class methods
    
    init() {
        // Load track data
        TrackRepository.loadTracks { (tracks, success) in
            if success == true {
                self.tracks.value = tracks
                self.loadSuccess.value = true
            } else {
                self.tracks.value = nil
                self.loadSuccess.value = false
            }
        }
    }
}
