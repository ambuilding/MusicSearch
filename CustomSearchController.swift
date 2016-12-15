//
//  CustomSearchController.swift
//  Music
//
//  Created by William on 2016/12/7.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

protocol CustomSearchControllerDelegate: NSObjectProtocol {
    
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
}

class CustomSearchController: UISearchController, UISearchBarDelegate {
    
    var customDelegate: CustomSearchControllerDelegate!
    var customSearchBar: CustomSearchBar!
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect,
         searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(
            frame: searchBarFrame,
            font: searchBarFont,
            textColor: searchBarTextColor,
            bgColor: searchBarTintColor
        )
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureSearchBar(
        frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customSearchBar = CustomSearchBar(
            frame: frame,
            font: font,
            textColor: textColor
        )
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsBookmarkButton = false
        customSearchBar.showsCancelButton = true
        
        customSearchBar.delegate = self
    }

    // MARK: CustomSearchControllerDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customDelegate.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate.didChangeSearchText(searchText: searchText)
    }
    
    // MARK: - UISearchBarDelegate
  
}

