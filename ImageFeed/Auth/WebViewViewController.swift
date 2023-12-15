//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.08.2023.
//

import UIKit
import WebKit

    // MARK: - WebViewViewControllerDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
    // MARK: - WebViewViewController
final class WebViewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    
    private struct WebKeyConstant {
        static let clientID = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
    }
    private struct WebConstant {
        static let authURL = "https://unsplash.com/oauth/authorize"
        static let autorizedPath = "/oauth/authorize/native"
        static let code = "code"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        requestWebView()
        updateProgress()
    }
    // MARK: - Progress View
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    // MARK: - Remove Observer
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil)
    }
    // MARK: Back Button
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
// MARK: - WebView

extension WebViewViewController {
    func requestWebView() {
        var urlComponents = URLComponents(string: WebConstant.authURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: WebKeyConstant.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebKeyConstant.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: WebKeyConstant.responseType, value: WebConstant.code),
            URLQueryItem(name: WebKeyConstant.scope, value: Constants.accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let code = fetchCode(from: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
            
        }
    }
    
     func fetchCode(from url: URL?) -> String? {
        guard let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebConstant.autorizedPath,
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == WebConstant.code })
        else { return nil}
        return codeItem.value
    }
}
