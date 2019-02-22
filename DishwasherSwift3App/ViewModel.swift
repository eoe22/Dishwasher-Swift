//
//  ViewModel.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Array where Element: Hashable {
    
    /**
     Return all the unique items in an array
    */
    var uniqueItems: [Element] {
        // filter out duplicates by using a set
        let set = Set<Element>(self)
        
        // convert set back to an array
        return set.map{ $0 }
    }
}

class ViewModel {
    
    var buttonText: Observable<String> {
        return pickerVisible.asObservable().map{ visible in
            visible ? "Stop Filtering" : "Filter"
        }
    }
    
    var userSelected: ( (String) -> () )?
    
    var dishwashers = Variable<[Repository]>([])
    var users = Variable<[String]>([])
    
    var pickerVisible = Variable<Bool>(false)
    
    let service = NetworkService()
    
    init() {
        
        service.getData(){ dishwashers in
            // update repositories
            self.dishwashers.value = dishwashers
            
            // update users
            self.users.value = dishwashers.map{ $0.brand }.uniqueItems
        }
    }
    
    func togglePickerView(){
        pickerVisible.value = !pickerVisible.value
    }
    
    func filter(using user: String){
        // remove repositories where the owner is not the given user
        let filtered = dishwashers.value.filter{ $0.brand == user }
        
        // update the property accordingly
        dishwashers.value = filtered
        
        // call the user selected closure, if one is set
        userSelected?(user)
    }
}
