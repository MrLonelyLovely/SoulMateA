//
//  ChatRoomVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/25.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVOSCloudIM

let userClient:AVIMClient = AVIMClient(clientId: AVUser.current()!.username!)


class ChatRoomVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //,AVIMTypedMessageSubclassing
//    static func classMediaType() -> AVIMMessageMediaType {
//        return AVIMMessageMediaType.init(rawValue: 1)!
//    }
    
        
    var messageContenArray = [String]()
    var messageArray = [AVIMTextMessage]()
    var currentConversation:AVIMConversation?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageContentTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //不要忘了设置delegate，否则会无法显示cell，但不会报错
        messageContentTextView.delegate = self as UITextViewDelegate
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self
        //去掉tableView的cell之间的间隔线
        tableView.separatorStyle = .none

        //异步进程实现顺序执行
        let concurrentQueue = DispatchQueue(label: "com.cp.concurrent", attributes: .concurrent)
        concurrentQueue.async {
            self.setUpConversation()
        }

        concurrentQueue.async(flags: .barrier, execute: {
            
            sleep(1)
            
        })

        concurrentQueue.async {
            self.loadHistoryMessage()
//            print(self.messageArray.count)
//            print("消息的条数：\(self.messageArray.count)")
        }
        
        
        
        
//        print("客户端ID是：\(userClient.clientId)")
//        print("最近会话ID是：\(currentConversation?.conversationId)")
//        cell.update(with: messageArray[indexPath.row])
        
//        sendMessageButtonTapped((Any).self)
    }
    

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
        let currentUser = AVUser.current()
        
        userClient.open { (success:Bool, error:Error?) in
            if success {
                let usersArray:[String] = [currentUser!.username!,willChatUser!.username!]
                        
                let query = userClient.conversationQuery()
                query.whereKey("m", containsAllObjectsIn: usersArray)
                        
                query.findConversations { (conversations:[Any]?, error:Error?) in
                    if error == nil && conversations != nil {
                        for conversation in conversations!  {
                            let messageContent = self.messageContentTextView.text!
                            let message = AVIMTextMessage(text: messageContent, attributes: nil)
                            (conversation as! AVIMConversation).send(message) { (success:Bool, error:Error?) in
                                if success {
                                    self.loadHistoryMessage()
                                } else {
                                    print("尝试发送消息时的错误是： \(error?.localizedDescription as Any)")
                                }
                            }
                        }
                    } else {
                        print("尝试查找对话时的错误是： \(error?.localizedDescription as Any)")
                    }
                    }
           } else {
                print("尝试打开client时的错误是： \(error?.localizedDescription as Any)")
           }
        }
        
    }
    
    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messageContenArray.count
        return messageArray.count
    }
    
        
    func tableView(_ tableView: UITableView,estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
        
//        mainQueueExecuting {
//            var originBottomIndexPath: IndexPath?
//            if !self.messageArray.isEmpty {
//                originBottomIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
//            }
//            self.messages.append(message)
//            let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
//            self.tableView.insertRows(at: [indexPath], with: .bottom)
//            if
//                let bottomIndexPath = originBottomIndexPath,
//                let bottomCell = self.tableView.cellForRow(at: bottomIndexPath),
//                self.tableView.visibleCells.contains(bottomCell)
//            {
//                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
        
//        var originBottomIndexPath: IndexPath?
//        if !self.messageArray.isEmpty {
//            originBottomIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
//        }
//        let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .bottom)
//        if
//            let bottomIndexPath = originBottomIndexPath,
//            let bottomCell = self.tableView.cellForRow(at: bottomIndexPath),
//            self.tableView.visibleCells.contains(bottomCell)
//        {
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//
        cell.update(with: messageArray[indexPath.row])
        
        //设置左边用户的头像
        let leftAvaQuery = willChatUser!.object(forKey: "avaHeadImage") as! AVFile
        leftAvaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
            } else {
                cell.leftHeadImageView.image = UIImage(data: data!)
            }
        }

        //设置右边用户的头像
        let avaQuery = AVUser.current()!.object(forKey: "avaHeadImage") as! AVFile
        avaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
            } else {
                cell.rightHeadImageView.image = UIImage(data: data!)
            }
        }
        
        return cell
}

    func setUpConversation() {
        
        let currentUser = AVUser.current()

        userClient.open { (success:Bool, error:Error?) in
            if error == nil {
                //创建会话
                userClient.createConversation(withName: (willChatUser?.username)!, clientIds: [(willChatUser?.username)!], attributes: ["fromUser":(currentUser?.username)!,"toUser":(willChatUser?.username)!,"messageContent":"-"], options: AVIMConversationOption.unique) { (conversation:AVIMConversation?, error:Error?) in
                    if error == nil {
                        mainQueueExecuting {
                            self.navigationItem.title = willChatUser?.username
                        }
                        
                        //可以在这里查询历史消息记录吗？
                        print("创建会话成功！")
                    } else {
                        print("尝试创建会话时的错误是：\(error?.localizedDescription as Any)")
                    }
                }
            } else {
                
                print("尝试打开client的错误是：\(error?.localizedDescription as Any)")
            }
        }
                    
    }
   
    func loadHistoryMessage() {
        //在云端查询历史消息记录
        let currentUser = AVUser.current()
                 
        
        userClient.open { (success:Bool, error:Error?) in
            if success {

                let usersArray:[String] = [currentUser!.username!,willChatUser!.username!]
                
                let query = userClient.conversationQuery()
                query.whereKey("m", containsAllObjectsIn: usersArray)
                
                query.findConversations { (conversations:[Any]?, error:Error?) in
                    if error == nil && conversations != nil {
                        
                        for conversation in conversations!  {
                            
//                            print("对话ID是：")
//                            print((conversation as! AVIMConversation).conversationId)
                            (conversation as! AVIMConversation).queryMessagesFromServer(withLimit: 20) { (messages:[Any]?, error:Error?) in
                                self.messageArray = messages! as! [AVIMTextMessage]
//                                for message in self.messageArray {
//                                    print("消息内容是：\(message.text)")
//                                }
//                                print("消息有：\(self.messageArray)")
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        print("尝试查找对话时的错误是： \(error?.localizedDescription as Any)")
                    }
                }
            } else {
                print("尝试打开client时的错误是： \(error?.localizedDescription as Any)")
            }
        }
        
    }
                /*
                       query.whereKey("attr.fromUser", equalTo: (currentUser?.username)!)
//                query.whereKey("attr.fromUser", contains: (currentUser?.username)!)
//                query.whereKey("attr.toUser", contains: (willChatUser?.username)!)
                        query.whereKey("attr.toUser", equalTo: (willChatUser?.username)!)
//                query.addDescendingOrder("createAt")
                query.addAscendingOrder("createAt")
        //                query.
                query.findConversations { (conversations:[Any]?, error:Error?) in
                        if error == nil {
                            print("对话条数是：")
                            print(conversations?.count)
                            self.messageContenArray.removeAll(keepingCapacity: false)
                            for conversation in conversations! {
                                self.messageContenArray.append(((conversation as? AVIMConversation)?.attributes!["messageContent"] as? String)!)
                            }
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                            })
                        }
                    print(self.messageContenArray)
                    }
*/
                
    //        let query = AVQuery(className: "_Conversation")
    //        client.conversationQuery()
    //        client.conversation(with: AVIMKeyedConversation.creator)
            
        
        
    

}


//                query.whereKey("attr.fromUser", equalTo: (currentUser?.username)!)
//                query.whereKey("attr.fromUser", contains: (currentUser?.username)!)
//                query.whereKey("attr.toUser", contains: (willChatUser?.username)!)
//                query.whereKey("attr.toUser", equalTo: (willChatUser?.username)!)
//                query.addDescendingOrder("createAt")
//                query.
                
//                query.findConversations { (conversations:[Any]?, error:Error?) in
//                    if error == nil {
//                        print("对话条数是：")
//                        print(conversations?.count)
//                        for conversation in conversations! {
//                            cell.messageTextContentLabel.text = (conversation as? AVIMConversation)?.attributes!["messageContent"] as? String
//                        }
//                    }
//                }


//                client.conversation(forId: "5e7b2cec90aef5aa8438b50c")?.queryMessages(withLimit: 10, callback: { (objects:[Any]?, error:Error?) in
//                    if error == nil {
//                        for object in objects! {
//                            cell.update(with: object as! AVIMMessage)
//                            print("获取消息成功！")
//                        }
//
//                    } else {
//                        print("错误是如下：")
//                        print(error?.localizedDescription as Any)
//                    }
//                })




//cell里的代码

//                client.conversation(with: AVIMKeyedConversation)
//                client.conversationQuery()
                //options: AVIMConversationOption.unique 或者 options: AVIMConversationOption(rawValue: 1)

//        print("消息的条数：\(messageArray.count)")
//        cell.update(with: messageArray[indexPath.row])
        
        // 打开 client，与云端进行连接 AVIMMessage
//        userClient.open { (success:Bool, error:Error?) in
//            if success {
//                print("对话ID是：\(self.currentConversation?.conversationId)")
////                self.currentConversation?.queryMessagesFromServer(withLimit: 10, callback: { (messages:[Any]?, error:Error?) in
////                    if error == nil {
////                        print("消息条数是：\(messages?.count)")
////                        for message in messages! {
////                            cell.update(with: message as! AVIMTypedMessage)
////                        }
////                    } else {
////                        print("消息查询的错误是：\(error?.localizedDescription as Any)")
////                    }
////                })
//            }
//            else {
//                print("试图打开client的错误是：\(error?.localizedDescription as Any)")
//            }
//        }
        
        
        
//        cell.messageTextContentLabel.text = messageContenArray[indexPath.row]
//        print(messageContenArray[indexPath.row])
        
        /*
        //在云端查询历史消息记录
        let currentUser = AVUser.current()
         
        // 以 AVUser 实例创建了一个 client
        let client = AVIMClient(user: currentUser!)
        client.open { (success:Bool, error:Error?) in
            if success {
                let query = client.conversationQuery()
                
                query.getConversationById("5e7c3507678c2e0075ef3c72") { (conversation:AVIMConversation?, error:Error?) in
                    if conversation != nil {
//                        let message = conversation?.lastMessage as? AVIMTypedMessage
                        conversation?.queryMessages(withLimit: 10, callback: { (messages:[Any]?, error:Error?) in
                            if error == nil {
                                for message in messages! {
                                    print((message as? AVIMTypedMessage)!.text!)
                                    self.navigationItem.title = conversation?.name
                                    cell.messageFromLabel.text = conversation?.attributes!["toUser"] as? String
                                    
                                    cell.update(with: (message as? AVIMTypedMessage)!)
                                }
                            } else {
                                print(error?.localizedDescription as Any)
                            }
                            } as! AVIMArrayResultBlock)
                        
                        
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                }
            }
        }
        */





//        cell.leftHeadImageView.image = UIImage(named: "1.png")
        //在云端查询历史消息记录
//        let currentUser = AVUser.current()
//
//
//        userClient.open { (success:Bool, error:Error?) in
//            if success {
//                //client.messageQueryCacheEnabled = false
//                let usersArray:[String] = [currentUser!.username!,willChatUser!.username!]
//
//                let query = userClient.conversationQuery()
//                query.whereKey("m", containsAllObjectsIn: usersArray)
//
//                query.findConversations { (conversations:[Any]?, error:Error?) in
//                    if error == nil && conversations != nil {
//                        for conversation in conversations!  {
//        //                            print("对话ID是：")
//        //                            print((conversation as! AVIMConversation).conversationId)
//                                    (conversation as! AVIMConversation).queryMessagesFromServer(withLimit: 10) { (messages:[Any]?, error:Error?) in
//                                        self.messageArray = messages! as! [AVIMTextMessage]
////                                        print("消息有：\(self.messageArray)")
//                                        for message in self.messageArray {
//                                            cell.update(with: message)
//                                        }
//                                    }
//                                }
//                            } else {
//                                print("尝试查找对话时的错误是： \(error?.localizedDescription as Any)")
//                            }
//                        }
//                    } else {
//                        print("尝试打开client时的错误是： \(error?.localizedDescription as Any)")
//                    }
//                }
