//
//  StoryTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/20.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class StoryTVC: UITableViewController{

    //用于存储云端数据的数组
//    var followerArray = [AVUser]()
    var usernameArray = [String]()
    var headImageArray = [AVFile]()
    var dateArray = [Date]()
    var postPictureArray = [AVFile]()
    var postTextArray = [String]()
    var postIdArray = [String]()
    
    //存储当前用户所关注的人
    var followingArray = [String]()
    
    //page size
    var pageSize:Int = 10
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //设置refresher
        refresher.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        self.view.addSubview(refresher)
        
        loadPosts()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func loadPosts() {
        //获取当前用户所关注的用户
        AVUser.current()?.getFollowees({ (followees:[Any]?, error:Error?) in
            if error == nil && followees != nil {
//                self.followerArray = followers! as! [AVUser]
//                print("matchArray Number: \(self.followerArray.count)")
                self.followingArray.removeAll(keepingCapacity: false)
                
                for followee in followees! {
                    
                    //添加当前用户所关注的所有人到followingArray数组中
                    self.followingArray.append((followee as AnyObject).username!)
                }
                //添加当前用户到followingArray数组中
                self.followingArray.append(AVUser.current()!.username!)
                
                let query = AVQuery(className: "Posts")
                //这里竟然可以用数组，太神奇了
                query.whereKey("username", containedIn: self.followingArray)
                query.limit = self.pageSize
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground ({ (objects:[Any]?, error:Error?) in
                    if error == nil {
                        //清空数组
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.headImageArray.removeAll(keepingCapacity: false)
                        self.dateArray.removeAll(keepingCapacity: false)
                        self.postPictureArray.removeAll(keepingCapacity: false)
                        self.postTextArray.removeAll(keepingCapacity: false)
                        self.postIdArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append((object as AnyObject).value(forKey: "username") as! String)
                            self.headImageArray.append((object as AnyObject).value(forKey: "headImage") as! AVFile)
                            self.dateArray.append((object as AnyObject).createdAt!)
                            self.postPictureArray.append((object as AnyObject).value(forKey: "postPicture") as! AVFile)
                            self.postTextArray.append((object as AnyObject).value(forKey: "title") as! String)
                            self.postIdArray.append((object as AnyObject).value(forKey: "postId") as! String)
                            
                        }
                        
                        //刷新表格视图
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                        
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        } )
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height * 2 {
            loadMore()
        }
    }

    func loadMore() {
        
        //如果云端获取到的帖子数大于pageSize数
        if self.pageSize <= postIdArray.count {
            //开始Indicator动画
            indicator.startAnimating()
            
            pageSize = pageSize + 10
            
            AVUser.current()?.getFollowees({ (followees:[Any]?, error:Error?) in
                if error == nil && followees != nil {
                    self.followingArray.removeAll(keepingCapacity: false)
                    
                    for followee in followees! {
                        
                        //添加当前用户所关注的所有人到followingArray数组中
                        self.followingArray.append((followee as AnyObject).username!)
                    }
                    //添加当前用户到followingArray数组中
                    self.followingArray.append(AVUser.current()!.username!)
                    
                    let query = AVQuery(className: "Posts")
                    //这里竟然可以用数组，太神奇了
                    query.whereKey("username", containedIn: self.followingArray)
                    query.limit = self.pageSize
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackground ({ (objects:[Any]?, error:Error?) in
                        if error == nil {
                            //清空数组
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.headImageArray.removeAll(keepingCapacity: false)
                            self.dateArray.removeAll(keepingCapacity: false)
                            self.postPictureArray.removeAll(keepingCapacity: false)
                            self.postTextArray.removeAll(keepingCapacity: false)
                            self.postIdArray.removeAll(keepingCapacity: false)
                            
                            for object in objects! {
                                self.usernameArray.append((object as AnyObject).value(forKey: "username") as! String)
                                self.headImageArray.append((object as AnyObject).value(forKey: "headImage") as! AVFile)
                                self.dateArray.append((object as AnyObject).createdAt!)
                                self.postPictureArray.append((object as AnyObject).value(forKey: "postPicture") as! AVFile)
                                self.postTextArray.append((object as AnyObject).value(forKey: "title") as! String)
                                self.postIdArray.append((object as AnyObject).value(forKey: "postId") as! String)
                                
                            }
                            
                            //刷新表格视图
                            self.tableView.reloadData()
                            self.indicator.stopAnimating()
                            
                        } else {
                            print(error?.localizedDescription as Any)
                        }
                    })
            }
           } )
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postIdArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryCell

        //通过数组信息关联单元格中的UI控件
//        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
        cell.postIdLabel.text = postIdArray[indexPath.row]
        cell.postTextLabel.text = postTextArray[indexPath.row]
        cell.usernameLabel.text = usernameArray[indexPath.row]
            
        //配置用户头像
        headImageArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.headImageView.image = UIImage(data: data!)
        }
        
        //配置帖子照片
        postPictureArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.postPictureImageView.image = UIImage(data: data!)
        }
        
        //帖子的发布时间和当前时间的间隔差
        //获取帖子的创建时间
        let from = dateArray[indexPath.row]
        //获取当前的时间
        let now = Date()
        //创建Calendar.Componment类型的Set集合
        let componments : Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = Calendar.current.dateComponents(componments, from: from, to: now)
        if difference.second! <= 0 {
            cell.dateLabel.text = "现在"
        }
        
        if difference.second! > 0 && difference.minute! <= 0 {
            cell.dateLabel.text = "\(difference.second!)秒前."
        }
        
        if difference.minute! > 0 && difference.hour! <= 0 {
            cell.dateLabel.text = "\(difference.minute!)分前."
        }
        
        if difference.hour! > 0 && difference.day! <= 0 {
            cell.dateLabel.text = "\(difference.hour!)时前."
        }
        
        if difference.day! > 0 && difference.weekOfMonth! <= 0 {
            cell.dateLabel.text = "\(difference.day!)天前."
        }
        
        if difference.weekOfMonth! > 0 {
            cell.dateLabel.text = "\(difference.weekOfMonth!)周前."
        }

        //根据用户是否喜爱维护likeBtn按钮
        let didlike = AVQuery(className: "Likes")
        didlike.whereKey("by", equalTo: AVUser.current()?.username as Any)
        didlike.whereKey("to", equalTo: cell.postIdLabel.text as Any)
        didlike.countObjectsInBackground { (count:Int, error:Error?) in
            if count == 0 {
                cell.likeButton.setTitle("unlike", for: .normal)
                cell.likeButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
            } else {
                cell.likeButton.setTitle("like", for: .normal)
                cell.likeButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
            }
        }
        
        //计算本帖子的喜爱总数
        let countLikes = AVQuery(className: "Likes")
        countLikes.whereKey("to", equalTo: cell.postIdLabel.text as Any)
        countLikes.countObjectsInBackground { (count: Int, error: Error?) in
            cell.likeNumberLabel.text = "\(count)"
        }
        
        return cell
    }
    

    @IBAction func cameraButtonTapped(_ sender: Any) {
   
    }
    
    //MARK: - 暴风哭泣 这个方法不是写在UploadVC.swift文件中的，而是写在这里的！！！！！
    @IBAction func unwindToStoryTVC(unwindSegue: UIStoryboardSegue) {
        print("数据传过来啦！")
        let uploadVCView = unwindSegue.source as! UploadVC
        
        
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
