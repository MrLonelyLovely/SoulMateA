//
//  HisDetailPageCVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/19.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class HisDetailPageCVC: UICollectionViewController {

    var user:AVUser?
    
    //刷新控件
    var refresher: UIRefreshControl!
    
    //每页载入帖子（图片）的数量
    var page: Int = 12
    
    var postIdArray = [String]()
    var postPictureArray = [AVFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置集合视图在垂直方向上有反弹的效果，否则不能加载刷新控件
        self.collectionView?.alwaysBounceVertical = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //设置refresher控件到集合视图中
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postPictureArray.count
    }

    //有了这个方法才会有UI元素显示在屏幕上
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HisDetailPageHeader", for: indexPath) as! HisDetailPageHeader
        
//        header.usernameTextLabel.text = user?.username
        let avaQuery = user!.object(forKey: "avaHeadImage") as! AVFile
        avaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
            } else {
                header.usernameTextLabel.text = self.user?.username
                header.headImage.image = UIImage(data: data!)
//                header.followButtonTapped(UIButton())
            }
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HisPostCell", for: indexPath) as! HisPostCell
        
        postPictureArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.postPictureImageView.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        return cell
    }
    
    @objc func refresh() {
        
        collectionView?.reloadData()
        //停止刷新动画
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        
        let query = AVQuery(className: "Posts")
        
        //害，user?.username错误地写成了user，又是一次血的教训
        query.whereKey("username", equalTo: user?.username)
        query.limit = page
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            //查询成功
            if error == nil {
                //清空两个数组
                self.postIdArray.removeAll(keepingCapacity: false)
                self.postPictureArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.postIdArray.append((object as AnyObject).value(forKey: "postId") as! String)
                    self.postPictureArray.append((object as AnyObject).value(forKey: "postPicture") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }

}
