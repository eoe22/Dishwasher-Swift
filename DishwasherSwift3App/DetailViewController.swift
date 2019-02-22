//
//  DetailViewController.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/14/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var repo: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.sd_setImage(
            with: URL(string: repo.imageURL),
            completed: nil)
        
        titleLabel.text = repo.name
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
