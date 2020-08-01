//
//  ViewController.swift
//  Chapter08_GET
//
//  Created by 김광준 on 2020/08/01.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let serverTimeCheckButton: UIButton = {
        let timeCheckBtn: UIButton = UIButton()
        timeCheckBtn.backgroundColor = .systemBlue
        timeCheckBtn.setTitle("서버 시간 확인 버튼", for: .normal)
        timeCheckBtn.titleLabel?.sizeToFit()
        timeCheckBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        timeCheckBtn.titleLabel?.textColor = UIColor.white
        
        return timeCheckBtn
    }()
    
    private let currentTimeLabel: UILabel = {
        var currentTimeLbl: UILabel = UILabel()
        currentTimeLbl.backgroundColor = UIColor.black
        currentTimeLbl.textColor = UIColor.white
        currentTimeLbl.font = UIFont.boldSystemFont(ofSize: 20)
        currentTimeLbl.textAlignment = .center
        currentTimeLbl.text = "현재 시간"
        
        return currentTimeLbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        
        setUpServerTimeCheckButton()
        setUpCurrentTimeLabel()
    }
    
    private func setUpServerTimeCheckButton() {
        let guide = self.view.safeAreaLayoutGuide
        
        serverTimeCheckButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(serverTimeCheckButton)
        
        NSLayoutConstraint.activate([
            serverTimeCheckButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30),
            serverTimeCheckButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            serverTimeCheckButton.widthAnchor.constraint(equalToConstant: 200),
            serverTimeCheckButton.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        serverTimeCheckButton.addTarget(self, action: #selector(serverTimeCheckButtonAction), for: .touchUpInside)
    }
    
    private func setUpCurrentTimeLabel() {
        let guide = self.view.safeAreaLayoutGuide
        
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(currentTimeLabel)
        
        NSLayoutConstraint.activate([
            currentTimeLabel.topAnchor.constraint(equalTo: serverTimeCheckButton.bottomAnchor, constant: 30),
            currentTimeLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 300),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func serverTimeCheckButtonAction(_ sender: UIButton) {
        do {
            // 1. URL 설정 및 GET 방식으로 API 호출
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            guard let currentTimeURL = url else {
                return
            }
            let response = try String(contentsOf: currentTimeURL)
            
            // 2. 읽어온 값을 레이블에 표시하기.
            self.currentTimeLabel.text = response
            self.currentTimeLabel.sizeToFit()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }


}

