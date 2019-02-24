//
//  MemoTableViewController.swift
//  CountMemoForEsApp
//
//

import UIKit
import CoreData


class MemoTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    //配列作成(coreData) for tableView
    var memoData:[Memo] = []
    var memoToShow:[String:[String]] = ["":[]]
    var memoCategory:[String] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //編集中のセル選択を許可
        tableView.allowsSelectionDuringEditing = true
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        //配列が追加した後もういちどデータをリロードさせる
        tableView.reloadData()
        
    }
    
    func getData() {
        // データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
//            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
            fetchRequest.returnsObjectsAsFaults = false
/////////// 問題2の修正箇所(2) ////////////////
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true)
            ]
/////////////////////////////////////////
            memoData = try context.fetch(fetchRequest) as! [Memo]
            // tasksToShow配列を空にする。（同じデータを複数表示しないため）
            for key in memoToShow.keys {
                memoToShow[key] = []
                
            }
            // 先ほどfetchしたデータをtasksToShow配列に格納する
//            for memo in memoData {
//                memoToShow[memo.title!]!.append(memo.title!)
//            }
            return
        } catch {
            print("Fetching Failed.")
        }
    }
    

    //セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //何行か
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoData.count
    }
    
    //セルの作成　rowは何行目か
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTitleTableViewCell", for: indexPath)
        cell.textLabel?.text = self.memoData[indexPath.row].title
        cell.detailTextLabel?.text = self.memoData[indexPath.row].memoNum
        
        return cell
    }
    
    //セルの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

         if editingStyle == .delete {
    //        特定の行をremoveで消す
//            memoData.remove(at: indexPath.row)
            // 削除したいデータのみをfetchする
            // 削除したいデータのcategoryとnameを取得
            let deletedMemoData = memoData[indexPath.row]
            // そのfetchRequestを満たすデータをfetchしてtask（配列だが要素を1種類しか持たない）に代入し、削除する
            do {
                context.delete(deletedMemoData)
                memoData.remove(at: indexPath.row)
            } catch {
                print("Fetching Failed.")
            }
            
            // 削除したあとのデータを保存する
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // 削除後の全データをfetchする
            getData()
        }
        // taskTableViewを再読み込みする
        tableView.reloadData()
    }
    
 //セルを選択した時に実行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
//編集
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }

//画面遷移で値を引き渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showDetail":
            //渡したい値を設定する
            let indexPath = tableView.indexPathForSelectedRow
            // segueから遷移先のNavigationControllerを取得(画面遷移)
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! DetailViewController
//
//             vc.titleStr = self.memoData[(indexPath!.row)].title!
//             vc.company = self.memoData[(indexPath?.row)!].company!
//             vc.memoText = self.memoData[(indexPath?.row)!].memoText!
//             vc.memoNum = self.memoData[(indexPath?.row)!].memoNum!
//             vc.memoDate = self.memoData[(indexPath?.row)!].memoDate!
            
            // contextをAddTaskViewController.swiftのcontextへ渡す
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            vc.context = context
            
/////////// 問題2の修正箇所 ////////////////
//            // 編集したいデータのtitleとcompanyとmemoTextとmemoNumとmemoDataを取得
//            let editedTitle = memoData[(indexPath!.row)].title
//            let editedCompany = memoData[(indexPath!.row)].company
//            let editedMemoText = memoData[(indexPath!.row)].memoText
//            let editedMemoNum = memoData[(indexPath!.row)].memoNum
//            let editedMemoData = memoData[(indexPath!.row)].memoDate
//
//            // 先ほど取得した5つのデータに合致するデータのみをfetchするようにfetchRequestを作成
//            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "title = %@ and company = %@ and memoText = %@ and memoNum = %@ and memoDate = %@", editedTitle!, editedCompany!, editedMemoText!, editedMemoNum!, editedMemoData!)
//            // そのfetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たないはず）に代入し、それを渡す
//            do {
//                let memo = try context.fetch(fetchRequest)
//                vc.detailData = memo[0]
//            } catch {
//                print("Fetching Failed.")
//            }
            // 本来であれば、強制アンラップ(!)を使うべきではありません(説明をシンプルにするため、やむなく使っています)。
            // guard構文などを使って、indexPathがnilでないことを確認しましょう。
            vc.detailData = self.memoData[indexPath!.row]
/////////////////////////////////////////

        default:
            fatalError("Unknow segue: \(identifier)")
        }
     }
    
}

