//
//  DetailViewController.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import UIKit

// MARK: - DetailViewController

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
  
    // MARK: - Variables And Properties
    
    var track: Track?
    
    private let placeholderImage = UIImage(named: "image-placeholder")
  
    // MARK: - View controller lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageURL = URL(string: track?.imageURL ?? "")
        trackImageView.sd_imageTransition = .fade
        trackImageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
        titleLabel.text = track?.name
        genreLabel.text = "Genre: \(track?.genre ?? "")"
        priceLabel.text = "Price: $\(track?.price ?? 0.0)"
        detailTextView.text = track?.longDescription
    }
    
}
