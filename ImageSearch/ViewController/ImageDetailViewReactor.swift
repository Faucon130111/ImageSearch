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
        case closeButtonTapped
    }
    
    enum Mutation {
        case setImageHeight(CGFloat)
        case loadImageURL(String?)
        case loadDisplaySiteName(String?)
        case loadDateTime(String?)
        case dismiss
    }
    
    struct State {
        var imageHeight: CGFloat = 100.0
        var imageURL: String? = nil
        var displaySiteName: String? = nil
        var dateTime: String? = nil
        var dismiss: Bool = false
    }
    
    fileprivate var imageModel: ImageModel
    var initialState: State = State()
    
    init(imageModel: ImageModel) {
        self.imageModel = imageModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadImageDetail:
            let screenWidth = UIScreen.main.bounds.width
            let imageWidth = CGFloat(imageModel.width)
            let imageHeight = CGFloat(imageModel.height)
            let ratio = screenWidth / imageWidth
            
            return .concat(
                .just(.setImageHeight(imageHeight * ratio)),
                .just(.loadImageURL(imageModel.image_url)),
                .just(.loadDisplaySiteName(imageModel.display_sitename)),
                .just(.loadDateTime(imageModel.datetime))
            )
            
        case .closeButtonTapped:
            return .just(.dismiss)
            
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case let .setImageHeight(height):
            newState.imageHeight = height
            return newState
        
        case let .loadImageURL(imageURL):
            newState.imageURL = imageURL
            return newState
        
        case let .loadDisplaySiteName(displaySiteName):
            newState.displaySiteName = displaySiteName
            return newState
            
        case let .loadDateTime(dateTime):
            newState.dateTime = dateTime
            return newState
            
        case .dismiss:
            newState.dismiss = true
            return newState
            
        }
    }
}
