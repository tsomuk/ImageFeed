//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.08.2023.
//

import UIKit
import WebKit


final class WebViewViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
    
    }
    
    
    // identifier for segue = "ShowWebView"
}
