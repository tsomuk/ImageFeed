//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.08.2023.
//

import UIKit
import WebKit

// MARK: - Protocols
protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String)
  func webViewViewControllerDidCancel(_ viewController: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
  var presenter: WebViewPresenterProtocol? { get set }
  func load(request: URLRequest)
  func setProgressValue(_ newValue: Float)
  func setProgressHidden(_ flag: Bool)
}


final class WebViewViewController: UIViewController {
  // MARK: - Private properties

  private var estimatedProgressObservation: NSKeyValueObservation?
  var presenter: WebViewPresenterProtocol?

  // MARK: - Outlets

  @IBOutlet private weak var webView: WKWebView!
  @IBOutlet private weak var progressView: UIProgressView!

  // MARK: - Public properties

  weak var delegate: WebViewViewControllerDelegate?

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.navigationDelegate = self
      progressView.setProgress(0, animated: true)
    setupWebViewObserve()
    presenter?.viewDidLoad()
  }

  // MARK: - Actions

  @IBAction private func didTapBackButton(_ sender: Any?) {
    delegate?.webViewViewControllerDidCancel(self)
  }
}

// MARK: - Private methods

private extension WebViewViewController {

  func setupWebViewObserve() {
    estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) {
      [weak self ] _, _ in
      guard let self else { return }
      self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
    }
  }

  func fetchCode(from navigationAction: WKNavigationAction) -> String? {
    if
      let url = navigationAction.request.url {
      return presenter?.code(from: url)
    } else {
      return nil
    }
  }
}

// MARK: - WebViewViewControllerProtocol

extension WebViewViewController: WebViewViewControllerProtocol {
  func load(request: URLRequest) {
    webView.load(request)
  }

  func setProgressValue(_ newValue: Float) {
    progressView.setProgress(newValue, animated: true)
  }

  func setProgressHidden(_ flag: Bool) {
    progressView.isHidden = flag
  }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    if let code = fetchCode(from: navigationAction) {
      delegate?.webViewViewController(self, didAuthenticateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}
