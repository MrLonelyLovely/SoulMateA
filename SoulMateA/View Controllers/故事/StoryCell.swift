//
//  StoryCell.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/21.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

//postCell

class StoryCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var postPictureImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var commentNumberLabel: UILabel!
    
    @IBOutlet weak var postIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utilities.circleTheImageView(headImageView)
        
        //设置likeBtn按钮的title文字的颜色为无色
        likeButton.setTitleColor(.clear, for: .normal)
        
        //双击照片like the posted image
        let likeDoubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleClickPostPicture))
        //按压屏幕的连续次数
        likeDoubleTap.numberOfTapsRequired = 2
        //在屏幕上的手指数
        likeDoubleTap.numberOfTouchesRequired = 1
        //这里为什么要加上？呢？？？？？
        postPictureImageView?.isUserInteractionEnabled = true
        postPictureImageView?.addGestureRecognizer(likeDoubleTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        
        //获取likeBtn按钮的title
        let title = (sender as AnyObject).title(for: .normal)
        
        //如果当前likeBtn按钮的状态是unlike，则将该帖子设置为like状态
        if title == "unlike" {
            let object = AVObject(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = postIdLabel.text
            object.saveInBackground { (success:Bool, error:Error?) in
                if success {
                    print("标记为： like！")
                    self.likeButton.setTitle("like", for: .normal)
                    self.likeButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                    //如果设置为喜爱，则发送通知给表格视图刷新表格
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                }
            }
        } else {
            //搜索Likes表中对应的记录
            let query = AVQuery(className: "Likes")
            query.whereKey("by", equalTo: AVUser.current()?.username as Any)
            query.whereKey("to", equalTo: postIdLabel.text as Any)
            query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
                for object in objects! {
                    //搜索到记录以后将其从Likes表中删除
                    (object as AnyObject).deleteInBackground({ (success:Bool, error:Error?) in
                        if success {
                            print("删除like记录，disliked")
                            self.likeButton.setTitle("unlike", for: .normal)
                            self.likeButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
                            
                            //如果设置为喜爱，则发送通知给表格视图刷新表格
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                        }
                    })
                }
            }
        }
    }
    
    //双击时执行该方法，实现点赞功能
    @objc func doubleClickPostPicture() {
        
        //创建一个爱心，大小为detailSharedImageView的2/3，中心与其一致，alpha值（透明度）为0.8
        let likeImg = UIImageView(image: UIImage(named: "unlike"))
        likeImg.frame.size.width = postPictureImageView.frame.width / 1.5
        likeImg.frame.size.height = postPictureImageView.frame.height / 1.5
        likeImg.center = postPictureImageView.center
        likeImg.alpha = 0.8
        self.addSubview(likeImg)
        
        //隐藏likeImg并使其变小，通过动画的方式，在0.4秒的时间将likeImg的alpha值从0.8变为0（消失），再将大小缩小为之前的十分之一
        UIView.animate(withDuration: 0.4, animations: {
            likeImg.alpha = 0
            likeImg.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        
        let title = likeButton.title(for: .normal)
        
        if title == "unlike" {
            let object = AVObject(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = postIdLabel.text
            object.saveInBackground { (success:Bool, error:Error?) in
                if success {
                    print("标记为： like！")
                    self.likeButton.setTitle("like", for: .normal)
                    self.likeButton.setBackgroundImage(UIImage(named: "like.png"), for: .normal)
                    //如果设置为喜爱，则发送通知给表格视图刷新表格
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                }
            }
        }
    }
    
}
