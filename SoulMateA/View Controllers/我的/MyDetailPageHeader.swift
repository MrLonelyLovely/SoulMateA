//
//  MyDetailPageHeader.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/21.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class MyDetailPageHeader: UICollectionReusableView {
        
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var fansNumberLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.circleTheImageView(headImage)

        getFansNumber()

        getFollowingsNumber()
    }
    
    
    func getFansNumber() {
        
        //查询出该用户的粉丝总人数，并修改粉丝数量标签
        let user = AVUser.current()!
        
        let followersQuery = AVQuery(className: "_Follower")
        followersQuery.whereKey("user", equalTo: user)
        followersQuery.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil {
                self.fansNumberLabel.text = String(count)
            }
        }
    }
    
    
    func getFollowingsNumber() {
        
        //查询出该用户关注别人的总人数，并修改该数量标签
        let user = AVUser.current()!
        
        let followeesQuery = AVQuery(className: "_Followee")
        followeesQuery.whereKey("user", equalTo: user)
        followeesQuery.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil {
                self.followingNumberLabel.text = String(count)
            }
        }
    }
 
}
