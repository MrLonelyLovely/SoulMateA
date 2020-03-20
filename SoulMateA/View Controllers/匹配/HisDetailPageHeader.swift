//
//  HisDetailPageHeader.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/19.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class HisDetailPageHeader: UICollectionReusableView {
        
    let user:AVUser = mayWillMatchUser!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var usernameTextLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var fansLabel: UILabel!
    
    @IBOutlet weak var fansNumberLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpElements()
        setFollowButtonStatus()
    }
    
    func setUpElements() {
        
        //查询该用户的user，并获得对应的头像、粉丝数量等数据
        Utilities.circleTheImageView(headImage)
        
        getFansNumber()
        
        getFollowingsNumber()
        
//        Utilities.styleFilledButton(followButton)
//        self.followButton.setTitle("关注", for: .normal)
//        self.followButton.backgroundColor = .lightGray
        
        
//        let followersQuery = AVQuery(className: "_Follower")
//        followersQuery.whereKey("user", equalTo: currentuser)
//        followersQuery.countObjectsInBackground { (count:Int, error:Error?) in
//            if error == nil {
//                header.followersNumber.text = String(count)
//            }
//        }
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        let title = followButton.title(for: .normal)
        
        if title == "关注" {
//            guard user != nil else {return}
            
            AVUser.current()?.follow(user.objectId!, andCallback: { (success:Bool, error:Error?) in
                if success {
                    self.followButton.setTitle("已关注", for: .normal)
                    self.followButton.backgroundColor = .green
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        } else {
//            guard user != nil else {return}

            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success:Bool, error:Error?) in
                if success {
                    self.followButton.setTitle("关注", for: .normal)
                    self.followButton.backgroundColor = .lightGray
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }
    
    
    func setFollowButtonStatus() {

        //获取特定的粉丝用户
//        AVQuery<AVUser> followerNameQuery = userA.followerQuery(userA.getObjectId(), AVUser.class);
//        followerNameQuery.whereEqualTo("follower", userC);
//        followerNameQuery.findInBackground(new FindCallback<AVUser>() {
//            @Override
//            public void done(List<AVUser> avObjects, AVException avException) {
//                // avObjects 中应当只包含 userC
//            }
//        });
        
        let query = AVUser.current()?.followeeQuery()
        //注意这里的equalTo的参数不是user.objectId（String），而是用户对象本身，因为在后台这个属性是pointer的
        query?.whereKey("followee", equalTo: user)
        let foundUser = query?.getFirstObject() as? AVUser
        guard foundUser != nil else {
            self.followButton.setTitle("关注", for: .normal)
            self.followButton.backgroundColor = .lightGray
            return
        }
        
        if foundUser!.objectId == user.objectId {
            followButton.setTitle("已关注", for: .normal)
            followButton.backgroundColor = .green
        }

    }
    
    func getFansNumber() {
        
        //查询出该用户的粉丝总人数，并修改粉丝数量标签
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
        let followeesQuery = AVQuery(className: "_Followee")
        followeesQuery.whereKey("user", equalTo: user)
        followeesQuery.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil {
                self.followingNumberLabel.text = String(count)
            }
        }
    }
    
}
