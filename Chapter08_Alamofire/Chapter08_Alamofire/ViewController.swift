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
//        userId.borderStyle = UITextField.BorderStyle.roundedRect
        userId.layer.cornerRadius = 8.0
        userId.layer.borderWidth = 1.0
        userId.layer.borderColor = UIColor.systemGray.cgColor
//        userId.sizeToFit()
        userId.placeholder = "User ID"
        userId.textAlignment = NSTextAlignment.left
        return userId
    }()
    
    private let userNameTextField: UITextField = {
        let userName: UITextField = UITextField()
//        userName.borderStyle = UITextField.BorderStyle.roundedRect
        userName.layer.cornerRadius = 8.0
        userName.layer.borderWidth = 1.0
        userName.layer.borderColor = UIColor.systemGray.cgColor
//        userName.sizeToFit()
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
    
    private let resultTextView: UITextView = {
        let resultTxtField: UITextView = UITextView()
        resultTxtField.layer.borderWidth = 1.0
        resultTxtField.layer.borderColor = UIColor.systemGray.cgColor
        return resultTxtField
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
        setUpResultTextField()
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
            postAlamofireButton.widthAnchor.constraint(equalToConstant: 170),
            postAlamofireButton.heightAnchor.constraint(equalToConstant: 30 * 1.5),
        ])
        
        postAlamofireButton.addTarget(self, action: #selector(postButtonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func postButtonAction(_ sender: UIButton) {
        // 1. 전송할 값 준비
        let userId = self.userIdTextField.text ?? "아이디 값이 없음"
        let name = self.userNameTextField.text ?? "이름 값이 없음"
        let param = [
            "userId" : userId,
            "userName" : name
        ]
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        // 2. Alamofire.requset 객체 생성
        let alamo = AF.request("http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: header)
        
        // 3. 응답 처리
        alamo.responseJSON { (response) in
            // alamofire 로 가져온 값이 success일 경우
            switch response.result {
            case .success(let successValue):
                print(successValue)
                do {
                    guard let jsonObjects = response.value else { return }
                    guard let data = jsonObjects as? NSDictionary else { return }
//                    // JSON 결과값 추출
                    guard let result = data["result"] as? String else { return }
                    guard let timeStamp = data["timestamp"] as? String else { return }
                    guard let userId = data["userId"] as? String else { return }
                    guard let userName = data["userName"] as? String else { return }

                    // result TextField에 값을 넣어주기
                    self.resultTextView.text = "아이디 : \(userId)" + "\n"
                    + "이름 : \(userName)" + "\n"
                    + "응답결과 : \(result)" + "\n"
                    + "응답시간 : \(timeStamp)" + "\n"
                    + "요청방식 : application/json"
                } catch {
                    print(error.localizedDescription)
                }
            // alamofire 로 가져온 값이 failure일 경우
            case .failure(let e):
                print(e.localizedDescription)
                break
            }
        }
        
    }
    
    private func setUpResultTextField() {
        let guide = self.view.safeAreaLayoutGuide
        
        resultTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(resultTextView)
        
        NSLayoutConstraint.activate([
            resultTextView.topAnchor.constraint(equalTo: self.postAlamofireButton.bottomAnchor, constant: 30),
            resultTextView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            resultTextView.widthAnchor.constraint(equalToConstant: 300),
            resultTextView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

