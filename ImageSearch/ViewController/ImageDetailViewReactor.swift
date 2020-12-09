//
//  ImageDetailViewReactor.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import ReactorKit

class ImageDetailViewReactor: Reactor {
    
    enum Action {
        case loadImageDetail
    }
    
    enum Mutation {
        case loadImageURL(String?)
        case loadDisplaySiteName(String?)
        case loadDateTime(String?)
    }
    
    struct State {
        var imageURL: String? = nil
        var displaySiteName: String? = nil
        var dateTime: String? = nil
    }
    
    fileprivate var documentModel: DocumentModel
    var initialState: State = State()
    
    init(documentModel: DocumentModel) {
        self.documentModel = documentModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadImageDetail:
            return .concat(
                .just(.loadImageURL(documentModel.image_url)),
                .just(.loadDisplaySiteName(documentModel.display_sitename)),
                .just(.loadDateTime(documentModel.datetime))
            )
            
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case let .loadImageURL(imageURL):
            newState.imageURL = imageURL
            return newState
        
        case let .loadDisplaySiteName(displaySiteName):
            newState.displaySiteName = displaySiteName
            return newState
            
        case let .loadDateTime(dateTime):
            newState.dateTime = dateTime
            return newState
            
        }
    }
}
