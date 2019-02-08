//
//  ViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/01/27.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var memoNumLabel: UILabel!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var dateField: UITextField!
    
    //タプルでメモリストを作成
    var memoList:[(title:String ,company:String, memoText:String, memoNum:String, memoDate:String)] = []
    var newList:[Memo] = []
    
    //前の画面から渡された選択したセルの行数目
    var index:Int!
    
//    保存用の変数(前の画面から渡された値)
    var titleStr: String?
    var memoText: String?
    var company: String?
    var memoNum: String?
    var memoDate: String?

    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //画面が呼ばれた時
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        memoTextView.delegate =  self
        companyField.delegate = self
        dateField.delegate = self
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: Selector(("doneBtn")))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    // UIDatePickerのDoneを押したら発火
    @objc func doneBtn() {
        dateField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日H時"
        
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        dateField.text = "\(formatter.string(from: datePicker.date))"
        
    }

    //入力ごとに文字数をカウントする
    func textViewDidChange(_ textView: UITextView) {
        let commentNum = memoTextView.text.count
        memoNumLabel.text = String(commentNum)
    }
    
    
    @IBAction func saveData(_ sender: Any) {
        
        // context(データベースを扱うのに必要)を定義。
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // memoにMemo(データベースのエンティティ)型オブジェクトを代入

        let memo = Memo(context: context)
        //Memo型データのtitle,company,memoText,memoNum,memoDateプロパティに入力、選択したデータを代入
        
        titleStr = titleField.text
        company = companyField.text
        memoText = memoTextView.text
        memoNum = memoNumLabel.text
        memoDate = dateField.text
        
        memo.title = titleStr
        memo.company = company
        memo.memoText = memoText
        memo.memoNum = memoNum
        memo.memoDate = memoDate
        
        self.newList.append(memo)
        // 上で作成したデータをデータベースに保存します。
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        dismiss(animated: true, completion: nil)
        
 
        self.navigationController?.popViewController(animated: true)
    
        func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func saveContext () {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

