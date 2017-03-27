//
//  SelectFaceViewController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/14/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class SelectFaceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var image: UIImage?
    var images: [UIImage]?
    var selectedIndexes = [Int]()
    var loadingIndexes = [Int]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.isHidden = true
        self.imageView.isHidden = true
        
        FaceOperator.detectFasces(image: self.image!, success: { (images) in
            
            self.collectionView.isHidden = false
            self.imageView.isHidden = false
            self.activityIndicator.stopAnimating()
            
            self.imageView.image = self.image
            
            self.images = images
            self.collectionView.reloadData()
            
        }) { (error) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.images?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = self.images?[indexPath.row]
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        
        let activityIndicatorView = cell.viewWithTag(2) as! UIActivityIndicatorView
        
        if self.loadingIndexes.contains(indexPath.item) {
            activityIndicatorView.startAnimating()
            cell.alpha = 0.5
            
        } else {
            activityIndicator.stopAnimating()
            cell.alpha = 1
            
            if self.selectedIndexes.contains(indexPath.item) {
                imageView.layer.borderWidth = 3
                imageView.layer.borderColor = UIColor(colorLiteralRed: 0/255.0, green: 51/255.0, blue: 102/255.0, alpha: 1).cgColor
            } else {
                imageView.layer.borderWidth = 0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let actionSheet = UIAlertController(title: "Enter name for the selected face", message: nil, preferredStyle: .alert)
        
        actionSheet.addTextField { (textField) in
            textField.placeholder = "ex. ibrahim"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default ) { (alertAction) in
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .cancel) { (alertAction) in
            
            self.loadingIndexes.append(indexPath.item)
            self.collectionView.reloadData()
            
            FaceOperator.createRecognizedUser(name: (actionSheet.textFields?.first?.text)!, relation: "friend", success: { (recognizedUser) in
                

                FaceOperator.createFaceForRecognizedUser(recognizedUserId: recognizedUser.id, image: (self.images?[indexPath.row])!, success: { (ssss) in
                    self.loadingIndexes.remove(at: self.loadingIndexes.index(of: indexPath.item)!)
                    self.selectedIndexes.append(indexPath.item)
                    self.collectionView.reloadData()
                }, failure: { (error) in
                    self.loadingIndexes.remove(at: self.loadingIndexes.index(of: indexPath.item)!)
                    self.selectedIndexes.append(indexPath.item)
                    self.collectionView.reloadData()
                })
            }, failure: { (error) in
                
            })
            
        }
    
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(saveAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}
