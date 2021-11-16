//
//  SignInViewController.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//

import UIKit
import Firebase      //引入firebase函式庫

class SignInViewController: UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }

    //註冊帳號與密碼UITextField的 outletCollection
    @IBOutlet var signInInfoTextFieldCollection: [UITextField]!
    
    //註冊注意事項UITextView
    @IBOutlet weak var noticeTextView: UITextView!
    
    //button的 Outlet Collection
    @IBOutlet var signInButtonCollection: [UIButton]!
    
    
    //載入時設定noticeTextView顯示字
    //任意地方收鍵盤
    //button圓角設定
    //帳號UITxteField直接跳出鍵盤可輸入字
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        noticeTextView.text = "帳號注意事項：\n1.請勿使用免費信箱\n\n密碼注意事項：\n1.字元超過8位數\n2.須包含數字英文字母大小寫"
        for i in 0...1 {
            signInButtonCollection[i].layer.cornerRadius = signInButtonCollection[i].frame.height / 2
        }
        signInInfoTextFieldCollection[0].becomeFirstResponder()
    }

    
    
    
    //註冊按鈕
    @IBAction func tryToSignInFirebase(_ sender: UIButton) {
        
        
        //檢查四個textField是否有值
            //都有值檢查是否符合規定沒有符合規定跳出警告
            //符合歸嘗試註冊
                //註冊完成後再次進入firebase修改使用者名稱
                //接著登出
        //若txtField沒有值，依照沒有的值跳出警告
        if signInInfoTextFieldCollection[0].text?.isEmpty != true,
           signInInfoTextFieldCollection[1].text?.isEmpty != true,
           signInInfoTextFieldCollection[2].text?.isEmpty != true,
           signInInfoTextFieldCollection[3].text?.isEmpty != true {
            
            if signInInfoTextFieldCollection[0].text?.range(of: "@") == nil {
                self.showAlertInformation("帳號格式錯誤", "請輸入完整電子郵件")
            }else if signInInfoTextFieldCollection[1].text!.count < 6 {
                self.showAlertInformation("使用者名稱過短", "使用者名稱需六字元")
            }else if signInInfoTextFieldCollection[2].text!.count < 8 {
                self.showAlertInformation("密碼過短", "密碼需大於8位數")
            }else if signInInfoTextFieldCollection[2].text != signInInfoTextFieldCollection[3].text {
                self.showAlertInformation("密碼輸入不符", "兩次密碼輸入不一致")
            }else if checkPasswordFollowRule(signInInfoTextFieldCollection[2].text!) == true {
                self.showAlertInformation("密碼格式不合規定", "請確認密碼規則")
            }else{
                Auth.auth().createUser(withEmail: signInInfoTextFieldCollection[0].text!, password: signInInfoTextFieldCollection[2].text!) { result, error in
                    guard error == nil else {
                        print("註冊錯誤", error?.localizedDescription)
                        self.showAlertInformation("註冊錯誤", "請確認資料內容")
                        return
                    }
                    let profileChangeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    profileChangeRequest?.displayName = self.signInInfoTextFieldCollection[1].text
                    profileChangeRequest?.commitChanges(completion: { error in
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                    })
                    tryToLoginOut()
                    self.showAlertInformationAndTransferViewController("註冊成功", "返回登入頁面登入", 0)
                    for i in 0...self.signInInfoTextFieldCollection.count - 1 {
                        self.signInInfoTextFieldCollection[i].text = ""
                    }
                }
            }
        }else{
            for i in 0...3 {
                let alertText = ["請輸入帳號","請輸入使用者名稱","請輸入密碼","請再次輸入密碼"]
                if signInInfoTextFieldCollection[i].text?.isEmpty == true {
                    self.showAlertInformation(alertText[i], "請再次確認")
                }
            }
        }
    }
    
    
    //返回按鈕，透過dismiss回到上一頁
    @IBAction func backLoginPage(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
