//
//  FollowersTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/29.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class FollowersTVC: UITableViewController {

    var show = String()   //用于在导航栏标题处显示内容
//    var user = String()   //用于在返回按钮上显示用户名称
    var followerArray = [AVUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 67
        
        if show == "粉丝" {
            loadFollowers()
        } else {
            loadFollowings()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followerArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell", for: indexPath) as! FollowersCell

        cell.usernameLabel.text = followerArray[indexPath.row].username
        let ava = followerArray[indexPath.row].object(forKey: "avaHeadImage") as! AVFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.headImageView.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription as Any)
            }
        }

        return cell
    }
    
    func loadFollowers() {
        AVUser.current()?.getFollowers({ (followers:[Any]?, error:Error?) in
            if error == nil && followers != nil {
                self.followerArray = followers! as! [AVUser]
                print("matchArray Number: \(self.followerArray.count)")
                //刷新表格视图
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        } )
    }
    
    func loadFollowings() {
        AVUser.current()?.getFollowees({ (followings:[Any]?, error:Error?) in
            if error == nil && followings != nil {
                self.followerArray = followings! as! [AVUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        } )
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
