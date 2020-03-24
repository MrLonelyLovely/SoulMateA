//
//  ModifyUsernameVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/23.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class ModifyUsernameVC: UIViewController {

    @IBOutlet weak var newUsernameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
    }
    
    func setUpElements() {
        
        Utilities.styleTextField(newUsernameTextField)
        Utilities.styleFilledButton(saveButton)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
        let user = AVUser.current()
        user?.username = newUsernameTextField.text!
//        user?.save()
        user?.saveInBackground()
        
        let alert = UIAlertController(title: "Yeah", message: "修改昵称成功，请重新登录", preferredStyle: .alert)
        let ok = UIAlertAction(title: "好的", style: .cancel) { (action) in
//            self.dismiss(animated: true, completion: nil)
            self.transitionToLoginPage()
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
 
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
