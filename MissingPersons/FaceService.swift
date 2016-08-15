//
//  FaceService.swift
//  MissingPersons
//
//  Created by Romain Pardon on 11/08/2016.
//  Copyright © 2016 SlasherApp. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "53ce576c0b5d429eb86dbc2ed29c5015")
}