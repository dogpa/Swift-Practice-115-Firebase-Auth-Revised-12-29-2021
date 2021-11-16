//
//  Struct And Function.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//


import Foundation
import UIKit
import Firebase


//4個UIStoruboard ID 的Array
//有用於後續字定義的 transferViewController Function
let controllerArray = [
    "LoginViewController",
    "SignInViewController",
    "LoginSuccessViewController",
    "ChangePasswordViewController",
    "FrontPageViewController"
]


//用於指派UIStoruboard ID 後回傳使用
//用於跳轉頁面指定跳到哪一個頁面使用
func getViewControllerName (_ int:Int) -> String {
    
    return controllerArray[int]
    
}


//用於檢查密碼
//註冊與改密碼頁面使用
//檢查是否有大寫小寫與數字
//檢查後回傳true or false後續判斷使用
func checkPasswordFollowRule (_ string:String) -> Bool {
    var captial = 0
    var lower = 0
    var number = 0                          //設定三個變數
    let numberString = "0123456789"
    for i in string {
        if numberString.contains(i) {
            number += 1                     //檢查數字
        }else if i.isUppercase{
            captial += 1                    //檢查大寫
        }else if i.isLowercase{
            lower += 1                      //檢查小寫
        }
        
    }
    //print(captial,lower,number)
    if captial == 0 || lower == 0 || number == 0 {
        return true                         //其中一個為0代表沒有遵從密碼規定回傳true
    }else{
        return false
    }                                       //密碼檢查符合規定回傳false
    
}


//登出Function
//用於註冊完成時登出     登入頁面時登出按鈕   修改密碼完成後登出
func tryToLoginOut () {
    
    do{
        try Auth.auth().signOut()

    }catch{
        print(error.localizedDescription)
    }

}



//延展UIViewController的功能
extension UIViewController {
    
    
    //跳轉頁面
    //輸入controllerArray的值後跳到對應的頁面
    func transferViewController (_ pageIndex: Int) {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: getViewControllerName(pageIndex))
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
    
    
    //跳出警告
    //可輸入標題title與內文
    func showAlertInformation (_ alertText:String, _ messageText:String){
        let alertController = UIAlertController(title: alertText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //跳出警告後按下了解後執行自定義Function transferViewController
    //跳到指定的UIStoryboard ID的頁面
    
    func showAlertInformationAndTransferViewController (_ alertText:String, _ messageText:String, _ pageIndex:Int){
        let alertController = UIAlertController(title: alertText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .default, handler: { _ in
            self.transferViewController(pageIndex)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    //用於登入有狀況時詢問是否要註冊帳號
    //註冊帳號後跳轉頁面
    //不註冊留在原頁
    func askToCreatANewAccount () {
        let alertController = UIAlertController(title: "登入失敗or無帳號", message: "是否創建一個？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "好喔來去註冊帳號", style: .default, handler: {_ in
            self.transferViewController(1)
        }))
        alertController.addAction(UIAlertAction(title: "嘗試修正登入資料", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

