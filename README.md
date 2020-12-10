# ImageSearch

### 프로젝트 내용

- 카카오 Daum 이미지 검색 API를 사용하여 이미지 검색 앱 구현

### 구현 사항

- UISearchBar에 문자를 입력 후 1초가 지나면 자동으로 검색

- 검색어가 변경되면 목록 리셋 후 다시 데이터를 fetch
  
  - 데이터는 30개씩 페이징 처리
  
  - 스크롤 시 데이터 30개씩 추가 fetch

- 검색 결과 목록은 UICollectionView를 사용하여 3xN 그리드 모양으로 구성
  
  - 검색 결과가 없을 경우 '검색 결과가 없습니다.' 메시지를 화면에 보여줌
  
  - 검색 결과 목록 중 하나를 탭 하였을 때 전체 화면으로 이미지 보여줌
    
    - 좌우 여백은 0
    
    - 이미지의 비율을 유지 (세로로 길 경우 스크롤 됨)
  
  - 출처와 문서 작성 시간이 있을 경우 이미지 아래 부분에 표시

### 기술 스택

- Swift 5

- Auto Layout (Storyboard)

- [CocoaPods](https://cocoapods.org)

- [Kingfisher](https://github.com/onevcat/Kingfisher)

- [RxSwift](https://github.com/ReactiveX/RxSwift)

- [RxAlamofire](https://github.com/RxSwiftCommunity/RxAlamofire)

- [RxGesture](https://github.com/RxSwiftCommunity/RxGesture)

- [RxOptional](https://github.com/RxSwiftCommunity/RxOptional)

- [RxViewController](https://github.com/devxoul/RxViewController)

- [ReactorKit](https://github.com/ReactorKit/ReactorKit)
