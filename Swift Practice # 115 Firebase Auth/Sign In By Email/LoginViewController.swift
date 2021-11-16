//
//  LoginViewController.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//

import UIKit
import FirebaseAuth     //引入firebase函式庫


class LoginViewController: UIViewController {
    
    //任意位置收鍵盤Function
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }

    //帳號密碼UITextField的OutlerCollection
    @IBOutlet var InfoTextFieldCollection: [UITextField]!
    
    //密碼button的 IBoutlet Collection
    @IBOutlet var loginPageButtonCollection: [UIButton]!
    
    
    //view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()     //執行收鍵盤
        
        //Button圓角設定
        for i in 0...1 {
            loginPageButtonCollection[i].layer.cornerRadius = loginPageButtonCollection[i].frame.height / 2
        }
        
        //直接跳鍵盤可以輸入帳號
        InfoTextFieldCollection[0].becomeFirstResponder()

    }
    
    //在viewDidAppear時判斷是否已經登入了
    //若是已經登入直接跳到第登入完成畫面
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser?.email != nil {
            self.transferViewController(2)
        }
    }
    
    
    //嘗試登入Finction
    func tryToLogin () {
        
        //所有InfoTextFieldCollection內都有輸入資料的話
            //判斷是否有打對email格式與密碼長度
                //沒問題後嘗試登入
                    //登入時遭遇問題列印並詢問是否跳轉註冊頁面
                //登入成功時跳出Alert後跳到登入完成頁
        //若是資料有缺
            //依照缺少的值做不同的Alert內容判斷
        if InfoTextFieldCollection[0].text?.isEmpty != true, InfoTextFieldCollection[1].text?.isEmpty != true {
            if InfoTextFieldCollection[0].text?.range(of: "@") == nil {
                self.showAlertInformation("Email格式錯誤", "")
            }else if InfoTextFieldCollection[1].text!.count < 8 {
                self.showAlertInformation("密碼長度錯誤", "")
            }else{
                Auth.auth().signIn(withEmail: self.InfoTextFieldCollection[0].text!, password: self.InfoTextFieldCollection[1].text!) {
                    result, error in
                    guard let user = result?.user, error == nil else{
                        
                        
                        
                        
                        
                        
                        print(error?.localizedDescription)
                        
                        self.askToCreatANewAccount()
                        return
                    }
                    if user.displayName != nil {
                        self.showAlertInformationAndTransferViewController("\(user.displayName!)你好", "登入成功", 2)
                    }else{
                        self.showAlertInformationAndTransferViewController("你好", "登入成功", 2)
                    }
                    
                    for i in 0...1 {
                        self.InfoTextFieldCollection[i].text = ""
                    }
                }
            }
        }else{
            if InfoTextFieldCollection[0].text?.isEmpty == true {
                self.showAlertInformation("請輸入帳號", "沒帳號啦親")
            }
            if InfoTextFieldCollection[1].text?.isEmpty == true {
                self.showAlertInformation("請輸入密碼", "484忘記惹")
            }
        }
    }
    

    
    //登入按鈕 執行 tryToLogin()
    @IBAction func tryAccountLogin(_ sender: UIButton) {
        tryToLogin()
    }
    
    
    //註冊按鈕，跳轉註冊頁面
    @IBAction func showSignInViewCnotroller(_ sender: UIButton) {
        self.transferViewController(1)
    }
    
    
}

