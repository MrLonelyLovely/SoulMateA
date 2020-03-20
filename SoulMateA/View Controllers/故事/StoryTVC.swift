//
//  StoryTVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/20.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class StoryTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var followerArray = [AVUser]()
    var postPictureArray = [AVFile]()
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    

    @IBAction func cameraButtonTapped(_ sender: Any) {
        
//        let alert = UIAlertController(title: "Oops!!!", message: "该用户名已被注册，请使用其他的用户名!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "好的惹", style: .cancel) { (action) in
//            self.userNameTextField.text = nil
//            self.passwordTextField.text = nil
//        }
//        alert.addAction(ok)
//        self.present(alert, animated: true, completion: nil)
        
//        let alertSheet = UIAlertController(title: "", message: "拍摄", preferredStyle: .actionSheet)
        
        let imageTaker = UIImagePickerController()
        imageTaker.delegate = self
        
//        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        let actionSheet = UIAlertController()
        
        actionSheet.addAction(UIAlertAction(title: "拍摄", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imageTaker.sourceType = .camera
                self.present(imageTaker, animated: true, completion: nil)
            } else {
                print("Camera not availble")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: {(action:UIAlertAction) in
            imageTaker.sourceType = .photoLibrary
            self.present(imageTaker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        //不是imageTaker，注意了
        self.present(actionSheet, animated: true, completion: nil)
        
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
