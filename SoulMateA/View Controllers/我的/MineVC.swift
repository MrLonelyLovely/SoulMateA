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
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
