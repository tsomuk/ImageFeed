//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 09/12/2023.
//

import Foundation

protocol ImageListLoading: AnyObject {
    func fetchPhotoNextPage()
    func resetPhotos()
    func changeLike(photoId: String, indexPath: IndexPath, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ImageListService {
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    static let dateFormatter = ISO8601DateFormatter()
    
    private let session = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    
    private var currentTask : URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private init() { }
    
    func makePhotoRequest(page: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: Constants.photoPathString + "?page=\(page)")
    }
    
    func makeLikeRequest(for id: String, with method: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/photos/\(id)/like", httpMethod: method)
    }
    
    func makeNextPageNumber() -> Int {
        guard let lastLoadedPage else { return 1 }
        return lastLoadedPage + 1
    }
    
    func convert(result photoResult: PhotoResult) -> Photo {
        let thumbWidth = 200.0
        let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
        let thumbHeight = thumbWidth / aspectRatio
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: ImageListService.dateFormatter.date(from: photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser,
            thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
        )
    }
}

extension ImageListService : ImageListLoading {
    
    func changeLike(photoId: String, indexPath: IndexPath, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        guard Thread.isMainThread else {
            assertionFailure("changeLike должен вызываться из главного потока")
            return
        }

        guard currentTask == nil else {
            return
        }

        currentTask?.cancel()

        let method = isLike ? Constants.postMethodString : Constants.deleteMethodString

        guard let request = makeLikeRequest(for: photoId, with: method) else {
            assertionFailure("Invalid request")
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let photoLiked):
                    let likedByUser = photoLiked.photo.likedByUser
                    self.photos[indexPath.row].isLiked = likedByUser
                    completion(.success(likedByUser))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func resetPhotos() {
        photos = []
    }
    
    func fetchPhotoNextPage() {
        assert(Thread.isMainThread)
        
        if currentTask != nil { return }
        currentTask?.cancel()
        let nextPage = makeNextPageNumber()
        
        guard let request = makePhotoRequest(page: nextPage) else {
            assertionFailure("Invalid request")
            debugPrint(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("Can't make weak link") }
            DispatchQueue.main.async {
                self.currentTask = nil
                switch result {
                case .success(let photoResults):
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        photos.append(self.convert(result: photo))
                    }
                    self.photos += photos
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos]
                    )
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        currentTask = task
        task.resume()
    }
}
