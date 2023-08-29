//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.07.2023.
//

import UIKit


final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        prepareUI()
        
        
    }
    func prepareUI() {
        // MARK: - image
        let userPickImageView = UIImageView(image: UIImage(named: "userPic"))
//        userPickImageView.tintColor = .gray
        userPickImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPickImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPickImageView.layer.cornerRadius = 35
        userPickImageView.clipsToBounds = true
        
        view.addSubview(userPickImageView)
        userPickImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userPickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userPickImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        // MARK: - Label - Name
        let userNameLabel = UILabel()
        userNameLabel.text = "Tsomuk  Nikita"
        userNameLabel.textColor = UIColor.ypWhite
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: userPickImageView.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor).isActive = true
        
        // MARK: - Label - login
        let loginLabel = UILabel()
        loginLabel.text = "@tsomuk"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor.ypGray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        
        // MARK: - Label - message
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello world"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = UIColor.ypWhite
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        
        
        
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
    }
    
}
