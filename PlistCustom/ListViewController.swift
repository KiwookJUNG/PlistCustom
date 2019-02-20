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
    
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex // 0이면 남자, 1이면 여자
        
        let plist = UserDefaults.standard // 기본 저장소 객체를 가져온다.
        plist.set(value, forKey: "gender") // "gender" 라는 키로 값을 저장한다.
        plist.synchronize() // 동기화 처리
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn // true면 기혼, false면 미혼
        
        let plist = UserDefaults.standard // 기본 저장소 객체를 가져온다.
        plist.set(value, forKey: "married")
        plist.synchronize()
    }
    
    
    
    var accountList = [String]()
    
    override func viewDidLoad() {
        let picker = UIPickerView() // 피커 뷰 인스턴스 생성
        
        // 피커 뷰의 델리게이트 객체 지정
        picker.delegate = self
        
        // account 텍스트 필드 입력 방식을 가상 키보드 대신 피커 뷰로 설정
        self.account.inputView = picker
        
        // 툴 바 객체 정의 ( 피커가 악세사리 뷰 영역에 Done버튼을 추가하기 위해 )
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = UIColor.lightGray
        
        // 액세서리 뷰 영역에 툴 바를 표시
        self.account.inputAccessoryView = toolbar
        
        // 툴 바에 들어갈 닫기 버튼
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        
        // 새로운 계정을 추가 할 수 있는 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        // 가변 폭 버튼으로 만들기
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        
        
        // 버튼을 툴 바에 추가
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        // 기본 저장소 객체 불러오기
        let plist = UserDefaults.standard
        
        // 불러온 값을 설정
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        // "accountList"키로 저장도니 값을 읽어온다. 저장된 값이 없을 경우 새로운 배열객체를 생성
        let accountList = plist.array(forKey: "accountList") as? [String] ?? [String]()
        // 읽어온 값을 멤버 변수 self.accountList에 대입해준다( 이메일 저장소 )
        self.accountList = accountList
        
        // "selectedAccount" 키로 저장된 값을 읽어온다.
        if let account = plist.string(forKey: "selectedAccount"){
            self.account.text = account // 값이 있을 경우 account 텍스트 필드의 값으로 대입한다.
        }
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
        // self.view.endEditing(true)
        
        // 사용자가 계정을 생헝하면 이 계정을 선택한 것으로 간주하고 저장
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    @objc func pickerDone(_ sender: Any){
        self.view.endEditing(true)
    }
    
    @objc func newAccount(_ sender: Any){
        // 일단 열려있는 피커를 닫아준다.
        self.view.endEditing(true)
        
        // 알림창 객체 생성
        let alert = UIAlertController(title: "새 계정을 입력하세요.", message: nil, preferredStyle: .alert)
        
        // 입력폼 추가
        alert.addTextField() {
            $0.placeholder = "ex) abc@gmail.com"
        }
        
        //버튼 및 액션 정의
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let account = alert.textFields?[0].text {
                // 계정 목록 배열에 추가한다.
                self.accountList.append(account)
                // 계정 텍스트 필드에 표시한다.
                self.account.text = account
                
                // 컨트롤 값을 모두 초기화한다.
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                // 계정 목록을 통쩨로 자징한다.
                let plist = UserDefaults.standard
                
                plist.set(self.accountList, forKey: "accountList")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
            }
        }))
        // 알림창 오픈
        self.present(alert, animated: false, completion: nil)
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { //두번째 셀이 클릭 되었을 떄에만
            // 입력이 가능한 알림창을 띄워 이름을 수정 할 수 있도록 한다.
            
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            
            // 입력 필드 추가
            alert.addTextField () {
                $0.text = self.name.text // name 레이블의 텍스트를 입력폼에 기본값으로 넣어준다.
            }
            
            // 버튼 및 액션 추가
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                //사용자가 OK 버튼을 누르면 입력 필드에 입력된 값을 저장한다.
                let value = alert.textFields?[0].text
                
//                let plist = UserDefaults.standard // 기본 저장소를 가져온다.
//                plist.setValue(value, forKey: "name") // "name"이라는 키로 값을 저장한다.
//                plist.synchronize() // 동기화 처리
                // UserDefaults 가 아닌 커스텀 프로퍼티 리스트로 대체하는 새로운 저장로직을 추가한다.
                // 저장 로직 시작
                
                let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                
                self.name.text = value
                
                // 알림창을 띄움
            }))
            
            self.present(alert, animated: false, completion: nil)

        }
    }
}
