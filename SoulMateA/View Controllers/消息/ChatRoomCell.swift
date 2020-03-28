//
//  ChatRoomCell.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/25.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVOSCloudIM

class ChatRoomCell: UITableViewCell {

    @IBOutlet weak var leftHeadImageContainer: UIView!
    @IBOutlet weak var leftHeadImageView: UIImageView!
    
    @IBOutlet weak var rightHeadImageContainer: UIView!
    @IBOutlet weak var rightHeadImageView: UIImageView!    
    
    @IBOutlet weak var messageTextBackgroundView: UIView!
    @IBOutlet weak var messageFromLabel: UILabel!    //username
    @IBOutlet weak var messageTextContentLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    func update(with message: AVIMTextMessage) {
        self.messageTextBackgroundView.layer.cornerRadius = 4
        // = .out时，表示消息由当前用户发出
        if message.ioType == .out {
            self.leftHeadImageContainer.isHidden = true
            self.rightHeadImageContainer.isHidden = false
            
            self.messageTextBackgroundView.backgroundColor = UIColor(red: 255.5 / 255.0, green: 177.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
//            self.messageTextBackgroundView.backgroundColor = .clear
            self.messageFromLabel.textAlignment = .right
            self.messageTextContentLabel.textAlignment = .right
            self.messageDateLabel.textAlignment = .left
        } else {
            self.leftHeadImageContainer.isHidden = false
            self.rightHeadImageContainer.isHidden = true
            self.messageTextBackgroundView.backgroundColor = UIColor(red: 168.0 / 255.0, green: 216.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
            self.messageFromLabel.textAlignment = .left
            self.messageTextContentLabel.textAlignment = .left
            self.messageDateLabel.textAlignment = .right
        }
        
        self.messageTextContentLabel.text = message.text ?? "-"

    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
