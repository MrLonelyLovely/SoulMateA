//
//  AppDelegate.swift
//  SoulMateA
//
//  Created by Apui on 2020/3/18.
//  Copyright © 2020 陈沛. All rights reserved.
//

import UIKit
import AVOSCloud
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func transitiontoHome() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeTabBarController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeTabBarController) as! MyTabBarController
        window?.rootViewController = homeTabBarController
        window?.makeKeyAndVisible()
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AVOSCloud.setApplicationId("eHqoTO3rmGhHS2IUg9A3oPnj-gzGzoHsz", clientKey: "w3zoi5XJ5KBmjRFW13cvJhKk")
        //跟踪统计应用的打开情况
        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        AVOSCloud.setAllLogsEnabled(true)
        
//        AVUser *currentUser = [AVUser currentUser];
//        if (currentUser != nil) {
//            // 跳到首页
//        } else {
//            // 显示注册或登录页面
//        }
        
        let currentUser = AVUser.current()
        print("当前用户是：")
        print(currentUser as Any)
//        if currentUser != nil {
//            //跳到首页
//            transitiontoHome()
//        } else {
//            //显示注册登陆界面
//
//        }
        /*
        let testObject = AVObject(className: "TestObject")
        testObject.setObject("bar", forKey: "foo")
        testObject.save()
        */
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

