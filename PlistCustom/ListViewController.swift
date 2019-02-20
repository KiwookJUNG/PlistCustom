//
//  ListViewController.swift
//  PlistCustom
//
//  Created by 정기욱 on 20/02/2019.
//  Copyright © 2019 Kiwook. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var account: UITextField!
    
    var accountList = ["rldnr56@me.com",
                       "www@naver.com",
                       "cat@love.com",
                       "nunu@love.com",
                       "lui@love.com"]
    
    override func viewDidLoad() {
        let picker = UIPickerView() // 피커 뷰 인스턴스 생성
        
        // 피커 뷰의 델리게이트 객체 지정
        picker.delegate = self
        
        // account 텍스트 필드 입력 방식을 가상 키보드 대신 피커 뷰로 설정
        self.account.inputView = picker
        
    }
    
    // 생성할 컴포넌트의 개수를 정의합니다. (보통은 1개지만 3개 이하까지는 할 수 있다. )
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 지정된 컴포넌트가 가질 목록의 길이를 정의합니다.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count

    }
    
    // 지정된 컴포넌트의 목록 각 행에 출력될 내용을 정의합니다.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.accountList[row] // 컴포넌트 내의 목록에 출력될 내용을 지정하는 역할
    }
    
    // 지정된 컴포넌트의 목록 각 행을 사용자가 선택했을 때 액션을 정의합니다.
    // 이 메소드는 피커 뷰에서 값이 선택되었을 때 실행할 액션을 정의하는 역할
    // 1. 선택된 값을 택스트 필드에 표시하고
    // 2. 입력 뷰를 닫아줘야한다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 1. 선택된 계정값을 텍스트 필드에 입력
        let account = self.accountList[row] // 선택된 계정
        self.account.text = account
        
        // 2. 입력 뷰를 닫음
        self.view.endEditing(true)
    }
}
