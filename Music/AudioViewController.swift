//
//  AudioViewController.swift
//  MusicSearch
//
//  Created by William on 2016/11/27.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player = AVAudioPlayer()
    
    var track: Track? {
        didSet {
            updateUI()
            title = track?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        playPauseButton.setTitle("Pause", for: .normal)
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
                        weakSelf?.background?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        guard let previewURL = track?.previewURL else { return }
        DispatchQueue.main.async { [weak weakSelf = self] in
            weakSelf?.downloadFileFromURL(url: URL(string: previewURL)!)
        }
        
    }

    fileprivate func downloadFileFromURL(url: URL) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (customURL, _, error) in
            self.play(url: customURL!)
        }).resume()
    }
    
    fileprivate func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch { print(error) }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }

}
