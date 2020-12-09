//
//  DocumentModel.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Foundation

struct DocumentModel: Codable {
    var height: Int
    var thumbnail_url: String
    var datetime: String
    var image_url: String
    var collection: String
    var doc_url: String
    var width: Int
    var display_sitename: String
}
