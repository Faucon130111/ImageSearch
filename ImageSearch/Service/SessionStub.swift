//
//  SessionStub.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/14.
//

@testable import Alamofire
import RxSwift

final class SessionStub: SessionProtocol {
    
    var requestParameters: (
        method: HTTPMethod,
        url: URLConvertible,
        parameters: Parameters?
    )?
    
    func json(
        _ method: HTTPMethod,
        _ url: URLConvertible,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        interceptor: RequestInterceptor?
    ) -> Observable<Any> {
        self.requestParameters = (
            method: method,
            url: url,
            parameters: parameters
        )
        
        return .just("")
    }
    
    
}
