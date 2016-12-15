//
//  ViewController.swift
//  MusicSearch
//
//  Created by William on 2016/11/26.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.text = searchText
        }
    }
    
    // MARK: Model
    
    var searchText: String? {
        didSet {
            tracks?.removeAll()
            fetchTracks()
            title = searchText
        }
    }
    
    var tracks: [Track]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    fileprivate func fetchTracks() {
        if let query = searchText, !query.isEmpty {
            Track.tracks(matching: query) { [weak weakSelf = self] (tracks) in
                DispatchQueue.main.async {
                    weakSelf?.tracks = tracks
                    //weakSelf?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let keyword = searchBar.text
        searchText = keyword?.replacingOccurrences(of: " ", with: "+")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StoryBoard.MusicCellIdentifier,
            for: indexPath
        )
        let track = tracks?[indexPath.row]
        if let trackCell = cell as? MusicTableViewCell {
            trackCell.track = track
        }
        
        return cell
    }
    
    // MARK: Contants
    
    fileprivate struct StoryBoard {
        static let MusicCellIdentifier = "MusicCell"
        static let ShowAudioSegue = "ShowMusic"
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow?.row,
            segue.identifier == StoryBoard.ShowAudioSegue,
            let audioVC = segue.destination as? AudioViewController {
            audioVC.track = tracks?[indexPath]
        }
    }

/*
     // search controller to help up with filtering
     //fileprivate var searchController: UISearchController!

    func configureCustomSearchController() {
        customSearchController = CustomSearchController(
            searchResultsController: self,
            searchBarFrame: CGRect(
                x: 0.0, y: 0.0,
                width: tableView.frame.size.width,
                height: 50.0),
            searchBarFont: UIFont(name: "Futura", size: 16.0)!,
            searchBarTextColor: UIColor.orange,
            searchBarTintColor: UIColor.black
        )
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        tableView.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    // MARK: CustomSearchControllerDelegate
    
    func didStartSearching() {
        shouldShowSearchResults = true
      //  tableView.reloadData()
    }
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
       // tableView.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        self.searchText = searchText
        let query = searchText
        if !query.isEmpty {
            Track.tracks(matching: query) { [weak weakSelf = self] tracks in
                DispatchQueue.main.async {
                    weakSelf?.tracks = tracks
                    weakSelf?.tableView.reloadData()
                }
            }
        }
    }

    fileprivate func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search here..."
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }
     //    var request: URLRequest {
     //        if let query = searchText, !query.isEmpty {
     //            Track.resquest(<#T##Track#>)
     //        }
     //    }

 */
  
}

//extension TableViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let query = searchController.searchBar.text, !query.isEmpty {
//            Track.tracks(matching: query) { tracks in
//                self.tracks = tracks
//                self.tableView.reloadData()
//            }
//        }
//    }
//}

//extension TableViewController {
//    fileprivate func fetchTracks() {
//        if let query = searchText, !query.isEmpty {
//            Track.tracks(matching: query) { [weak weakSelf = self] (tracks) in
//                    weakSelf?.tracks = tracks
//                   // weakSelf?.tableView.reloadData()
//            }
//        }
//    }
//}
