//
//  FriendsTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/22.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVOSCloudIM

var willChatUser:AVUser?

class FriendsTVC: UITableViewController {

    var followersArray = [AVUser]()   //粉丝
    var followingsArray = [AVUser]()  //关注
    var friendsArray = [AVUser]()     //好友
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.hidesBottomBarWhenPushed = true
        
        tableView.rowHeight = 67
        
        //异步进程实现顺序执行
        let concurrentQueue = DispatchQueue(label: "com.cp.concurrent", attributes: .concurrent)
        concurrentQueue.async {
            self.loadFollowers()
        }

        concurrentQueue.async {
            self.loadFollowings()
        }
        concurrentQueue.async(flags: .barrier, execute: {
            
            sleep(1)
            
        })

        concurrentQueue.async {
            self.getFollowersAndFollowings()
        }
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func getFollowersAndFollowings() {

        friendsArray.removeAll(keepingCapacity: false)
        
        for follower in followersArray {
            for following in followingsArray {
                if follower == following {
                    friendsArray.append(follower)
                }
            }
        }
        
//        print("好友 Number: \(self.friendsArray.count)")
//        print("好友名字叫：\(friendsArray[0].username)")
        //记得要刷新表格视图，否则不会有数据/UI元素展示出来
        //并且，必须要回到主线程去刷新UI
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        
    }
    
    
    //获取当前用户的粉丝
    func loadFollowers() {
        AVUser.current()?.getFollowers({ (followers:[Any]?, error:Error?) in
            if error == nil && followers != nil {
                self.followersArray = followers! as! [AVUser]
//                print("粉丝 Number: \(self.followersArray.count)")
                //刷新表格视图
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        } )
    }
    
    //获取当前用户的正在关注
    func loadFollowings() {
        AVUser.current()?.getFollowees({ (followings:[Any]?, error:Error?) in
            if error == nil && followings != nil {
                self.followingsArray = followings! as! [AVUser]
//                print("关注了 Number: \(self.followingsArray.count)")
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        } )
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! friendCell
        cell.usernameLabel.text = friendsArray[indexPath.row].username
        
        let ava = friendsArray[indexPath.row].object(forKey: "avaHeadImage") as! AVFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.headImage.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription as Any)
            }
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        willChatUser = friendsArray[indexPath.row]
        
    }
    
    //这样跳转的话会报错：cell未注册
    func transitionToChatRoomTVC() {
        
        let chatRoomVC = ChatRoomVC()
        
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
