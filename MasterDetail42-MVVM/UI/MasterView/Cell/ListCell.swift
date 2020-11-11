//
//  ListCell.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import UIKit

// MARK: - ListCell

class ListCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackGenre: UILabel!
    @IBOutlet weak var trackPrice: UILabel!
    
}
