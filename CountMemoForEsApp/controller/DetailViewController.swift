//
//  DetailViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/09.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    

    @IBOutlet var titleData: UILabel!
    @IBOutlet var companyData: UILabel!
    @IBOutlet var dateData: UILabel!
    @IBOutlet var numdata: UILabel!
    @IBOutlet var textData: UITextView!
    
    var detailData:Memo?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var titleStr: String?
    var company: String?
    var memoText: String = ""
    var memoNum: String?
    var memoDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //入力できないようにする
        textData.isEditable = false
        
        
        if let detailData:Memo = detailData {
            titleData.text = detailData.title
            companyData.text = detailData.company
            textData.text = detailData.memoText
            numdata.text = detailData.memoNum
            dateData.text = detailData.memoDate
        }
//        print(detailData)
    }
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "toEdit":
            // segueから遷移先のNavigationControllerを取得(画面遷移)
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! ViewController
            // contextをAddTaskViewController.swiftのcontextへ渡す
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            vc.context = context
            
/////////// 問題2の修正箇所 ////////////////
//            // 編集したいデータのtitleとcompanyとmemoTextとmemoNumとmemoDataを取得
//            let editedTitle = titleData.text
//            let editedCompany = companyData.text
//            let editedMemoText = textData.text
//            let editedMemoNum = numdata.text
//            let editedMemoData = dateData.text
//            // 先ほど取得した5つのデータに合致するデータのみをfetchするようにfetchRequestを作成
//
//            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "title = %@ and company = %@ and memoText = %@ and memoNum = %@ and memoDate = %@", editedTitle!, editedCompany!, editedMemoText!, editedMemoNum!, editedMemoData!)
//            // そのfetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たないはず）に代入し、それを渡す
//            do {
//                let memo = try context.fetch(fetchRequest)
//                vc.memo = memo[0]
//            } catch {
//                print("Fetching Failed.")
//            }
            vc.memo = self.detailData
/////////////////////////////////////////
            
        default:
            fatalError("Unknow segue: \(identifier)")
        }
    }
    
}
