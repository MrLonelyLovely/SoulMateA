//
//  MessageListTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/25.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVOSCloudIM

var wantChatUser:AVUser?

class MessageListTVC: UITableViewController {

//    var wantChatUser = willChatUser
    var wantChatUsername:String?
    
    var conversations = [AVIMConversation]()
    
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 67
        
//        print("将要聊天的用户是：\(willChatUser?.username)")
//        print("当前用户clientid是：\(userClient.clientId)")
        
        //设置refresher
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.view.addSubview(refresher)
        
        setUpConversation()
        
        //异步进程实现顺序执行
//        let concurrentQueue = DispatchQueue(label: "com.cp.concurrent", attributes: .concurrent)
//        concurrentQueue.async {
//            self.setUpConversation()
//        }
//
//        concurrentQueue.async(flags: .barrier, execute: {
//
//            sleep(1)
//
//        })
//
//        concurrentQueue.async {
//            self.loadLastMessage()
//            print("对话条数是：\(self.conversations.count)")
//        }
        
        //设置当StoryTVC接收到liked通知后，执行refresh方法
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init(rawValue: "updateTheMessList"), object: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

        cell.lastMessageContentLabel.text = (conversations[indexPath.row].lastMessage as! AVIMTextMessage).text
        print("最后一条消息是：\((conversations[indexPath.row].lastMessage as! AVIMTextMessage).text)")
        
        //(conversation as? AVIMConversation)?.attributes!["messageContent"] as? String
        if conversations[indexPath.row].attributes!["toUser"] as? String == AVUser.current()?.username {
            cell.usernameLabel.text = conversations[indexPath.row].attributes!["fromUser"] as? String
            
        } else {
            cell.usernameLabel.text = conversations[indexPath.row].attributes!["toUser"] as? String
        }
        wantChatUsername = cell.usernameLabel.text
        
        let userQuery = AVQuery(className: "_User")
        userQuery.whereKey("username", equalTo: wantChatUsername!)
        let user = userQuery.getFirstObject()
        let leftAvaQuery = user!.object(forKey: "avaHeadImage") as! AVFile
        leftAvaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
            } else {
                cell.headImageView.image = UIImage(data: data!)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if conversations[indexPath.row].attributes!["toUser"] as? String == AVUser.current()?.username {
            wantChatUsername = conversations[indexPath.row].attributes!["fromUser"] as? String
            
        } else {
            wantChatUsername = conversations[indexPath.row].attributes!["toUser"] as? String
        }
        
        let userQuery = AVQuery(className: "_User")
        userQuery.whereKey("username", equalTo: wantChatUsername!)
        let user = userQuery.getFirstObject()
        wantChatUser = user as? AVUser
    }
    
    func setUpConversation() {
        
        let currentUser = AVUser.current()

        userClient.open { (success:Bool, error:Error?) in
            if success {

//                let usersArray:[String] = [currentUser!.username!,willChatUser!.username!]
                
                let queryA = userClient.conversationQuery()
                let queryB = userClient.conversationQuery()
                queryA.whereKey("attr.fromUser", equalTo: (currentUser?.username)!)
                queryB.whereKey("attr.toUser", equalTo: (currentUser?.username)!)
//                let query = AVQuery.orQuery(withSubqueries: [queryA,queryB])
                let query = AVIMConversationQuery.orQuery(withSubqueries: [queryA,queryB])
//                query.whereKey("m", containsAllObjectsIn: usersArray)
                
                query.findConversations { (conversations:[Any]?, error:Error?) in
                    if error == nil && conversations != nil {
                        self.conversations = conversations as! [AVIMConversation]
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
//                        for conversation in conversations!  {
//                            self.conversations.append(conversation as! AVIMConversation)
//                        }
                    } else {
                        print("尝试查找对话时的错误是： \(error?.localizedDescription as Any)")
                    }
                }
            } else {
                print("尝试打开client时的错误是： \(error?.localizedDescription as Any)")
            }
        }

    }

    @objc func refresh() {
//        self.tableView.reloadData()
        self.setUpConversation()
    }
    
    func loadLastMessage() {
        
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
