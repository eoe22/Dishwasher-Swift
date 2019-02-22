//
//  UsernamePickerView.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift

class UsernamePickerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var usernamePickerView: UIPickerView!
    
    // a way to notify about a selected user
    let selectedUser = PublishSubject<String>()
    
    static let height: CGFloat = 216
    
    // frame for when this view is showing on screen
    static let activeFrame = CGRect(
        x: 0,
        y: UIScreen.main.bounds.height - height,
        width: UIScreen.main.bounds.width,
        height: height)
    
    // frame for when this view is showing off screen
    static let hiddenFrame = CGRect(
        x: 0,
        y: UIScreen.main.bounds.height,
        width: UIScreen.main.bounds.width,
        height: height)
    
    var users: [String] = ["John", "Robert"]
    
    convenience init() {
        self.init(frame: UsernamePickerView.hiddenFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // update picker view with data from server
    func update(with usernames: [String]) {
        users = usernames
        usernamePickerView.reloadAllComponents()
    }
    
    private func setup(){
        // load xib stuff
        Bundle.main.loadNibNamed("UsernamePickerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // set up Picker View
        usernamePickerView.delegate = self
        usernamePickerView.dataSource = self
        usernamePickerView.reloadAllComponents()
    }
}

extension UsernamePickerView: UIPickerViewDelegate {
    
    // show the username for the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return users[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // get the selected user
        let user = users[row]
        
        // emit the selected user
        selectedUser.onNext(user)
    }
}

extension UsernamePickerView: UIPickerViewDataSource {
    
    // just use one column in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows = number of users
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count
    }
}
