//
//  ViewController.swift
//  Chapter08_Alamofire
//
//  Created by 김광준 on 2020/08/04.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private let userIdTextField: UITextField = {
        let userId: UITextField = UITextField()
        userId.borderStyle = UITextField.BorderStyle.none
        userId.layer.cornerRadius = 8.0
        userId.layer.borderWidth = 1.0
        userId.layer.borderColor = UIColor.systemGray.cgColor
        userId.sizeToFit()
        userId.placeholder = "User ID"
        userId.textAlignment = NSTextAlignment.left
        return userId
    }()
    
    private let userNameTextField: UITextField = {
        let userName: UITextField = UITextField()
        userName.borderStyle = UITextField.BorderStyle.none
        userName.layer.cornerRadius = 8.0
        userName.layer.borderWidth = 1.0
        userName.layer.borderColor = UIColor.systemGray.cgColor
        userName.sizeToFit()
        userName.placeholder = "User Name"
        userName.textAlignment = NSTextAlignment.left
        return userName
    }()
    
    private let postAlamofireButton: UIButton = {
        let postButton: UIButton = UIButton()
        postButton.setTitle("POST_Alamofire", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        postButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        postButton.backgroundColor = UIColor.systemBlue
        postButton.layer.cornerRadius = 8.0
        postButton.layer.borderWidth = 1.0
        postButton.layer.borderColor = UIColor.white.cgColor
        return postButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpAutolayoutAndAddSubViews()
    }
    
    private func setUpAutolayoutAndAddSubViews() {
        setUpUserIdTextField()
        setUpUserNameTextField()
        setUpPostAlamofireButton()
    }
    
    private func setUpUserIdTextField() {
        let guide = self.view.safeAreaLayoutGuide
        
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userIdTextField)
        
        NSLayoutConstraint.activate([
            userIdTextField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30),
            userIdTextField.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            userIdTextField.widthAnchor.constraint(equalToConstant: 200),
            userIdTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setUpUserNameTextField() {
        let guide = self.view.safeAreaLayoutGuide
        
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userNameTextField)
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 30),
            userNameTextField.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            userNameTextField.widthAnchor.constraint(equalTo: userIdTextField.widthAnchor),
            userNameTextField.heightAnchor.constraint(equalTo: userIdTextField.heightAnchor),
        ])
    }
    
    private func setUpPostAlamofireButton() {
        let guide = self.view.safeAreaLayoutGuide
        
        postAlamofireButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(postAlamofireButton)
        
        NSLayoutConstraint.activate([
            postAlamofireButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
            postAlamofireButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            postAlamofireButton.widthAnchor.constraint(equalToConstant: 150),
            postAlamofireButton.heightAnchor.constraint(equalToConstant: 30 * 1.5),
//            postAlamofireButton.widthAnchor.constraint(lessThanOrEqualTo: userIdTextField.widthAnchor, multiplier: 2/1),
//            postAlamofireButton.heightAnchor.constraint(greaterThanOrEqualTo: userIdTextField.heightAnchor, multiplier: 1.5),
        ])
        
        postAlamofireButton.addTarget(self, action: #selector(postButtonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func postButtonAction(_ sender: UIButton) {
        print("동작")
    }


}

