//
//  DocumentModel.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Foundation

/// 검색된 이미지 정보
struct DocumentModel: Codable, Equatable {
    /// 컬렉션
    var collection: String
    /// 미리보기 이미지 URL
    var thumbnail_url: String
    /// 이미지 URL
    var image_url: String
    /// 이미지의 가로 길이
    var width: Int
    /// 이미지의 세로 길이
    var height: Int
    /// 출처
    var display_sitename: String
    /// 문서 URL
    var doc_url: String
    /// 문서 작성시간. ISO 8601. [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
    var datetime: String
}
