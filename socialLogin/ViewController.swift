//
//  ViewController.swift
//  socialLogin
//
//  Created by Arvids Gargurnis on 10/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFBButtons()
        setupGoogleButtons()
        
    }
    
    @objc func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            self.showEmailAddress()
        }
    }
    
    @objc func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        // succsefully loged in
        print("success1")
        showEmailAddress()
    }
    
    func setupGoogleButtons() {
        // add google sign in button
        let googleButton = GIDSignInButton()
        view.addSubview(googleButton)
        googleButton.frame = CGRect(x: 16, y: 182, width: view.frame.width - 32, height: 50)
        
        // add custom button
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 16, y: 248, width: view.frame.width - 32, height: 50)
        customButton.backgroundColor = .red
        customButton.setTitle("Custom Google Sign in", for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customButton.setTitleColor(.white, for: .normal)
        view.addSubview(customButton)
        customButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func setupFBButtons() {
        // facebook sign in button
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        
        //add custom fb buton
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = .blue
        customFBButton.setTitleColor(.white, for: .normal)
        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBButton.setTitle("Custom FB Login", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(customFBButton)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            print("successs", user ?? "")
        }
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" :"id, name,email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print(err!)
                return
            }
            
            print(result!)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //did log out of facebook
        print("logged out")
    }

}

