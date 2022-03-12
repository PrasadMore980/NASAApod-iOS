//
//  Constants.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation
import UIKit

class Constants {
    
    // My API Key
    static let kAPIKey = "gouBUHuspYZH29udIoCAcppzOahYCxJ3acEG1D2x"
    
    //sample URL - https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY
    static let baseURL = "https://api.nasa.gov/planetary/apod?api_key="

    //Core Data Entity Name
    static let kEntityName = "APODList"
    static let favFilledImage = UIImage(systemName: "heart.fill")
    static let favImage = UIImage(systemName: "heart")
    static let listImage = UIImage(systemName: "list.bullet.rectangle.portrait")

}
