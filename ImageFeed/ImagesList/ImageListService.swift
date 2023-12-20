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
    
    func fetchPhotoNextPage()  {
        
        assert(Thread.isMainThread)
        
        let nextPage = makeNextPageNumber()
        
        guard let request = makePhotoRequest(page: nextPage) else {
            assertionFailure("Invalid Request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        debugPrint("TEST PRINT IMAGE URL",photo.urls)
                    }
                    
                }
            case .failure(let error):
                debugPrint("Ошибка ILS 61",error.localizedDescription)
            }
//            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    
    }
}



     
