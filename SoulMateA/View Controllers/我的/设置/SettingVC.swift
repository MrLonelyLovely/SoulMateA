//
//  SettingVC.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/22.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var modifyUsernameButton: UIButton!
    
    @IBOutlet weak var modifyPasswordButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.styleHollowButton(modifyUsernameButton)
        Utilities.styleHollowButton(modifyPasswordButton)
        
        Utilities.styleFilledButtonRed(logOutButton)
    }
    
    @IBAction func modifyUsernameButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func modifyPswButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
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
