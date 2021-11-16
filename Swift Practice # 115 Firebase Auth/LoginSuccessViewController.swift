//
//  LoginSuccessViewController.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//

import UIKit
import Firebase

class LoginSuccessViewController: UIViewController {

    //顯示使用者ID
    @IBOutlet weak var greetingLabel: UILabel!
    
    //button的 Outlet Collection
    @IBOutlet var userButtonCollection: [UIButton]!
    
    
    //Button改圓角
    //顯示使用者名稱
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...1 {
            userButtonCollection[i].layer.cornerRadius = userButtonCollection[i].frame.height / 2
        }
        if Auth.auth().currentUser?.displayName != nil {
            greetingLabel.text = "你好！\(Auth.auth().currentUser!.displayName!)"
        }else{
            greetingLabel.text = "你好"
        }
        
        
    }
    
    
    //改密碼buton 跳到改密碼頁面
    @IBAction func trytoChangePassword(_ sender: UIButton) {
        self.transferViewController(3)
    }
    
    
    //登出按鈕
    //嘗試登出後跳回登入頁面
    @IBAction func tryToLogout(_ sender: UIButton) {
        tryToLoginOut()
        self.showAlertInformationAndTransferViewController("掰掰囉", "期待再見", 4)
    }
    
    


}

