//
//  MyDetailPageCVC.swift
//  SoulMate
//
//  Created by Apui on 2020/3/16.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class MyDetailPageCVC: UICollectionViewController {
    
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

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        
//        return postPictureArray.count == 0 ? 0 : 30
        return postPictureArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyDetailPageHeader", for: indexPath) as! MyDetailPageHeader
        
        let user = AVUser.current()
        
        let avaQuery = user!.object(forKey: "avaHeadImage") as! AVFile
        avaQuery.getDataInBackground { (data: Data?, error: Error?) in
            if data == nil {
                print(error?.localizedDescription as Any)
                
            } else {
                header.usernameLabel.text = user?.username
                header.headImage.image = UIImage(data: data!)
            }
        }
            
        return header
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostCell", for: indexPath) as! MyPostCell
        
        //postPictureArray[0].getDataInBackground
        postPictureArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.myPostPictureImageView.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    
        return cell
    }
    
    //该方法可以用来设置单元格大小，需增加协议UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //统一设置为控制器视图的1/3大小
        let size = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)

        return size
    }

    @objc func refresh() {
        
        collectionView?.reloadData()
        //停止刷新动画
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()!.username!)
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
