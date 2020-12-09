//
//  MetaModel.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Foundation

/// 검색 결과에 관한 정보
struct MetaModel: Codable {
    /// 검색된 문서 수
    var total_count: Int
    /// total_count 중 노출 가능 문서 수
    var pageable_count: Int
    /// 현재 페이지가 마지막 페이지인지 여부, 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
    var is_end: Bool
}
