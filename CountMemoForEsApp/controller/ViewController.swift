//
//  ViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/01/27.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    //それぞれUI部品を定義
    @IBOutlet var titleField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var memoNumLabel: UILabel!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var dateField: UITextField!
    
    //coreData（エンティティがMemo）
    var memo:Memo?
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    //MemoTableViewConrtollerから引き渡されたcontext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

/*
 画面が呼ばれる前
*/
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //デバッグ用
//        print(memo)
    }
    
    //テキストフィールド以外のところをタップするとキーボードが閉じる
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
/*
 画面が呼ばれた時
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        memoTextView.delegate =  self
        companyField.delegate = self
        dateField.delegate = self
        
        // メモがなければ新規作成
        if memo == nil {
//            //NSPersistentContainer内のNSManagedObjectContextを定数contextに代入
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
////            memo = Memo(context: context)
////            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            var memo = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context) as! Memo
////            saveContext()
/////////// 問題1の修正箇所 ////////////////
            // ここでMemoオブジェクトを作ってしまうと、「一時保存」しなくても空のオブジェクトが保存されてしまうことがある
            // memo = Memo(context: context)
/////////////////////////////////////////
        } else {
            //メモの値を表示。
            editedMemo(memo!)

        }
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.doneBtn))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        //キーボードを閉じる
        view.endEditing(true)
    }
/*
 ピッカーのdoneボタン
*/

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
    
    func editedMemo(_ memo:Memo){
        //編集用に表示
        titleField.text = memo.title
        companyField.text = memo.company
        memoTextView.text = memo.memoText
        memoNumLabel.text = memo.memoNum
        dateField.text = memo.memoDate
        
    }
    
    @IBAction func saveMemo(_ sender: Any) {
        //alertの設定
        let alert: UIAlertController = UIAlertController(title: "メモの登録", message: "この内容で保存しますか？", preferredStyle:  UIAlertController.Style.alert)

        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        

        // OKボタン押下時のイベント
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//
//            let editTitle = self.titleField.text
//            let editCompany = self.companyField.text
//            let editText = self.memoTextView.text
//            let editNum = self.memoNumLabel.text
//            let editDate = self.dateField.text
//
//
////            if let memo = self.memo{
//                // context(データベースを扱うのに必要)を定義。
//                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////               containerがAppDelegate.swiftに書かれているので、まずはappDelegateを定義
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                //フェッチリクエストのインスタンスを生成する。
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
//            let predicate = NSPredicate(format: "title = %@ and company = %@ and memoText = %@ and memoNum = %@ and memoDate = %@", editTitle!, editCompany!, editText!, editNum!, editDate!)
//                fetchRequest.predicate = predicate
//
//                do {
//                    //フェッチリクエストを実行する。
//                    let memo = try context.fetch(fetchRequest)
//                    //実行結果をローカルに保存したNSManagedObjectの配列memoDataに保存する
//                    var memoData:Memo = memo[0] as! Memo
//                    //
//                    memoData.title = self.titleField.text
//                    memoData.company = self.companyField.text
//                    memoData.memoText = self.memoTextView.text
//                    memoData.memoNum = self.memoNumLabel.text
//                    memoData.memoDate = self.dateField.text
//
//                } catch let error as NSError {
//                    print(error)
//                }
//
//            }

/////////// 問題1の修正箇所 ////////////////
//            if let memo = self.memo
//            {
//                memo.title = self.titleField.text
//                memo.company = self.companyField.text
//                memo.memoText = self.memoTextView.text
//                memo.memoNum = self.memoNumLabel.text
//                memo.memoDate = self.dateField.text
//            }
            // 編集の場合は詳細画面から渡されたself.memoを変更、
            // 新規の場合は新しいMemoオブジェクトを作り、現在の日時を入れる_
            let memo: Memo = {
                if let memo = self.memo {
                    return memo
                } else {
                    let memo = Memo(context: self.context)
                    memo.createdAt = Date()    /////////// 問題2の修正箇所(2) ////////////////
                    return memo
                }
            }()
            memo.title = self.titleField.text
            memo.company = self.companyField.text
            memo.memoText = self.memoTextView.text
            memo.memoNum = self.memoNumLabel.text
            memo.memoDate = self.dateField.text
/////////////////////////////////////////
            // 上で作成したデータをデータベースに保存
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            self.dismiss(animated: true, completion: nil)

            //入力値をクリアにする
            self.clearData()
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        alert.dismiss(animated: true, completion: nil)

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    // 入力値をクリア
    func clearData()  {
        titleField.text = ""
        companyField.text = ""
        memoTextView.text = ""
        memoNumLabel.text = "0"
        dateField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    //データを保存
    func saveContext () {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print(context)
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
