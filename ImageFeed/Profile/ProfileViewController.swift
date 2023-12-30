//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.07.2023.
//

import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func loadProfile(_ profile: Profile?)
}

final class ProfileViewController: UIViewController {
    
    private var userPickImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    private var alertPresenter: AlertPresenting?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfilePresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        presenter?.viewDidLoad()
        setupNotificationObserver()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
    
    func setupNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                self?.updateAvatar(notification: notification)
            }
    }
    
    func prepareUI() {
        
        view.backgroundColor = .ypBlack
        
        // MARK: - image
        userPickImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPickImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPickImageView.layer.cornerRadius = 35
        userPickImageView.clipsToBounds = true
        
        view.addSubview(userPickImageView)
        userPickImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userPickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        userPickImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        // MARK: - Label - Name
        userNameLabel.text = "Tsomuk  Nikita_mock"
        userNameLabel.textColor = .ypWhite
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: userPickImageView.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor).isActive = true
        
        // MARK: - Label - login
        loginLabel.text = "@tsomuk_mock"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        
        // MARK: - Label - message
        descriptionLabel.text = "Hello world_mock"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        
        
        // MARK: - Button
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton) )
        
        logoutButton.tintColor = .ypRed
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: userPickImageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        showAlert()
    }
}

extension ProfileViewController {
func showAlert() {
    DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttonText: "Да",
            completion: { self.presenter?.resetAccount() },
            secondButtonText: "Нет",
            secondCompletion: { self.dismiss(animated: true) }
        )
        self.alertPresenter?.showAlert(for: alertModel)
    }
}
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func updateAvatar(url: URL) {
        userPickImageView.kf.indicatorType = .activity
        userPickImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "person.crop.circle.fill")
        )
    }
    
    func loadProfile(_ profile: Profile?) {
        if let profile {
            userNameLabel.text = profile.name
            loginLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            userNameLabel.text = ""
            loginLabel.text = ""
            descriptionLabel.text = ""
        }
    }
}
