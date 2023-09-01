//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 01.09.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthViewSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      if oAuth2TokenStorage.token == nil {
        performSegue(withIdentifier: showAuthViewSegueIdentifier, sender: nil)
      } else {
        switchToTabBarController()
      }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == showAuthViewSegueIdentifier {
        guard
          let navigationController = segue.destination as? UINavigationController,
          let viewController = navigationController.viewControllers[0] as? AuthViewController else {
          preconditionFailure("Error with \(showAuthViewSegueIdentifier)")
        }
        viewController.delegate = self
      } else {
        super.prepare(for: segue, sender: sender)
      }
    }
  }

  // MARK: - Private methods

  private extension SplashViewController {
    func switchToTabBarController() {
      guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
      let tabBarController = UIStoryboard(name: "Main", bundle: .main)
        .instantiateViewController(withIdentifier: "TabBarViewController")
      window.rootViewController = tabBarController
    }

    func fetchAuthToken(with code: String) {
      oAuth2Service.fetchAuthToken(with: code) { [weak self] result in
        guard let self else { preconditionFailure("Cannot make weak link") }
        switch result {
        case .success(let result):
          print("ITS LIT \(result)")
          dismiss(animated: true)
          self.switchToTabBarController()
        case .failure(let error):
          print("The error \(error)")
        }
      }
    }
  }

  // MARK: - AuthViewControllerDelegate

  extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
      fetchAuthToken(with: code)
    }
  }

