//
//  AboutViewController.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import UIKit

// MARK: - AboutViewController

class AboutViewController: UIViewController {
    
    // MARK: - Master View manipulation methods
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
