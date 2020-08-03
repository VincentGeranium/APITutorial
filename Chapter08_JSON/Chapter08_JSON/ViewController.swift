//
//  ViewController.swift
//  Chapter08_JSON
//
//  Created by 김광준 on 2020/08/03.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let userId: UITextField = {
        let userIdTextField: UITextField = UITextField()
        userIdTextField.textAlignment = NSTextAlignment.left
        userIdTextField.sizeToFit()
        userIdTextField.placeholder = "User ID"
        userIdTextField.layer.borderWidth = 1.0
        userIdTextField.layer.cornerRadius = 8.0
        userIdTextField.layer.borderColor = UIColor.systemGray.cgColor
        return userIdTextField
    }()
    
    private let userName: UITextField = {
        let userNameTextField: UITextField = UITextField()
        userNameTextField.textAlignment = NSTextAlignment.left
        userNameTextField.sizeToFit()
        userNameTextField.placeholder = "Name"
        userNameTextField.layer.borderWidth = 1.0
        userNameTextField.layer.cornerRadius = 8.0
        userNameTextField.layer.borderColor = UIColor.systemGray.cgColor
        return userNameTextField
    }()
    
    private let jsonButton: UIButton = {
        let jsonButton: UIButton = UIButton()
        jsonButton.setTitle("JSON", for: UIControl.State.normal)
        jsonButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        jsonButton.backgroundColor = UIColor.systemPink
        jsonButton.layer.cornerRadius = 8.0
        return jsonButton
    }()
    
    private let resultTextView: UITextView = {
        let reusltTextView: UITextView = UITextView()
        reusltTextView.layer.borderWidth = 1.0
        reusltTextView.layer.borderColor = UIColor.black.cgColor
        return reusltTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setUpUserId()
        setUpUserName()
        setUpJsonButton()
        setUpResultTextView()
    }
    
    private func setUpUserId() {
        let guide = self.view.safeAreaLayoutGuide
        
        userId.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userId)
        
        NSLayoutConstraint.activate([
            userId.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            userId.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            userId.widthAnchor.constraint(equalToConstant: 300),
            userId.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setUpUserName() {
        let guide = self.view.safeAreaLayoutGuide
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(userName)
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: userId.bottomAnchor, constant: 20),
            userName.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            userName.widthAnchor.constraint(equalTo: userId.widthAnchor),
            userName.heightAnchor.constraint(equalTo: userId.heightAnchor),
        ])
    }
    
    private func setUpJsonButton() {
        let guide = self.view.safeAreaLayoutGuide
        
        jsonButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(jsonButton)
        
        NSLayoutConstraint.activate([
            jsonButton.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 30),
            jsonButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            jsonButton.widthAnchor.constraint(equalToConstant: 150),
            jsonButton.heightAnchor.constraint(equalTo: userId.heightAnchor),
        ])
        
        jsonButton.addTarget(self, action: #selector(jsonButtonAction(_:)), for: .touchUpInside)
        
    }
    
    @objc private func jsonButtonAction(_ sender: UIButton) {
        // 1. 전송할 값 준비.
        guard let userId = userId.text else { return }
        guard let name = userName.text else { return }
        let param = ["userId" : userId, "name" : name] // JSON 객체로 변환할 딕셔너리 준비
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        // 2. URL 객체 정의.
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")
        
        // 3. URLRequest 객체 정의 및 요청 내용 담기.
        guard let urlRequest = url else { return }
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // 4. HTTP 메시지에 포함될 헤더 설정.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Lenght")
        
        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성.
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 5-1. 서버가 응답이 없거나 통신이 실패했을 때.
            if let error = error {
                NSLog("An error has occurred : \(error.localizedDescription)")
                return
            }
            // 5-2. 응답 처리 로직
            // ① 메인 스레드에서 비동기로 처리되도록 한다.
            DispatchQueue.main.async {
                do {
                    guard let data = data else { return }
                    let objcet = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    
                    guard let jsonObjcet = objcet else { return }
                    
                    // ② JSON 결과값을 추출.
                    let result = jsonObjcet["result"] as? String
                    let timeStamp = jsonObjcet["timestamp"] as? String
                    let userId = jsonObjcet["userId"] as? String
                    let name = jsonObjcet["name"] as? String
                    
                    // ③ 결과가 성곡일 경우에만 텍스트 뷰에 출력한다.
                    if result == "SUCCESS" {
                        guard let uesrID = userId else { return }
                        guard let name = name else { return }
                        guard let result = result else { return }
                        guard let timeStamp = timeStamp else { return }
                        
                        self.resultTextView.text = "아이디 : \(uesrID)" + "\n"
                            + "이름 : \(name)" + "\n"
                            + "응답결과 : \(result)" + "\n"
                            + "응답시간 : \(timeStamp)" + "\n"
                            + "요청방식 : application/json"
                    }
                    print("Response Data=\(String(data: data, encoding: String.Encoding.utf8)!)")
                } catch let error as NSError {
                    print("An error has occurred while parsing JSONObject : \(error.localizedDescription)")
                }
            }
        }
        // 6. POST 전송
        task.resume()
        
    }
    
    private func setUpResultTextView() {
        let guide = self.view.safeAreaLayoutGuide
        
        resultTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(resultTextView)
        
        NSLayoutConstraint.activate([
            resultTextView.topAnchor.constraint(equalTo: jsonButton.bottomAnchor, constant: 50),
            resultTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            resultTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -50),
        ])
    }


}

