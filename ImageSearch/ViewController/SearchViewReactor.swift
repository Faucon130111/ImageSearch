//
//  SearchViewReactor.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit

class SearchViewReactor: Reactor {
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setImages([DocumentModel], Int?)
        case appendImages([DocumentModel], Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var page: Int?
        var documentModels: [DocumentModel]?
        var isLoadingNextPage: Bool = false
    }

    fileprivate var networkService: NetworkServiceType
    var initialState: State = State()
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return .concat(
                .just(.setQuery(query)),
                
                networkService.fetchImages(
                    query: query,
                    size: 30,
                    page: 1
                )
                .map { Mutation.setImages($0, $1) }
            )
            
        case .loadNextPage:
            guard let page = currentState.page,
                  currentState.isLoadingNextPage == false
            else {
                return .empty()
            }
            
            return .concat(
                .just(.setLoadingNextPage(true)),
                
                networkService.fetchImages(
                    query: currentState.query,
                    size: 30,
                    page: page
                )
                .map { Mutation.appendImages($0, $1) },
                
                .just(.setLoadingNextPage(false))
            )
            
        }
    }

    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case let .setQuery(query):
            newState.query = query
            return newState
            
        case let .setImages(documentModels, nextPage):
            newState.documentModels = documentModels
            newState.page = nextPage
            return newState
            
        case let .appendImages(documentModels, nextPage):
            if newState.documentModels == nil {
                newState.documentModels = []
            }
            newState.documentModels!.append(contentsOf: documentModels)
            newState.page = nextPage
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
            
        }
    }
    
    func reactorForImageDetail(_ indexPath: IndexPath) -> ImageDetailViewReactor {
        let documentModel = currentState.documentModels![indexPath.row]
        return ImageDetailViewReactor(documentModel: documentModel)
    }
    
}
