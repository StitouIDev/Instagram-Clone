//
//  AuthManager.swift
//  Instagram
//
//  Created by Hamza on 2/25/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Check if username is available
        // Check if email is available
        
        DatabaseManager.shared.createNewUser(email: email, username: username) { success in
            if success {
                // Create Account
                Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                // Insert Account to Database
                    DatabaseManager.shared.insertNewUser(email: email, username: username, completion: { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            // Failed to inseret to database
                            completion(false)
                            return
                        }
                    })
                    
                })
            } else {
                // either username or email does not exist
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            // email Log In
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard result != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
       /* else if let username = username {
            // username Log In
            completion(true)
        }
*/    }
    
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error.localizedDescription)
            completion(false)
            return
        }
    }
    
    
}
