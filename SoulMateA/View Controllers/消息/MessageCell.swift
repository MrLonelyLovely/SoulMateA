//
//  MessageCell.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/25.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var lastMessageContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
