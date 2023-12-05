//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 27/11/2023.
//

import UIKit
import ProgressHUD


final class UIBlockingProgressHUD{
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .clear
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
}



