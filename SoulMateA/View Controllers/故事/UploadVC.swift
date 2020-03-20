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

        let imgTap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imgTap.numberOfTapsRequired = 1
        imgTap.numberOfTouchesRequired = 1
        postPictureImageView.isUserInteractionEnabled = true
        postPictureImageView.addGestureRecognizer(imgTap)
        
    }
    
    @objc func selectImage() {
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("从 此界面UploadVC 跳转到 StoryTVC界面 之前执行的操作")
        
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
//                self.dismiss(animated: true, completion: nil)
            }
        }
        
//        if segue.identifier == "upload" {
//
//            //隐藏键盘
//            self.view.endEditing(true)
//
//            let postObject = AVObject(className: "Posts")
//            postObject["user"] = AVUser.current()
//            postObject["username"] = AVUser.current()?.username
//
//            if postTextTextFiled.text!.isEmpty {
//                postObject["title"] = ""
//            } else {
//                postObject["title"] = postTextTextFiled.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            }
//
//            let avaData = postPictureImageView.image?.jpegData(compressionQuality: 0.5)
//            let avaFile = AVFile(name: "postPicture.jpg", data: avaData!)
//            postObject["postPicture"] = avaFile
//
//            //将数据存到LC云端
//            postObject.saveInBackground { (success:Bool, error:Error?) in
//                if error == nil {
//                    //将TabBar控制器中索引值为0的子控制器，显示在手机屏幕上
//                    //self.tabBarController!.selectedIndex = 3
//                    print("upload successed!")
//                }
//            }
//        }
    }
    
    
    
    
    
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
    
    //                let alert = UIAlertController(title: "Oops!!!", message: "该用户名已被注册，请使用其他的用户名!", preferredStyle: .alert)
    //                let ok = UIAlertAction(title: "好的惹", style: .cancel) { (action) in
    //                    self.userNameTextField.text = nil
    //                    self.passwordTextField.text = nil
    //                }
    //                alert.addAction(ok)
    
    
    //紧接着（配合）takePicButton使用，否则点击图片后返回空值
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //设置detailSharedImageViwInDP去展示已选好的图片selectedImg
        postPictureImageView.image = selectedImg
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
