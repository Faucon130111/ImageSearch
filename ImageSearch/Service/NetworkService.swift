//
//  NetworkService.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import Alamofire
import RxSwift
import RxAlamofire

protocol NetworkServiceType {
    func fetchImages(
        query: String,
        size: Int,
        page: Int
    ) -> Observable<[DocumentModel]>
}

class NetworkService: NetworkServiceType {
    
    func fetchImages(
        query: String,
        size: Int = 30,
        page: Int
    ) -> Observable<[DocumentModel]> {
        let parameters: Parameters = [
            "query": query,
            "sort": "recency",
            "size": 30,
            "page": page
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 0610a681b98c978c90fc4a3c58bfbc7c"
        ]
        
        return json(
            .get,
            "https://dapi.kakao.com/v2/search/image",
            parameters: parameters,
            headers: headers
        )
        .map { response in
            guard let jsonData = try? JSONSerialization.data(
                    withJSONObject: response,
                    options: .prettyPrinted
            ),
            let responseModel: ResponseModel = try? JSONDecoder().decode(
                ResponseModel.self,
                from: jsonData
            )
            else {
                return []
            }
            return responseModel.documents
        }
        .do(onError: { error in
            print("⚠️ Network error: \(error.localizedDescription)")
        })
        .catchErrorJustReturn([])
    }
    
}
