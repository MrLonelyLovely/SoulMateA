//
//  ResetPswVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/22.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class ResetPswVC: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var savePswButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
    }
    
    func setUpElements() {
        
        Utilities.styleTextField(oldPasswordTextField)
        Utilities.styleTextField(newPasswordTextField)

        Utilities.styleFilledButton(savePswButton)
        
//        Utilities.styleTextField(verificationCodeTextField)
//        Utilities.styleTextField(confirmNewPasswordTextField)
//        Utilities.styleFilledButton(sendVerificationCodeButton)
    }

    @IBAction func sendVerificationCodeButtonTapped(_ sender: Any) {
        
        //
    }
    
    @IBAction func savePswButtonTapped(_ sender: Any) {
        
        let user = AVUser.current()
        user?.updatePassword(oldPasswordTextField.text!, newPassword: newPasswordTextField.text!, block: { (result:Any, error:Error?) in
            
            if error == nil {
                let alert = UIAlertController(title: "Yeah!", message: "重置密码成功，请重新登录", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好的", style: .cancel) {(action) in
                    self.transitionToLoginPage()
//                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "原密码不对嗷，请重新输入原密码", preferredStyle: .alert)
                let ok = UIAlertAction(title: "嘤嘤嘤", style: .cancel) { (action) in
                    self.oldPasswordTextField.text = ""
                    self.newPasswordTextField.text = ""
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })

    }
    
    
    func transitionToLoginPage() {
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginVC) as! LoginVC
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
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
