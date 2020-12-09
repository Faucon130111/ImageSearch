//
//  SearchViewReactor.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit

class SearchViewReactor: Reactor {
    
    enum Action {
        case searchImages(String)
    }
    
    enum Mutation {
        case fetchImages([DocumentModel])
    }
    
    struct State {
        var documentModels: [DocumentModel] = []
    }

    fileprivate var networkService: NetworkServiceType
    var initialState: State = State()
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchImages(query):
            return networkService.fetchImages(
                query: query,
                size: 30,
                page: 1
            )
            .map(Mutation.fetchImages)
            
        }
    }

    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case let .fetchImages(documentModels):
            newState.documentModels = documentModels
            return newState
            
        }
    }
    
    func reactorForImageDetail(_ indexPath: IndexPath) -> ImageDetailViewReactor {
        let documentModel = currentState.documentModels[indexPath.row]
        return ImageDetailViewReactor(documentModel: documentModel)
    }
    
}
