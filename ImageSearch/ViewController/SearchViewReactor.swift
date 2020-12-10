//
//  SearchViewReactor.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit

class SearchViewReactor: Reactor {
    
    enum Action {
        case requestSearchImages(String)
        case fetchImages
        case scrollReachedEnd
        case swipeHorizontal
    }
    
    enum Mutation {
        case storeNewQuery(String)
        case fetchImages([DocumentModel])
        case updateLoadingState(Bool)
        case increasePageNumber
        case dismissKeyboard
    }
    
    struct State {
        var documentModels: [DocumentModel] = []
        var query: String = ""
        var page: Int = 0
        var isLoading: Bool = false
        var dismissKeyboard: Bool = false
    }

    fileprivate var networkService: NetworkServiceType
    var initialState: State = State()
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .requestSearchImages(query):
            return .concat(
                .just(.dismissKeyboard),
                .just(.fetchImages([])),
                .just(.storeNewQuery(query)),
                .just(.increasePageNumber)
            )
        
        case .fetchImages:
            return .concat(
                .just(.updateLoadingState(true)),
                networkService.fetchImages(
                    query: self.currentState.query,
                    size: 30,
                    page: self.currentState.page
                )
                .catchError({ error in
                    print("### error: \(error)")
                    return .just([])
                })
                .map(Mutation.fetchImages),
                .just(.updateLoadingState(false))
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
         
        case .swipeHorizontal:
            return .just(.dismissKeyboard)
            
        }
    }

    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case let .storeNewQuery(query):
            newState.query = query
            return newState
        
        case let .fetchImages(documentModels):
            if documentModels.isEmpty {
                newState.page = 0
                newState.documentModels = documentModels
            } else {
                newState.documentModels += documentModels
            }
            return newState
            
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
            return newState
            
        case .increasePageNumber:
            newState.page += 1
            return newState
            
        case .dismissKeyboard:
            newState.dismissKeyboard = true
            return newState
            
        }
    }
    
    func reactorForImageDetail(_ indexPath: IndexPath) -> ImageDetailViewReactor {
        let documentModel = currentState.documentModels[indexPath.row]
        return ImageDetailViewReactor(documentModel: documentModel)
    }
    
}
