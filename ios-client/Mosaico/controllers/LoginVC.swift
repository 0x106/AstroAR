//
//  LoginVC.swift
//  Flisar
//
//  Created by Alberto Taiuti on 19/08/2018.
//  Copyright © 2018 Shoebill. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FacebookCore
import FacebookLogin
import TwitterKit

class LoginVC: UIViewController, GIDSignInUIDelegate {
  
//  @IBOutlet weak var twLoginBtn: TWTRLogInButton!
  @IBOutlet weak var loginBtnsStackView: UIStackView!
  
  @IBAction func didSelectGoogleLogin(_ sender: Any) {
    MosaicoLoginManager.shared.customLoginButton__Google()
  }
  
  @IBAction func didSelectTwitterLogin(_ sender: Any) {
    MosaicoLoginManager.shared.customLoginButton__Twitter()
  }
  
  @IBAction func didSelectFacebookLogin(_ sender: Any) {
    MosaicoLoginManager.shared.customLoginButton__Facebook(vc: self)
  }
  
  private var authUpdateCallbackHandle: AuthStateDidChangeListenerHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if MosaicoLoginManager.shared.silentSignIn() {
      guard let vc: MainVC = instVC(withIdentifier: Consts.VCIDs.main, storyBoard: self.storyboard!) else {
        return
      }
      
      self.show(vc, sender: self)
    }
    
    GIDSignIn.sharedInstance().uiDelegate = self;
//    twLoginBtn.logInCompletion = FlisarLoginManager.shared.twLoginCompletion
//    let fbLoginBtn = LoginButton(readPermissions: [.publicProfile, .email])
//    fbLoginBtn.delegate = FlisarLoginManager.shared
//    loginBtnsStackView.addArrangedSubview(fbLoginBtn)
  }
  
  // https://firebase.google.com/docs/auth/ios/start
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // If the auth status changes, meaning we authed in Firebase
    authUpdateCallbackHandle =
      Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
        if user == nil {
          return
        }
        
        guard let vc: MainVC = instVC(withIdentifier: Consts.VCIDs.main, storyBoard: self.storyboard!) else {
          return
        }
        
        DispatchQueue.main.async {
          self.show(vc, sender: self)
        }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let handle = authUpdateCallbackHandle {
      Auth.auth().removeStateDidChangeListener(handle)
      authUpdateCallbackHandle = nil
    }
  }
}
