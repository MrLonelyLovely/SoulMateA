//
//  SearchUsersTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/22.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class SearchUsersTVC: UITableViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    
    var usernameArray = [String]()
    var headImageArray = [AVFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //实现SearchBar功能
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
//        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.width - 30
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
//        loadUser()
        
    }

    //查询最近注册的前20名用户
    func loadUser() {
        let usersQuery = AVUser.query()
        usersQuery.addAscendingOrder("createdAt")
        usersQuery.limit = 20
        
        usersQuery.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            if error == nil {
                self.usernameArray.removeAll(keepingCapacity: false)
                self.headImageArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.usernameArray.append((object as AnyObject).username!)
                    self.headImageArray.append((object as AnyObject).value(forKey: "avaHeadImage") as! AVFile)
                }
                
                //记得要刷新表格视图
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let userQuery = AVUser.query()
        //        userQuery.whereKey("username", matchesRegex: "(? i)" + searchBar.text!)
        //用用户名查找特定用户
        userQuery.whereKey("username", equalTo: searchBar.text!)
        
        userQuery.findObjectsInBackground ({ (objects:[Any]?, error:Error?) in
            
            if error == nil {
                
                if objects!.isEmpty {
                    
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.headImageArray.removeAll(keepingCapacity: false)
                    
                    self.tableView.reloadData()
                    
                    print("No users found!")
                    let alert = UIAlertController(title: "Oops", message: "没找到对应用户喔！", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好的吧！", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                     
                } else {
                    
                    self.searchBar.resignFirstResponder()
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.headImageArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.usernameArray.append((object as AnyObject).username!)
                        self.headImageArray.append((object as AnyObject).value(forKey: "avaHeadImage") as! AVFile)
                    }
                    self.tableView.reloadData()
                }
            }
        })
                
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let userQuery = AVUser.query()
//        userQuery.whereKey("username", matchesRegex: "(? i)" + searchBar.text!)
        //用用户名查找特定用户
        userQuery.whereKey("username", equalTo: searchBar.text!)
        
        userQuery.findObjectsInBackground ({ (objects:[Any]?, error:Error?) in
            if error == nil {
                
                if objects!.isEmpty {
                    print("No users found!")
                    let alert = UIAlertController(title: "Oops", message: "没找到对应用户喔！", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好的吧！", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.headImageArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.usernameArray.append((object as AnyObject).username!)
                        self.headImageArray.append((object as AnyObject).value(forKey: "avaHeadImage") as! AVFile)
                    }
                    self.tableView.reloadData()
                }
            }
        })
        return true
        
    }
    */
 
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    //单击cancel按钮时，调用该方法，让键盘消失，搜索栏的cancel按钮消失，将searchBar的文字清空，(并重新载入默认搜索用户)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        searchBar.showsCancelButton = false
        
        searchBar.text = ""
        
        //清空之前可能查到的用户
        self.usernameArray.removeAll(keepingCapacity: false)
        self.headImageArray.removeAll(keepingCapacity: false)
        
        self.tableView.reloadData()
        
//        loadUser()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! friendCell
        
        cell.usernameLabel.text = usernameArray[indexPath.row]
        
        headImageArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.headImage.image = UIImage(data: data!)
            }
        }

        return cell
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
