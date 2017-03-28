//
//  SelectFaceViewController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/14/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import CoreImage

class SelectFaceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var image: UIImage?
    var images = [UIImage]()
    var selectedIndexes = [Int]()
    var loadingIndexes = [Int]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = ImageHelper.rotateImageToRightRotation(img: image!)
        collectionView.isHidden = true
        imageView.isHidden = true
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = self.images[indexPath.row]
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        let activityIndicatorView = cell.viewWithTag(2) as! UIActivityIndicatorView
        
        if loadingIndexes.contains(indexPath.item) {
            activityIndicatorView.startAnimating()
            cell.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            cell.alpha = 1
            if selectedIndexes.contains(indexPath.item) {
                imageView.layer.borderWidth = 3
                imageView.layer.borderColor = UIColor.tcpurple.cgColor
            } else {
                imageView.layer.borderWidth = 0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if loadingIndexes.contains(indexPath.item) || selectedIndexes.contains(indexPath.item) {
            return
        }
        
        let actionSheet = UIAlertController(title: "Enter name for the selected face", message: nil, preferredStyle: .alert)
        actionSheet.addTextField { (textField) in
            textField.placeholder = "ex. ibrahim"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            self.loadingIndexes.append(indexPath.item)
            self.collectionView.reloadData()
            
            FaceOperator.createRecognizedUser(name: (actionSheet.textFields?.first?.text)!, relation: "friend", success: { (recognizedUser) in
                FaceOperator.createFaceForRecognizedUser(recognizedUserId: recognizedUser.id, image: self.images[indexPath.row], success: { (_) in
                    self.loadingIndexes.remove(at: self.loadingIndexes.index(of: indexPath.item)!)
                    self.selectedIndexes.append(indexPath.item)
                    self.collectionView.reloadData()
                }, failure: { (error) in
                    self.loadingIndexes.remove(at: self.loadingIndexes.index(of: indexPath.item)!)
                    self.collectionView.reloadData()
                })
            }, failure: { (error) in
                
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}
