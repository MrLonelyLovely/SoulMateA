//
//  ChatRoomVCFromMessList.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/28.
//  Copyright © 2020 陈沛. All rights reserved.
//

//import UIKit
//
//class ChatRoomVCFromMessList: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//}


import UIKit
import AVOSCloudIM

//let userClientFromMessList:AVIMClient = AVIMClient(clientId: AVUser.current()!.username!)


class ChatRoomVCFromMessList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
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
//            self.setUpConversation()
        }

        concurrentQueue.async(flags: .barrier, execute: {
            
            sleep(1)
            
        })

        concurrentQueue.async {
            self.loadHistoryMessage()
            print("something")
        }

    }
    

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
        let currentUser = AVUser.current()
        
        userClient.open { (success:Bool, error:Error?) in
            if success {
                let usersArray:[String] = [currentUser!.username!,wantChatUser!.username!]
                        
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
                                    self.messageContentTextView.text = ""
                                    //如果设置为喜爱，则发送通知给表格视图刷新表格
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTheMessList"), object: nil)
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
        return messageArray.count
    }
    
        
    func tableView(_ tableView: UITableView,estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as! ChatRoomCell
        
        cell.update(with: messageArray[indexPath.row])
        
        //设置左边用户的头像
        let leftAvaQuery = wantChatUser!.object(forKey: "avaHeadImage") as! AVFile
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
                userClient.createConversation(withName: (wantChatUser?.username)!, clientIds: [(wantChatUser?.username)!], attributes: ["fromUser":(currentUser?.username)!,"toUser":(wantChatUser?.username)!,"messageContent":"-"], options: AVIMConversationOption.unique) { (conversation:AVIMConversation?, error:Error?) in
                    if error == nil {
                        mainQueueExecuting {
                            self.navigationItem.title = wantChatUser?.username
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

                let usersArray:[String] = [currentUser!.username!,wantChatUser!.username!]
                
                let query = userClient.conversationQuery()
                query.whereKey("m", containsAllObjectsIn: usersArray)
                
                query.findConversations { (conversations:[Any]?, error:Error?) in
                    if error == nil && conversations != nil {
                        
                        for conversation in conversations!  {
                            (conversation as! AVIMConversation).queryMessagesFromServer(withLimit: 100) { (messages:[Any]?, error:Error?) in
                                self.messageArray = messages! as! [AVIMTextMessage]
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: IndexPath(row: self.messageArray.count - 1, section: 0), at: .bottom, animated: false)
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
    
}


