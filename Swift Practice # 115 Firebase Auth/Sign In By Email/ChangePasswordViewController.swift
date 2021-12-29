//
//  ChangePasswordViewController.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    //隨意收鍵盤
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    //3個 UITextField Outlet Collection
    @IBOutlet var passwordInfoTextFieldCollection: [UITextField]!
    
    //button的 Outlet Collection
    @IBOutlet var changeButtonCollection: [UIButton]!
    

    //執行任意地方收鍵盤
    //就密碼成為becomeFirstResponder
    //修改button圓角
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        passwordInfoTextFieldCollection[0].becomeFirstResponder()
        for i in 0...1 {
            changeButtonCollection[i].layer.cornerRadius = changeButtonCollection[i].frame.height / 2
        }
        
    }
    
    //嘗試密碼button
    @IBAction func tryToChangePassword(_ sender: UIButton) {
        
        //三個textField都有值
            //檢查密碼規則有問題跳警告
                //沒問題嘗試拿就密碼登入 有問題跳警告
                    //沒問題則透過新密碼改成密碼
                        //設定成功後登出返回登入頁
        //textField有沒值的跳出Alert警告
        
        if passwordInfoTextFieldCollection[0].text?.isEmpty != true,
           passwordInfoTextFieldCollection[1].text?.isEmpty != true,
           passwordInfoTextFieldCollection[2].text?.isEmpty != true {
            
            if passwordInfoTextFieldCollection[2].text!.count < 8 {
                self.showAlertInformation("密碼過短", "密碼需大於8位數")
            }else if passwordInfoTextFieldCollection[1].text != passwordInfoTextFieldCollection[2].text {
                self.showAlertInformation("密碼輸入不符", "兩次密碼輸入不一致")
            }else if checkPasswordFollowRule(passwordInfoTextFieldCollection[1].text!) == true {
                self.showAlertInformation("密碼格式不合規定", "請確認密碼規則")
            }else{
                Auth.auth().signIn(withEmail: Auth.auth().currentUser!.email!, password: passwordInfoTextFieldCollection[0].text!) { result, error in
                    guard error == nil else {
                        print("改密碼登入失敗", error?.localizedDescription)
                        self.showAlertInformation("原始密碼有誤", "請重新輸入")
                        return
                    }
                    print("改密碼時登入成功")
                    Auth.auth().currentUser?.updatePassword(to: self.passwordInfoTextFieldCollection[1].text!) { error in
                        
                        if error != nil {
                            print(error?.localizedDescription)
                        }else{
                            tryToLoginOut()
                            
                            self.showAlertInformationAndTransferViewController("密碼修改成功", "請重新登入", 0)
                            
                            for i in 0...2 {
                                self.passwordInfoTextFieldCollection[i].text = ""
                            }
                        }
                    }
                }
            }
        }else{
            self.showAlertInformation("請完整輸入密碼", "")
        }
        

    }
    
    //返回button
    @IBAction func backToLoginsuccessView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
