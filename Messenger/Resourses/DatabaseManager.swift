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
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        //Checking if this email exists in database with замыкание
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name" : user.firstName,
            "last_name" : user.lastName
        ])
    }
}

