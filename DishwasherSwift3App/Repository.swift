//
//  Dishwasher.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Unbox

struct Repository {
    
    let name: String
    let brand: String
    let price: Double
    let imageURL: String    
}

extension Repository: Unboxable {
    
    init(unboxer: Unboxer) throws {
        // get the name of the repository
        do {
            self.name = try unboxer.unbox(key: "name")
            
            // get the username of the developer
            self.brand = try unboxer.unbox(keyPath: "owner.login")
            
            // TODO
            self.price = 0.0
            
            // get the picture for the repo
            self.imageURL = try unboxer.unbox(keyPath: "owner.avatar_url")

        }catch{
            print("Parsing error")
            print(error.localizedDescription)
            throw error
        }
        
    }
}
