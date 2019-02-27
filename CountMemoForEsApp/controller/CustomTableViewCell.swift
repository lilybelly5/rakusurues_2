//
//  CustomTableViewCell.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/26.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var numLabel: UILabel!
    
    var memoData:[Memo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        do {
            // データ保存時と同様にcontextを定義
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
            fetchRequest.returnsObjectsAsFaults = false
            //            並び順を作成順に指定
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true)
            ]
            memoData = try context.fetch(fetchRequest) as! [Memo]
            
            // 先ほどfetchしたデータをtasksToShow配列に格納する
            //            for memo in memoData {
            //                memoToShow[memo.title!]!.append(memo.title!)
            //            }
            return
        } catch {
            print("Fetching Failed.")
        }
    }
    
    func cellDisplay(indexNum:IndexPath){
        self.titleLabel?.text = memoData[indexNum.row].title
        self.companyLabel?.text = memoData[indexNum.row].company
        self.numLabel?.text = memoData[indexNum.row].memoNum
 
    }
    
}
