//
//  ResponseModel.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Foundation

struct ResponseModel: Codable {
    var meta: MetaModel
    var documents: [DocumentModel]
}
