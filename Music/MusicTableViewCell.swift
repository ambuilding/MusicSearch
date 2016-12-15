//
//  MusicTableViewCell.swift
//  MusicSearch
//
//  Created by William on 2016/11/27.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var track: Track? {
        didSet {
            updateUI()
        }
    }
   
    fileprivate func updateUI() {
        nameLabel?.text = track?.name
        if let track = self.track,
            let imageURL = URL(string: track.imageURL) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    if let imageData = contentsOfURL {
                        weakSelf?.photoView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}


