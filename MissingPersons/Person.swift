//
//  Person.swift
//  MissingPersons
//
//  Created by Romain Pardon on 11/08/2016.
//  Copyright © 2016 SlasherApp. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace

class Person {
    var faceId: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String) {
        self.personImageUrl = personImageUrl
    }
    
    func downloadFaceId(){
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, err:NSError!) in
                if err == nil {
                    var faceId: String?
                    for face in faces {
                        faceId = face.faceId
                        print("Face id: \(faceId)")
                        break
                    }
                    
                    self.faceId = faceId
                }
            })
        }
    }
}