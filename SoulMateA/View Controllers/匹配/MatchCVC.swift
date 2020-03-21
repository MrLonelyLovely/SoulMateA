//
//  MatchCollectionVC.swift
//  SoulMate
//
//  Created by Apui on 2020/3/15.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
//import AVOSCloud

var mayWillMatchUser:AVUser?

class MatchCVC: UICollectionViewController {

//    let name: [String] = ["usa","china","uk","japan","mexico","india"]
    var matchArray = [AVUser]()
//    var hisuser:AVUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        loadUsers()
        
    }
    
    func loadUsers() {
        let query = AVFileQuery(className: "_User")
        //哭了，把query.whereKey("avaHeadImage", equalTo: "ava.jpg")换成query.whereKeyExists("avaHeadImage")就可以了，暴风哭泣了
        query.whereKeyExists("avaHeadImage")
//        query.whereKey("avaHeadImage", equalTo: "ava.jpg")
        query.limit = 10
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            if error == nil {
                
                self.matchArray.removeAll(keepingCapacity: false)
                
                self.matchArray = objects! as! [AVUser]
                print("matchArray Number: \(self.matchArray.count)")
//                matchArrayA = self.matchArray
//                for object in objects! {
//                    self.matchArray.append(((object as AnyObject)).value(forKey: "avaHeadImage") as! AVFile)
//                }
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }

    }
    
    
    // MARK: UICollectionViewDataSource

    //一定不能设置为0，为0会什么都不显示
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(matchArray.count)
        return matchArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*
        var cell = UICollectionViewCell()

        // Configure the cell
        if let matchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath)  as? MatchCVCell {

            matchCell.configure(with: name[indexPath.row])

            cell = matchCell
        }
    */
        

       let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath)  as! MatchCVCell
        
        cell.contryNameLabel.text = matchArray[indexPath.row].username
        
        let ava = matchArray[indexPath.row].object(forKey: "avaHeadImage") as! AVFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.headImageView.image = UIImage(data: data!)

            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected Contry: \(name[indexPath.row])")
        
        mayWillMatchUser = matchArray[indexPath.row]
//        hisuser = matchArray[indexPath.row]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHisDetail" {
            let descriptionVC = segue.destination as! HisDetailPageCVC
            if let selectedCell = sender as? MatchCVCell {
                let indexPath = collectionView.indexPath(for: selectedCell)!
                let selectedUser = matchArray[(indexPath as NSIndexPath).row]
                descriptionVC.user = selectedUser
            }
        }
    }
    
//    func transitiontoHome() {
//        let homeTabBarController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeTabBarController) as! MyTabBarController
//        view.window?.rootViewController = homeTabBarController
//        view.window?.makeKeyAndVisible()
//    }
//
//    func transitionToHisDetailPage() {
//
//    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
