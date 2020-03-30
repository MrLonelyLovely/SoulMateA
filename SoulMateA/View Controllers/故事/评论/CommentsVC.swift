//
//  CommentsVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/29.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

var commentuuid = [String]()
var commentowner = [String]()

class CommentsVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var sendCommentButton: UIButton!
    
    var refresher = UIRefreshControl()
    
    var usernameArray = [String]()
    var headImageArray = [AVFile]()
    var commentArray = [String]()
    
    var pageSize: Int = 15
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        commentTextView.delegate = self as UITextViewDelegate
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self
        
        tableView.rowHeight = 67
        
        self.navigationItem.title = "评论"
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        loadComments()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.usernameLabel.text = usernameArray[indexPath.row]
        cell.commentContentLabel.text = commentArray[indexPath.row]
        headImageArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            cell.headImageView.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    
    
    @IBAction func sendCommentButtonTapped(_ sender: Any) {
        //1.在表格视图中添加一行
        usernameArray.append((AVUser.current()?.username!)!)
        headImageArray.append(AVUser.current()!.object(forKey: "avaHeadImage") as! AVFile)
//        dateArray.append(Date())
        //除去文本两端的空格和换行回车
        commentArray.append(commentTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        tableView.reloadData()
        
        //2.发送评论到云端
        let commentObj = AVObject(className: "Comments")
        commentObj["to"] = commentuuid.last!
        commentObj["username"] = AVUser.current()?.username
        commentObj["ava"] = AVUser.current()?.object(forKey: "avaHeadImage")
        commentObj["comment"] = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        commentObj.saveEventually()
        
        //！！！！！使表格视图定位到最后的一个单元格的底部
        self.tableView.scrollToRow(at: IndexPath(item: commentArray.count - 1, section: 0), at: .bottom, animated: false)
        
        commentTextView.text = ""
    }
    
    @objc func back() {
        _ = self.navigationController?.popViewController(animated: true)
        //从数组中清除评论的uuid
        if !commentuuid.isEmpty {
            commentuuid.removeLast()
        }
        //从数组中清除评论所有者
        if !commentowner.isEmpty {
            commentowner.removeLast()
        }
    }
    
    func loadComments() {
        
        //1.合计出所有的评论的数量
        let countQuery = AVQuery(className: "Comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        //因为CommentVC类中的方法调用是在闭包中定义，所以需要使用self进行显式调用
        countQuery.countObjectsInBackground { (count:Int, error:Error?) in
            if self.pageSize < count {
                self.refresher.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
                self.tableView.addSubview(self.refresher)
            }
            
            //2.获取最新的self。page数量的评论
            let query = AVQuery(className: "Comments")
            query.whereKey("to", equalTo: commentuuid.last!)
            //第一次获取的数量要忽略count-page的数量，这样会保证只得到最新的page数量记录
            query.skip = count - self.pageSize
            query.addAscendingOrder("createdAt")
            //当通过find方法获取到记录以后，先将数据存储到四个独立的数组中，再刷新表格视图，并让表格定位到最后的单元格上
            query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                if error == nil {
                    //清空数组
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.headImageArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.usernameArray.append((object as AnyObject).object(forKey: "username") as! String)
                        self.headImageArray.append((object as AnyObject).object(forKey: "ava") as! AVFile)
                        self.commentArray.append((object as AnyObject).object(forKey: "comment") as! String)
                        self.tableView.reloadData()
                        //!!!!!
                        self.tableView.scrollToRow(at: IndexPath(row: self.commentArray.count - 1, section: 0), at: .bottom, animated: false)
                    }
                }else {
                    print(error?.localizedDescription as Any)
                }
            })
            
        }
    }
    
    @objc func loadMore() {
        
        //1.合计出所有的评论的数量
        let countQuery = AVQuery(className: "Comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        //先计算出当前帖子的评论总数，然后在闭包中停止刷新动画
        //若评论总数小于分页数，即page>=count，则意味着不需要刷新功能，把refresh对象从tableView中移除
        countQuery.countObjectsInBackground { (count:Int, error:Error?) in
            //让refresh停止刷新动画
            self.refresher.endRefreshing()
            if self.pageSize >= count {
                self.refresher.removeFromSuperview()
            }
            
            //2.载入更多的评论
            if self.pageSize < count {
                self.pageSize = self.pageSize + 15
                
                //从云端查询page的记录
                let query = AVQuery(className: "Comments")
                query.whereKey("to", equalTo: commentuuid.last!)
                query.skip = count - self.pageSize
                query.addAscendingOrder("createdAt")
                query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                    if error == nil {
                        //清空数组
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.commentArray.removeAll(keepingCapacity: false)
                        self.headImageArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append((object as AnyObject).object(forKey: "username") as! String)
                            self.headImageArray.append((object as AnyObject).object(forKey: "ava") as! AVFile)
                            self.commentArray.append((object as AnyObject).object(forKey: "comment") as! String)
                        }
                        self.tableView.reloadData()
                    }else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        }
    }
    
    // MARK: - UITextViewDelegate
//    func textViewDidChange(_ textView: UITextView) {
//        <#code#>
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
