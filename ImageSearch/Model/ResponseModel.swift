//
//  ResponseModel.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Foundation

/// 다음 이미지 검색 결과
struct ResponseModel: Codable {
    var meta: MetaModel
    var documents: [DocumentModel]
}
