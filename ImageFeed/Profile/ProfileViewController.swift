//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.07.2023.
//

import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    private var userPickImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let storage = OAuth2TokenStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        prepareUI()
        loadProfile()
        checkAvatar()
    }
      
    
    func loadProfile() {
      guard let profile = profileService.profile else {
        return
      }
      self.userNameLabel.text = profile.name
      self.loginLabel.text = profile.loginName
      self.descriptionLabel.text = profile.bio
    }
    
    
    func checkAvatar() {
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
    }
    
    
    @objc func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
    
    
    func updateAvatar(url: URL) {
        userPickImageView.kf.indicatorType = .activity
        userPickImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "person.crop.circle.fill")
        )
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
        print("LogOut Button")
        resetToken()
        resetView()
    }
    
}


private extension ProfileViewController {
    
    func resetToken() {
        
        guard storage.removeToken() else {
            assertionFailure("Can't remove token")
            return
        }
    }
    
    func resetView() {
        self.userNameLabel.text = "User Name"
        self.loginLabel.text = "@login"
        self.descriptionLabel.text = "bio info"
        self.userPickImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }
}

