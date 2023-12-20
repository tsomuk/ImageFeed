//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 09/12/2023.
//

import Foundation

final class ImageListService {
    
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImageListService()
    static let didChangeNotiffication = Notification.Name("ImageListServiceDidChange")
    
    private let session = URLSession.shared
    private let requestBuiler = URLRequestBuilder.shared
    
    
    private var currentTask : URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    private init() { }
    
    
    
    func makePhotoRequest(page: Int) -> URLRequest? {
        requestBuiler.makeHTTPRequest(path: Constants.photoPathString + "?page=\(page)")
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
        createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
        welcomeDescription: photoResult.description,
        thumbImageURL: photoResult.urls.small,
        largeImageURL: photoResult.urls.full,
        isLiked: photoResult.likedByUser,
        thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
      )
    }
    
    
    
    func fetchPhotoNextPage()  {
        
        assert(Thread.isMainThread)
        guard currentTask == nil else {
            debugPrint("Rave condition ILS42")
            return
        }
        let nextPage = makeNextPageNumber()
        
        guard let request = makePhotoRequest(page: nextPage) else {
            assertionFailure("Invalid Request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("Can't make weak link") }
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        photos.append(self.convert(result: photo))
                        debugPrint("TEST PRINT IMAGE URL",photo.urls)
                    }
                    
                }
            case .failure(let error):
                debugPrint("Ошибка ILS 61",error.localizedDescription)
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    
    }
}



     
