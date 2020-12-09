//
//  SearchViewReactor.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit

class SearchViewReactor: Reactor {
    
    enum Action {
        case fetchImages(String)
        case fetchMoreImages(String)
        case scrollReachedEnd
    }
    
    enum Mutation {
        case fetchImages([DocumentModel])
        case fetchMoreImages([DocumentModel])
        case updateLoadingState(Bool)
        case increasePageNumber
    }
    
    struct State {
        var documentModels: [DocumentModel] = []
        var isLoading: Bool = false
        var page: Int = 1
    }

    fileprivate var networkService: NetworkServiceType
    var initialState: State = State()
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // FIXME: init collection view, .just(.increasePageNumber
        case let .fetchImages(query):
            let isLoading: Observable<Mutation> = .just(.updateLoadingState(true))
            let loadingComplete: Observable<Mutation> = .just(.updateLoadingState(false))
            let fetchImage: Observable<Mutation> = networkService.fetchImages(
                query: query,
                size: 30,
                page: self.currentState.page
            )
            .map(Mutation.fetchImages)
            
            return .concat(
                isLoading,
                fetchImage,
                loadingComplete
            )
            
        case let .fetchMoreImages(query):
            let isLoading: Observable<Mutation> = .just(.updateLoadingState(true))
            let loadingComplete: Observable<Mutation> = .just(.updateLoadingState(false))
            let fetchMoreImage: Observable<Mutation> = networkService.fetchImages(
                query: query,
                size: 30,
                page: self.currentState.page
            )
            .map(Mutation.fetchMoreImages)
            
            return .concat(
                isLoading,
                fetchMoreImage,
                loadingComplete
            )
            
        case .scrollReachedEnd:
            let isLoading: Observable<Mutation> = .just(.updateLoadingState(true))
            
            if currentState.isLoading {
                return isLoading
            }
            
            return .concat(
                isLoading,
                .just(.increasePageNumber)
            )
            
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
            
        case let .fetchMoreImages(documentModels):
            newState.documentModels += documentModels
            return newState
            
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
            return newState
            
        case .increasePageNumber:
            newState.page += 1
            return newState
            
        }
    }
    
    func reactorForImageDetail(_ indexPath: IndexPath) -> ImageDetailViewReactor {
        let documentModel = currentState.documentModels[indexPath.row]
        return ImageDetailViewReactor(documentModel: documentModel)
    }
    
}
