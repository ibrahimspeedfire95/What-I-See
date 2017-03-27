//
//  RecognizedUsersViewController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/27/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

let cellIdentifier = "RecognizedUserTableViewCell"

class RecognizedUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var recognizedUsers = [RecognizedUserModel]()
    var filterdRecognizedUsers = [RecognizedUserModel]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        FaceOperator.getRecognizedUsers(success: { (recognizedUsers) in
            self.recognizedUsers = recognizedUsers
            self.filterdRecognizedUsers = recognizedUsers
            self.tableView.reloadData()
        }) { (error) in
            print(error ?? "error")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            filterdRecognizedUsers = recognizedUsers
        } else {
            let predicate = NSPredicate(format: "name CONTAINS [c] %@ || relation CONTAINS [c] %@", searchText, searchText)
            filterdRecognizedUsers = recognizedUsers.filter({ (recognizedUser) -> Bool in
                predicate.evaluate(with: recognizedUser)
            })
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filterdRecognizedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecognizedUserTableViewCell
        cell.prepare(recognizedUser: filterdRecognizedUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recognizedUser = filterdRecognizedUsers.remove(at: indexPath.row)
            let index = recognizedUsers.index(of: recognizedUser)
            recognizedUsers.remove(at: index!)
        
            tableView.deleteRows(at: [indexPath], with: .automatic)
            FaceOperator.deleteRecognizedUser(recognizedUser: recognizedUser, success: { (recognizedUser) in
                
            }, failure: { (error) in
                self.recognizedUsers.insert(recognizedUser, at: index!)
                self.filterdRecognizedUsers.insert(recognizedUser, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            })
            
        }
    }

    @IBAction func editTableView(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction func addRecognizedUser(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select image from", message: nil, preferredStyle: .actionSheet)
        
        let photoGallaryAction = UIAlertAction(title: "Photo Gallary", style: .default) { (alertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(photoGallaryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                let vc: SelectFaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectFaceViewController") as! SelectFaceViewController
                vc.image = pickedImage
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
}
