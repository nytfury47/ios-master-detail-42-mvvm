//
//  MasterViewController.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import UIKit
import SDWebImage

// MARK: - MasterViewController

class MasterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerViewBack: UIButton!
    
    // MARK: - Constants
    
    private let kListCellReuseIdentifier: String = "ListCell"
    private let kGridCellReuseIdentifier: String = "GridCell"
    private let kGridLayoutItemsPerRow: CGFloat = 3
    private let kListCellHeight: CGFloat = 100
    private let kGridCellWidth: CGFloat = 100
    private let kGridCellHeight: CGFloat = 128
    private let kSectionInset: CGFloat = 10
    private let kSegueToDetailViewIdentifier: String = "ShowTrackDetails"
    
    // MARK: - Variables And Properties
    
    private let viewModel = MasterViewModel()
    private let placeholderImage = UIImage(named: "image-placeholder")
    
    private var tracks: [Track]?
    private var isListLayout: Bool = UserDefaultsManager.shared.isListLayout
    private var isDrawerViewOpen: Bool = false
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tracks.bind { [weak self] tracks in
            if tracks != nil {
                self?.tracks = tracks
                self?.updateNavBarTitle()
                self?.reloadCollectionView()
            }
        }
        
        viewModel.loadSuccess.bind { [weak self] loadSuccess in
            if let result = loadSuccess {
                if !result {
                    self?.alertNetworkError()
                }
                self?.activityIndicator.stopAnimating()
            }
        }
        
        // Ready the views
        setupViews()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)
      
      if
        segue.identifier == kSegueToDetailViewIdentifier,
        let detailViewController = segue.destination as? DetailViewController,
        let trackCell = sender as? UICollectionViewCell,
        let row = collectionView.indexPath(for: trackCell)?.row
      {
        detailViewController.track = tracks?[row]
      }
    }
    
    // MARK: - Master View manipulation methods
    
    func setupViews() {
        // Update navigation bar elements
        updateNavBar()
        
        // Initialize flow layout
        collectionView.collectionViewLayout = {
            let collectionFlowLayout = UICollectionViewFlowLayout()
            collectionFlowLayout.itemSize = CGSize(width: kGridCellWidth, height: kGridCellHeight)
            return collectionFlowLayout
        }()
    }
    
    func updateNavBar() {
        updateNavBarTitle()
        updateLeftBarButton()
        updateRightBarButton()
    }
    
    func updateNavBarTitle() {
        title = "Tracks (\(tracks?.count ?? 0))"
    }
    
    func updateLeftBarButton() {
        let image = UIImage(named: "menu")
        let drawerViewButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(drawerViewButtonTapped(sender:)))
        navigationItem.setLeftBarButton(drawerViewButton, animated: true)
    }
    
    func updateRightBarButton() {
        let image = UIImage(named: isListLayout ? "layout-grid" : "layout-list")
        let toggleButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleLayoutButtonTapped(sender:)))
        navigationItem.setRightBarButton(toggleButton, animated: true)
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func toggleLayoutButtonTapped(sender: UIBarButtonItem) {
        if isDrawerViewOpen {
            return
        }
        
        isListLayout = !isListLayout
        UserDefaultsManager.shared.isListLayout = isListLayout
        updateRightBarButton()
        reloadCollectionView()
    }
    
    @objc func drawerViewButtonTapped(sender: UIBarButtonItem?) {
        toggleDrawerView()
    }
    
    @IBAction func drawerViewBackButtonTapped(_ sender: UIButton) {
        toggleDrawerView()
    }
    
    func toggleDrawerView() {
        var drawerViewFrame = drawerView.frame
        drawerViewFrame.origin.x = isDrawerViewOpen ? -drawerViewFrame.size.width : 0;
        
        UIView.animate(withDuration: 0.3) {
            self.drawerView.frame = drawerViewFrame
            self.drawerViewBack.alpha = self.isDrawerViewOpen ? 0 : 0.7
        }
        
        isDrawerViewOpen = !isDrawerViewOpen
        drawerViewBack.isEnabled = isDrawerViewOpen
    }
    
    func alertNetworkError() {
        let alert = UIAlertController(title: "Network Error", message: "Error occurred in fetching data from remote source. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Collection View Data Source

extension MasterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListLayout {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kListCellReuseIdentifier, for: indexPath) as! ListCell
            if let track = tracks?[indexPath.row] {
                let imageURL = URL(string: track.imageURL ?? "")
                cell.trackImage.sd_imageTransition = .fade
                cell.trackImage.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
                cell.trackTitle.text = track.name
                cell.trackGenre.text = track.genre
                cell.trackPrice.text = "$\(track.price)"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGridCellReuseIdentifier, for: indexPath) as! GridCell
            if let track = tracks?[indexPath.row] {
                let imageURL = URL(string: track.imageURL ?? "")
                cell.trackImage.sd_imageTransition = .fade
                cell.trackImage.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
                cell.trackPrice.text = "$\(track.price)"
            }
            return cell
        }
    }
    
}

// MARK: - Collection View Flow Layout Delegate

extension MasterViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kListCellWidth = collectionView.frame.width - (kSectionInset * 2)
        let widthPerItem = isListLayout ? kListCellWidth : kGridCellWidth
        let heightPerItem = isListLayout ? kListCellHeight : kGridCellHeight
        return CGSize(width: widthPerItem, height: CGFloat(heightPerItem))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kSectionInset, left: kSectionInset, bottom: kSectionInset, right: kSectionInset)
    }
    
}
