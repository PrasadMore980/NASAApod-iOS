//
//  DataModel.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation

struct NASAResponse: Codable {
    var copyright: String?
    var date: String?
    var explanation: String?
    var hdurl: String?
    
    var mediaType: String?
    var serviceVersion: String?
    var title: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl, title, url
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }
    
    init() {}
}
