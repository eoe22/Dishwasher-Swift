//
//  NetworkService.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

class NetworkService {
    
    private let urlString = "https://api.github.com/repositories"
    
    typealias MyData = (Int, Int, Int)
    typealias Handler = ([Repository]) -> ()
    
    func getData(completion: @escaping Handler) {
        
        Alamofire.request(urlString).responseData(){ response in
            
            if let error = response.error {
                print(error.localizedDescription)
                return
            }
            
            // - unwrap data from server
            guard let value = response.result.value else {
                print("No data retrieved from server")
                return
            }
            
            // - extract repositories from data
            guard let washers: [Repository] = try? unbox(data: value) else {
                print("Could not parse data")
                return
            }
            
            // return the repositories via the completion handler
            completion(washers)
        }
    }
}
