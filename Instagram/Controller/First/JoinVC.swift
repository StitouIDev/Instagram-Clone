//
//  RegisterVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinVC: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameTxt: UITextField = {
        let field = UITextField()
        field.placeholder = "Username..."
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
    
    private let emailTxt: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address..."
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
        field.autocorrectionType = .no
        return field
    }()
    
    private let registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Sigh Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(red: 0.7, green: 0, blue: 0.4, alpha: 0.6)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.addTarget(self, action: #selector(registerBtnClicked), for: .touchUpInside)
        usernameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        view.addSubview(usernameTxt)
        view.addSubview(emailTxt)
        view.addSubview(passwordTxt)
        view.addSubview(registerBtn)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameTxt.frame = CGRect(x: 20, y: view.safeAreaInsets.top+100, width: view.width-40, height: 50)
        emailTxt.frame = CGRect(x: 20, y: usernameTxt.bottom+10, width: view.width-40, height: 50)
        passwordTxt.frame = CGRect(x: 20, y: emailTxt.bottom+10, width: view.width-40, height: 50)
        registerBtn.frame = CGRect(x: 20, y: passwordTxt.bottom+10, width: view.width-40, height: 50)
    }
    
    @objc private func registerBtnClicked() {
        usernameTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        guard let email = emailTxt.text, !email.isEmpty,
            let username = usernameTxt.text, !username.isEmpty,
            let password = passwordTxt.text, !password.isEmpty, password.count >= 8 else {
                return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            DispatchQueue.main.async {
                print("goood")
                if registered {
                    // success
                    print("good")
                } else {
                    // Failed
                    print("fail")
                }
            }
        }
        
    }
}

extension JoinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxt {
            emailTxt.becomeFirstResponder()
        } else if textField == emailTxt {
            passwordTxt.becomeFirstResponder()
        } else {
            registerBtnClicked()
        }
        return true
    }
    
}
