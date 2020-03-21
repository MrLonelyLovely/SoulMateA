//
//  StoryCell.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/21.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

//postCell

class StoryCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var postPictureImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var commentNumberLabel: UILabel!
    
    @IBOutlet weak var postIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utilities.circleTheImageView(headImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
