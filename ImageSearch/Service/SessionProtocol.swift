//
//  SessionProtocol.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/14.
//

import Alamofire
import RxSwift

protocol SessionProtocol {
    func json(
        _ method: HTTPMethod,
        _ url: URLConvertible,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        interceptor: RequestInterceptor?
    ) -> Observable<Any>
}

extension Reactive: SessionProtocol where Base: Alamofire.Session {
}
