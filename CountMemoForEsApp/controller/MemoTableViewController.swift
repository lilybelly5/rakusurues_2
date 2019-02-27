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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        // tableViewにカスタムセルを登録
//        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //編集中のセル選択を許可
        tableView.allowsSelectionDuringEditing = true
        self.tableView.rowHeight = 60
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
            fetchRequest.returnsObjectsAsFaults = false
//            並び順を作成順に指定
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true)
            ]
            memoData = try context.fetch(fetchRequest) as! [Memo]
            
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTitleTableViewCell", for: indexPath)
//        cell.textLabel?.text = self.memoData[indexPath.row].title
//        cell.detailTextLabel?.text = self.memoData[indexPath.row].memoNum
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell

        cell.titleLabel.text = self.memoData[indexPath.row].title
        cell.numLabel.text = self.memoData[indexPath.row].memoNum
        cell.companyLabel.text = self.memoData[indexPath.row].company
//
//
//        cell.cellDisplay(indexNum: indexPath)
        
        return cell
    }
    
    //セルの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

         if editingStyle == .delete {
            // 削除したいデータのcategoryとnameを取得
            let deletedMemoData = memoData[indexPath.row]

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
            // contextをAddTaskViewController.swiftのcontextへ渡す
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            vc.context = context
 
            //indexPathがnilでないことを確認し、選択した行のデータを引きわたす
            
            if let indexPath = indexPath{
                vc.detailData = self.memoData[indexPath.row]
            }


        default:
            fatalError("Unknow segue: \(identifier)")
        }
     }
    
}

