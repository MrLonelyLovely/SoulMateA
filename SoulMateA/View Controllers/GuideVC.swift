//
//  GuideVC.swift
//  SoulMate
//
//  Created by Apui on 2020/3/15.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVKit

class GuideVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpVideo()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }

    func setUpVideo() {
        
        //获取在bundle中的资源的路径
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        //创建URL
        let videoUrl = URL(fileURLWithPath: bundlePath!)
        
        //创建video player item
        let item = AVPlayerItem(url: videoUrl)
        
        //创建player
        videoPlayer = AVPlayer(playerItem: item)
        
        //创建layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //调整大小和框架
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //将它加到view中并播放它
        videoPlayer?.playImmediately(atRate: 0.4)
        
        
    }
    

}
