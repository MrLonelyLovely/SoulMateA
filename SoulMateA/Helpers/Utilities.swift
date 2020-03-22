//
//  Utilities.swift
//  SoulMate
//
//  Created by Apui on 2020/3/15.
//  Copyright © 2020 陈沛. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textfield: UITextField) {
        
        //创建底线
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        //移除textField的边框
        textfield.borderStyle = .none
        
        //添加直线到textfield中
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        //实心按钮
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtonRed(_ button:UIButton) {
        
        button.backgroundColor = UIColor.init(red: 251/255, green: 153/255, blue: 102/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        //空心按钮
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func circleTheImageView(_ img:UIImageView) {
        
        //将头像框设置为圆形
        //将视图的矩形圆角值设置为自身宽度的一半，便变成圆形了
        img.layer.cornerRadius = img.frame.width / 2
        //裁剪掉多余的部分
        img.clipsToBounds = true
    }
    
    
    /// 比较两个图片是否相同, 这里比较尺寸为20*20
    ///
    /// - Parameters:
    ///   - imageOne: 图片1
    ///   - imageTwo: 图片2
    /// - Returns: 是否相同的布尔值
//    func isEqualImage(imageOne: UIImage, imageTwo: UIImage) -> Bool {
//        var equalResult = false
//        let mImageOne = self.getGrayImage(sourceImage: self.scaleToSize(img: imageOne, size: CGSize(width: 20, height: 20)))
//        let mImageTwo = self.getGrayImage(sourceImage: self.scaleToSize(img: imageTwo, size: CGSize(width: 20, height: 20)))
//        let diff = self.getDifferentValueCountWithString(str1: self.pHashValueWithImage(image: mImageOne), str2: self.pHashValueWithImage(image: mImageTwo))
//        print(diff)
//        if diff > 10 {
//            equalResult = false
//        } else {
//            equalResult = true
//        }
//        return equalResult
//    }
}
