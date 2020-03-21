//
//  UploadVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/20.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var postTextTextFiled: UITextField!
    
    @IBOutlet weak var postPictureImageView: UIImageView!
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        uploadButton.isEnabled = false
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imgTap.numberOfTapsRequired = 1
        imgTap.numberOfTouchesRequired = 1
        postPictureImageView.isUserInteractionEnabled = true
        postPictureImageView.addGestureRecognizer(imgTap)
        
        
        
        
    }
    
    @objc func selectImage() {
        
        let imageTaker = UIImagePickerController()
                imageTaker.delegate = self
                
        // let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("从 此界面UploadVC 跳转到 StoryTVC界面 之前执行的操作")
        
        //隐藏键盘
        self.view.endEditing(true)
        
        let postObject = AVObject(className: "Posts")
        postObject["user"] = AVUser.current()
        postObject["username"] = AVUser.current()?.username
        
        postObject["headImage"] = AVUser.current()?.value(forKey: "avaHeadImage") as! AVFile
        
        //设置每个帖子的唯一id
        postObject["postId"] = "\(String(describing: AVUser.current()?.username!)) \(NSUUID().uuidString)"
        
        if postTextTextFiled.text!.isEmpty {
            postObject["title"] = ""
        } else {
            postObject["title"] = postTextTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let avaData = postPictureImageView.image?.jpegData(compressionQuality: 0.5)
        let avaFile = AVFile(name: "postPicture.jpg", data: avaData!)
        postObject["postPicture"] = avaFile
        
        //将数据存到LC云端
        postObject.saveInBackground { (success:Bool, error:Error?) in
            if error == nil {
//                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
    /*
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
//        let user = AVUser.current()
//        let testObject = AVObject(className: "TestObject")
//        user.password = passwordTextField.text

        //隐藏键盘
        self.view.endEditing(true)
        
        let postObject = AVObject(className: "Posts")
        postObject["user"] = AVUser.current()
        postObject["username"] = AVUser.current()?.username
        
        if postTextTextFiled.text!.isEmpty {
            postObject["title"] = ""
        } else {
            postObject["title"] = postTextTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let avaData = postPictureImageView.image?.jpegData(compressionQuality: 0.5)
        let avaFile = AVFile(name: "postPicture.jpg", data: avaData!)
        postObject["postPicture"] = avaFile
        
        //将数据存到LC云端
        postObject.saveInBackground { (success:Bool, error:Error?) in
            if error == nil {
                

                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
        */
    
    //紧接着（配合）takePicButton使用，否则点击图片后返回空值
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //设置detailSharedImageViwInDP去展示已选好的图片selectedImg
        postPictureImageView.image = selectedImg
        
        picker.dismiss(animated: true, completion: nil)
        
        uploadButton.isEnabled = true

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    

}
