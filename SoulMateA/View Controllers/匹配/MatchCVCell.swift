//
//  MatchCollectionViewCell.swift
//  SoulMate
//
//  Created by Apui on 2020/3/16.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class MatchCVCell: UICollectionViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var contryNameLabel: UILabel!
    
    
    func configure(with contryName: String) {
        contryNameLabel.text = contryName
    }
    
    func configure(with image:UIImage) {
        headImageView.image = image
    }
    
}
