//
//  LoginVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    
    private let usernameEmailTxt: UITextField = {
        let field = UITextField()
        field.placeholder = "Username OR Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        field.layer.borderWidth = 1.0
        return field
    }()
    
    private let passwordTxt: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        field.layer.borderWidth = 1.0
        return field
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.6)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let createAccBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("New User? Create an Account", for: .normal)
        
        return button
    }()
    
    private let termsBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let privacvBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        let bgImgView = UIImageView(image: UIImage(named: "gradient"))
        header.clipsToBounds = true
        header.addSubview(bgImgView)
        
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        createAccBtn.addTarget(self, action: #selector(createAccBtnClicked), for: .touchUpInside)
        termsBtn.addTarget(self, action: #selector(termsBtnClicked), for: .touchUpInside)
        privacvBtn.addTarget(self, action: #selector(privacyBtnClicked), for: .touchUpInside)


        
        
        
        
        usernameEmailTxt.delegate = self
        passwordTxt.delegate = self
        addSubviews()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // assign frames
        
        headerView.frame = CGRect(
            x: 0,
            y: 0.0,
            width: view.width,
            height: view.height/3.0)
        
        usernameEmailTxt.frame = CGRect(
            x: 25,
            y: headerView.bottom + 30,
            width: view.width - 50,
            height: 52)
        
        passwordTxt.frame = CGRect(
            x: 25,
            y: usernameEmailTxt.bottom + 10,
            width: view.width - 50,
            height: 52)
        
        loginBtn.frame = CGRect(
            x: 25,
            y: passwordTxt.bottom + 10,
            width: view.width - 50,
            height: 52)
        
        createAccBtn.frame = CGRect(
            x: 25,
            y: loginBtn.bottom + 10,
            width: view.width - 50,
            height: 52)
        
        termsBtn.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-90,
            width: view.width-20,
            height: 50)
        
        privacvBtn.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-50,
            width: view.width-20,
            height: 50)
        
        configHeaderView()
        
    }
    
    private func configHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let bgView = headerView.subviews.first else {
            return
        }
        bgView.frame = headerView.bounds
        
        
        // Add instagram logo
        let imageView = UIImageView(image: UIImage(named: "text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0,
                                 y: view.safeAreaInsets.top,
                                 width: headerView.width/2.0,
                                 height: headerView.height - view.safeAreaInsets.top)
    }
    
    private func addSubviews() {
        view.addSubview(usernameEmailTxt)
        view.addSubview(passwordTxt)
        view.addSubview(loginBtn)
        view.addSubview(termsBtn)
        view.addSubview(privacvBtn)
        view.addSubview(createAccBtn)
        view.addSubview(headerView)
        
    }
    
    @objc private func loginBtnClicked() {
        passwordTxt.resignFirstResponder()
        usernameEmailTxt.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailTxt.text, !usernameEmail.isEmpty,
            let password = passwordTxt.text, !password.isEmpty, password.count >= 8 else {
                return
        }
        
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            // Email
            email = usernameEmail
        } else {
            // username
            username = usernameEmail
        }
        
        
        
        // Login functionality
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    // user logged in
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // error occured
                    let alert = UIAlertController(title: "Log In Error", message: "we were unable to log you in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func termsBtnClicked() {
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func privacyBtnClicked() {
        guard let url = URL(string: "https://help.instagram.com/519522125107875/?maybe_redirect_pol=0") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func createAccBtnClicked() {
        let vc = JoinVC()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    

}


extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        return true
    }
    
}
