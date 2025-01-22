//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Alibek Baisholanov on 22.01.2025.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
}

//MARK: - Account Management
extension DatabaseManager {
    
    
    public func userExists(with email: String, 
                           completion: @escaping((Bool) -> Void)){
        
        //Checking if this email exists in database with замыкание
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.emailAddress).setValue([
            "first_name" : user.firstName,
            "last_name" : user.lastName
        ])
    }
}

