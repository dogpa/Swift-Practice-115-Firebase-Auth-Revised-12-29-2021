//
//  FrontPageViewController.swift
//  Swift Practice # 115 Firebase Auth
//
//  Created by Dogpa's MBAir M1 on 2021/11/16.
//

import UIKit
import GoogleSignIn
import Firebase
import FacebookCore
import FacebookLogin

import AuthenticationServices
import CryptoKit

class FrontPageViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //在viewDidAppear時判斷是否已經登入了
    //若是已經登入直接跳到第登入完成畫面
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser?.email != nil {
            self.transferViewController(2)
        }
    }
    
    //使用Email登入
    @IBAction func signInWithEmail(_ sender: UIButton) {
        self.transferViewController(0)
    }
    
    
    //使用Google登入
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        //取得clientID後指派給signInConfig
        //接著透過GIDSignIn帶入參數後跳出授權頁面執行登入
        //執行完成後跳轉頁面
        
        let signInConfig = GIDConfiguration.init(clientID: "190237699059-9j4n71e8thmtkigelduq4egq9munvgvf.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            if GIDSignIn.sharedInstance.currentUser != nil {
                if let error = error {
                  // ...
                  return
                }

                guard
                  let authentication = user?.authentication,
                  let idToken = authentication.idToken
                else {
                  return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                  Auth.auth().signIn(with: credential) { authResult, error in
                      if Auth.auth().currentUser?.email != nil {
                          self.transferViewController(2)
                      }
                  }
                
                self.transferViewController(2)
            }
        }
    }
    

    
    fileprivate var currentNonce: String?

    //@available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    
    func handleSignInWithAppleTapped() {
        performSignIn()
    }
    
    func performSignIn() {
        let request = creatAppleIdRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func creatAppleIdRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    //使用Apple ID 登入
    @IBAction func signInWithApple(_ sender: UIButton) {
        handleSignInWithAppleTapped()
        
    }
    
    
    
    
    @IBAction func signInWithFacebook(_ sender: UIButton) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: let token) = result {
                print("fb login ok")
                
                let credential =  FacebookAuthProvider.credential(withAccessToken: token!.tokenString)
                    Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                    guard let self = self else { return }
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    print("login ok")
                        self.transferViewController(2)
                }
            } else {
                print("login fail")
            }
        }
    }
    
    
    
}



extension FrontPageViewController: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard  let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unalbe to fetch identity token  ")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to seriaiez tokeb string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                           idToken: idTokenString,
                                                           rawNonce: nonce)
            Auth.auth().signIn(with: credential) {(AuthDataResult, error) in
                if let user = AuthDataResult?.user {
                    print("Nice, you are sign in as\(user.uid) \(user.email ?? "unknow")")
                    self.transferViewController(2)
                }
            }
        }
    }
}

extension FrontPageViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}



private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}
