//
//  AlbumListVC.swift
//  Spotify
//
//  Created by PriyankaVithani on 16/04/21.
//

import Foundation
import UIKit

class LoadingHud  : NSObject{
    
    static var bgview = UIView()
    static var lbl  = UILabel()
    static var view = UIApplication.shared.windows[0]
    static let frame = CGRect.init(x: view.frame.size.width/2 - 30, y: view.center.y - 30 , width: 60, height: 60)
    
    class func showHUD(){
        bgview.removeFromSuperview()
        bgview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
       // bgview.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bgview.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)

        bgview.activityStartAnimating()
        view.addSubview(bgview)
    }
    class func hideHUD(){
        bgview.activityStopAnimating()
        bgview.removeFromSuperview()
    }
}
