//
//  ViewController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class ViewController: UIViewController {

    
    var groups = [MPOPersonGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let a = UIButton(frame: CGRect(x: 50, y: 50, width: 150, height: 50))
        a.setTitle("add group", for: .normal)
        a.setTitleColor(UIColor.purple, for: .normal)
        a.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        self.view.addSubview(a)
        
        
        
        
        let b = UIButton(frame: CGRect(x: 50, y: 250, width: 150, height: 50))
        b.setTitle("add group", for: .normal)
        b.setTitleColor(UIColor.purple, for: .normal)
        b.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        self.view.addSubview(b)

        
        
        
        let c = UIButton(frame: CGRect(x: 50, y: 450, width: 150, height: 50))
        c.setTitle("add group", for: .normal)
        c.setTitleColor(UIColor.purple, for: .normal)
        c.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        self.view.addSubview(c)

    }

    func createGroup() {
        let client = MPOFaceServiceClient(subscriptionKey: MicrosoftFaceAPISubscriptionKey)

        let x = client?.createPersonGroup(withId: "asd", name: "friends", userData: nil, completionBlock: { (error) in
            if error == nil {
                let group = MPOPersonGroup()
                group.personGroupId = "asd"
                group.name = "friends"
                self.groups.append(group)
            }
        })
        x?.resume()
    }
    
    
    func addPersonToGroup() {
        let client = MPOFaceServiceClient(subscriptionKey: MicrosoftFaceAPISubscriptionKey)

        let x = client?.addPersonFace(withPersonGroupId: "", personId: <#T##String!#>, data: <#T##Data!#>, userData: <#T##String!#>, faceRectangle: <#T##MPOFaceRectangle!#>, completionBlock: <#T##((MPOAddPersistedFaceResult?, Error?) -> Void)!##((MPOAddPersistedFaceResult?, Error?) -> Void)!##(MPOAddPersistedFaceResult?, Error?) -> Void#>)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

