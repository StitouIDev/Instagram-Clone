//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Hamza on 2/25/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
    /// Check if username and email is available
    public func createNewUser(email: String, username: String, completion: (Bool) -> Void){
        completion(true)
    }
    
    /// Inserts new user data to database
    public func insertNewUser(email: String, username: String, completion: @escaping (Bool) -> Void){
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { (error, ref) in
            if error == nil {
                // succeeded
                completion(true)
            } else {
                // failed
                completion(false)
            }
        }
    }
    
}


