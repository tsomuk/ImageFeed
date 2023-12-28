//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 28/12/2023.
//

import Foundation


public protocol WebViewPresenterController {
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
} 
