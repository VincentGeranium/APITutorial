//
//  ViewController.swift
//  Chapter08_POST
//
//  Created by 김광준 on 2020/08/02.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let userId: UITextField = {
        let userId: UITextField = UITextField()
        userId.textAlignment = NSTextAlignment.left
        userId.borderStyle = UITextField.BorderStyle.roundedRect
        userId.layer.cornerRadius = 8.0
        userId.layer.borderWidth = 1
        userId.layer.borderColor = UIColor.systemGray.cgColor
        userId.placeholder = "User ID"
        return userId
    }()
    
    private let nameTextField: UITextField = {
        let name: UITextField = UITextField()
        name.textAlignment = NSTextAlignment.left
        name.borderStyle = UITextField.BorderStyle.roundedRect
        name.layer.cornerRadius = 8.0
        name.layer.borderWidth = 1
        name.layer.borderColor = UIColor.systemGray.cgColor
        name.placeholder = "Name"
        return name
    }()
    
    private let postButton: UIButton = {
        let postBtn: UIButton = UIButton()
        postBtn.setTitle("POST", for: UIControl.State.normal)
        postBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        postBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        postBtn.backgroundColor = UIColor.red
        postBtn.titleLabel?.sizeToFit()
        return postBtn
    }()
    
    private let responseTextView: UITextView = {
        let responseView: UITextView = UITextView()
        responseView.layer.borderWidth = 1
        responseView.layer.borderColor = UIColor.systemGray.cgColor
        return responseView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpUserId()
        setUpNameTextField()
        setUpPostButton()
        setUpResponseTextView()
    }
    
    private func setUpUserId() {
        let guide = view.safeAreaLayoutGuide
        
        userId.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userId)
        
        NSLayoutConstraint.activate([
            userId.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            userId.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            userId.widthAnchor.constraint(equalToConstant: 200),
            userId.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setUpNameTextField() {
        let guide = view.safeAreaLayoutGuide
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: userId.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: userId.widthAnchor),
            nameTextField.heightAnchor.constraint(equalTo: userId.heightAnchor),
        ])
    }
    
    private func setUpPostButton() {
        let guide = view.safeAreaLayoutGuide
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            postButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 100),
            postButton.heightAnchor.constraint(equalTo: userId.heightAnchor),
        ])
        
        postButton.addTarget(self, action: #selector(postAction), for: .touchUpInside)
    }
    
    @objc private func postAction(_ sender: UIButton) {
        // 1. 전송할 값 준비
        guard let userID = self.userId.text else {
            print("아이디 없음.")
            return
        }
        
        guard let name = self.nameTextField.text else {
            print("이름 없음.")
            return
        }
        
        let param = "userId=\(userID)&name=\(name)"
        
        let paramData = param.data(using: String.Encoding.utf8)
        
        // 2. URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        
        // 3. URLRequest 객체를 정의하고, 요청 내용 담기.
        guard let requestURL = url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // 4. HTTP 메시지 헤더 설정
        request.addValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )
        
        guard let paramDataCount = paramData?.count else {
            return
        }
        
        request.setValue(
            String(paramDataCount),
            forHTTPHeaderField: "Content-Length"
        )
        
        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 5-1. 서버가 응답이 없거나 통신이 실패했을 때
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            // 5-2. 응답 처리 로직이 이곳에 들어감.
            // ① 메인 스레드에서 비동기로 처리.
            DispatchQueue.main.async() {
                do {
                    guard let data = data else { return }
                    
                    let object = try JSONSerialization.jsonObject(with: data,
                                                                  options: []) as? NSDictionary
                    
                    guard let jsonObject = object else { return }
                    
                    // ② JSON 결과값 추출.
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    // ③ 결과가 성공일 때에만 텍스트 뷰에 출력.
                    guard let userID = userId else { return }
                    guard let userName = name else { return }
                    guard let results = result else { return }
                    guard let timeStamp = timestamp else { return }
                    
                    if result == "SUCCESS" {
                        self.responseTextView.text = "아이디 : \(userID)" + "\n"
                        + "이름 : \(userName)" + "\n"
                        + "응답결과 : \(results)" + "\n"
                        + "응답시간 : \(timeStamp)" + "\n"
                        + "요청방식 : x-www-form-urlencoded"
                        
                    }
                    
                } catch let e as NSError {
                    print("json object error message : \(e.localizedDescription)")
                }
            }
        }
        // 6. POST 전송.
        task.resume()
        print("동작")
    }
    
    private func setUpResponseTextView() {
        let guide = view.safeAreaLayoutGuide
        
        responseTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(responseTextView)
        
        NSLayoutConstraint.activate([
            responseTextView.topAnchor.constraint(equalTo: postButton.bottomAnchor, constant: 30),
            responseTextView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            responseTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            responseTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            responseTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30)
        ])
    }


}

