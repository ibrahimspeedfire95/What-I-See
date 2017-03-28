//
//  FaceOperator.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/4/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import ProjectOxfordFace
import CoreGraphics

class FaceOperator {

    static let client = MPOFaceServiceClient(subscriptionKey: MicrosoftFaceAPISubscriptionKey)
    
    class func detectFasces(image: UIImage, success: @escaping ([UIImage]) -> (), failure: @escaping (Error?) -> ()) {
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        _ = client?.detect(with: data, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: nil, completionBlock: { (faces, error) in
            if error == nil {
                var facesArray = [UIImage]()
                for face in faces! {
                    let rect = CGRect(x: face.faceRectangle.left.intValue, y: face.faceRectangle.top.intValue, width: face.faceRectangle.width.intValue, height: face.faceRectangle.height.intValue)
                    let imageRef = image.cgImage?.cropping(to: rect)
                    let image = UIImage(cgImage: imageRef!)
                    facesArray.append(image)
                }
                success(facesArray)
            } else {
                failure(error)
            }
        })
    }
    
    class func createFaceGroup(groupName: String, success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        // TODO change id to user id
        _ = client?.createPersonGroup(withId: "2", name: groupName, userData: nil, completionBlock: { (error) in
            if error == nil {
                success()
            } else {
                failure(error)
            }
        })
    }
    
    class func getRecognizedUsers(success: @escaping ([RecognizedUserModel]) -> (), failure: @escaping (Error?) -> ()) {
        // TODO change id to user id
        _ = client?.listPersons(withPersonGroupId: "2", completionBlock: { (persons, error) in
            if error == nil {
                
                CoreDataController.sharedController.deleteAllRecognizedUsers()
                var recognizedUsers = [RecognizedUserModel]()
                for person in persons! {
                    let recognizedUser = RecognizedUserModel()
                    recognizedUser.id = person.personId
                    recognizedUser.name = person.name
                    recognizedUser.relation = person.userData
                    recognizedUsers.append(recognizedUser)
                }
                CoreDataController.sharedController.addRecognizedUsers(models: recognizedUsers)
                success(recognizedUsers)
            } else {
                failure(error)
            }
        })
    }
    
    class func createRecognizedUser(name: String, relation: String, success: @escaping (RecognizedUserModel) -> (), failure: @escaping (Error?) -> ()) {
        
        _ = client?.createPerson(withPersonGroupId: "2", name: name, userData: relation, completionBlock: { (person, error) in
            if error == nil {
                let recognizedUser = RecognizedUserModel()
                recognizedUser.id = person?.personId
                recognizedUser.name = name
                recognizedUser.relation = relation
                success(recognizedUser)
            } else {
                failure(error)
            }
        })
    }
    
    class func deleteRecognizedUser(recognizedUser: RecognizedUserModel, success: @escaping (RecognizedUserModel) -> (), failure: @escaping (Error?) -> ()) {
        
        _ = client?.deletePerson(withPersonGroupId: "2", personId: recognizedUser.id, completionBlock: { (error) in
            if error == nil {
                success(recognizedUser)
            } else {
                failure(error)
            }
        })
    }

    
    class func createFaceForRecognizedUser(recognizedUserId: String, image: UIImage, success: @escaping (UIImage) -> (), failure: @escaping (Error?) -> ()) {
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: image.size)
        let rect2 = MPOFaceRectangle()
        rect2.left = rect.origin.x as NSNumber!
        rect2.top = rect.origin.y as NSNumber!
        rect2.width = rect.size.width as NSNumber!
        rect2.height = rect.size.height as NSNumber!
        
        // TODO change id to user id
        _ = client?.addPersonFace(withPersonGroupId: "2", personId: recognizedUserId, data: data, userData: nil, faceRectangle: rect2, completionBlock: { (persistedFaceResult, error) in
            if error == nil {
                success(image)
            } else {
                failure(error)
            }
        })
    }
    
    class func getIdentifiedFaces(image: UIImage, success: @escaping (UIImage) -> (), failure: @escaping (Error?) -> ()) {
        let recognizedUsers = CoreDataController.sharedController.getRecognizedUsers()
        var faceIds = [String]()
        for recognizedUser in recognizedUsers! {
            faceIds.append(recognizedUser.id)
        }
        _ = client?.identify(withPersonGroupId: "2", faceIds: faceIds, maxNumberOfCandidates: 5, completionBlock: { (identifyResult, error) in
            
        })
    }

    
}
