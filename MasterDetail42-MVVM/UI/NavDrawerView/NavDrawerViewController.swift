//
//  NavDrawerViewController.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import UIKit

// MARK: - NavDrawerViewController

class NavDrawerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var lastVisit: UILabel!
  
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appTitle.text = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        lastVisit.text = "Last visit: " + UserDefaultsManager.shared.lastVisit
    }
    
}
