//
//  ViewController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class ViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var recognizedUsers = [RecognizedUserModel]()
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recognizedUsers = CoreDataController.sharedController.getRecognizedUsers() {
            self.recognizedUsers = recognizedUsers
            self.tableView.reloadData()
        }
        
        
        FaceOperator.getRecognizedUsers(success: { (recognizedUsers) in
            
//            if let recognizedUsers = CoreDataController.sharedController.getRecognizedUsers() {
                self.recognizedUsers = recognizedUsers
                self.tableView.reloadData()
//            }
            
        }) { (error) in
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognizedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = recognizedUsers[indexPath.row].name
        cell.detailTextLabel?.text = recognizedUsers[indexPath.row].relation
        return cell
    }
    
    @IBAction func addPeople(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select image from", message: nil, preferredStyle: .actionSheet)
        
        let photoGallaryAction = UIAlertAction(title: "Photo Gallary", style: .default) { (alertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            
        }

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

