//
//  MineVC.swift
//  SoulMate
//
//  Created by Apui on 2020/3/15.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class MineVC: UIViewController {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var seeMyPageButton: UIButton!
    
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var fansNumberLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        //单击关注者（粉丝）数
        let followersNumBerTap = UITapGestureRecognizer(target: self, action: #selector(followersNumberTapM))
        followersNumBerTap.numberOfTapsRequired = 1
        followersNumBerTap.numberOfTouchesRequired = 1
        fansNumberLabel.isUserInteractionEnabled = true
        fansNumberLabel.addGestureRecognizer(followersNumBerTap)
        
        //单击关注数
        let followingsNumberTap = UITapGestureRecognizer(target: self, action: #selector(followingsNumberTapM))
        followingsNumberTap.numberOfTapsRequired = 1
        followingsNumberTap.numberOfTouchesRequired = 1
        followingNumberLabel.isUserInteractionEnabled = true
        followingNumberLabel.addGestureRecognizer(followingsNumberTap)
        
    }
    
    func setUpElements() {
        
        Utilities.circleTheImageView(headImageView)
                
        //获取某个class表的某个属性
        let avaQuery = AVUser.current()?.object(forKey: "avaHeadImage") as! AVFile
        avaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
            } else {
                self.usernameLabel.text = AVUser.current()?.username
                self.headImageView.image = UIImage(data: data!)
            }
        }
//        Utilities.styleFilledButton(seeMyPageButton)
        
//        Utilities.styleFilledButton(settingButton)
        
        getFansNumber()
        getFollowingsNumber()
        
    }

    
    @IBAction func seeMyDetailPageButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        
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
    
    //响应单击关注者（粉丝）数
    @objc func followersNumberTapM() {
        //从故事板载入FollowersTVC的视图
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersTVC") as! FollowersTVC
//        followers.user = (AVUser.current()?.username)!
        followers.show = "粉丝"
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    //响应单击关注数
    @objc func followingsNumberTapM() {
        //从故事板载入FollowersTVC的视图
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersTVC") as! FollowersTVC
//        followings.user = (AVUser.current()?.username)!
        followings.show = "关注"
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
