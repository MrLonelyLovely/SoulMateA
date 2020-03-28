//
//  MessageListTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/25.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class MessageListTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 67
        
        //异步进程实现顺序执行
        let concurrentQueue = DispatchQueue(label: "com.cp.concurrent", attributes: .concurrent)
        concurrentQueue.async {
            self.setUpConversation()
        }

        concurrentQueue.async(flags: .barrier, execute: {
            
            sleep(1)
            
        })

        concurrentQueue.async {
            self.loadLastMessage()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

//        let leftAvaQuery = willChatUser!.object(forKey: "avaHeadImage") as! AVFile
//        leftAvaQuery.getDataInBackground { (data: Data?, error: Error?) in
//            if data == nil {
//                print(error?.localizedDescription as Any)
//            } else {
//                cell.headImageView.image = UIImage(data: data!)
//            }
//        }

        return cell
    }
    
    func setUpConversation() {
        
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
