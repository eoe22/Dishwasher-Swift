//
//  ViewController.swift
//  DishwasherSwift3App
//
//  Created by mac on 1/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var dishwasherCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var dishwashers: [Repository] = []
    
    lazy var pickerView = UsernamePickerView()
    
    let viewModel = ViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishwasherCollectionView.delegate = self
        
        // add the bottom picker view to the view
        view.addSubview(pickerView)
        setupBindings()
    }
        
    private func setupBindings(){
        
        viewModel.userSelected = { user in
            self.title = user
        }
        
        pickerView
            .selectedUser
            .subscribe(onNext: { [unowned self] in
                self.viewModel.filter(using: $0)
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .users
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.pickerView.update(with: $0)
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .dishwashers
            .asObservable()
            .bindTo(dishwasherCollectionView
                .rx
                .items(cellIdentifier: "DishwasherCell", cellType: DishwasherCollectionViewCell.self)){ _, repository, cell in
                    cell.configure(with: repository)
            }
            .addDisposableTo(disposeBag)

        
        viewModel
            .buttonText
            .subscribe(onNext: { text in
                self.filterButton.title = text
            })
            .addDisposableTo(disposeBag)
        
        // listen to changes to the pickerVisible boolean
        viewModel
            .pickerVisible
            .asObservable()
            .subscribe(onNext: { visible in
                if visible {
                    self.showPickerView()
                }else {
                    self.hidePickerView()
                }
            })
            .addDisposableTo(disposeBag)

    }
    
    @IBAction func filterButtonPressed(_ sender:  UIBarButtonItem) {
        viewModel.togglePickerView()
    }
    
    // hide Picker View
    func hidePickerView(){
        UIView.transition(
            with: pickerView,
            duration: 0.3,
            options: .curveEaseInOut,
            animations: {
                //moving the collection view down
                self.dishwasherCollectionView.frame.origin.y += 216
                
                // moving the bottom picker down
                self.pickerView.frame = UsernamePickerView.hiddenFrame
        }, completion: nil)
    }
    
    // show Picker View
    func showPickerView(){
        UIView.transition(
            with: pickerView,
            duration: 0.3,
            options: .curveEaseInOut,
            animations: {
                //moving the collection view up
                self.dishwasherCollectionView.frame.origin.y -= 216
                
                // moving the bottom picker up
                self.pickerView.frame = UsernamePickerView.activeFrame
        }, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let repository = viewModel.dishwashers.value[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: repository)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //super.prepare(for: segue, sender: sender)
        
        // get next View Controller
        let nextVC = segue.destination as! DetailViewController
        
        // get the repository
        let repo = sender as! Repository
        
        // pass the repository to the next view controller
        nextVC.repo = repo
    }
}

