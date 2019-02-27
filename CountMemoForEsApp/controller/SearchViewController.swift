//
//  SearchViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/10.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var searchData:[Memo] = []
    
    @IBOutlet var resultTableView: UITableView!
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //配列が追加した後もういちどデータをリロードさせる
        resultTableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // TableViewの処理をselfに任せる
        resultTableView.dataSource = self
        resultTableView.delegate   = self
        resultTableView.rowHeight = 60
        
        
    }
    //    セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //何行か
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchData.count
    }
    //セルの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)as! SearchTableViewCell
        cell.titleLabel?.text = self.searchData[indexPath.row].title
        cell.companyLabel?.text = self.searchData[indexPath.row].company
        cell.numLabel?.text = self.searchData[indexPath.row].memoNum

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "searchToDetail", sender: nil)
    }
 

    //画面遷移で値を引き渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "searchToDetail":
            //渡したい値を設定する
            let indexPath = resultTableView.indexPathForSelectedRow
            // segueから遷移先のNavigationControllerを取得(画面遷移)
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! DetailViewController
            
            // contextをAddTaskViewController.swiftのcontextへ渡す
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            vc.context = context
            
            // 編集したいデータのtitleとcompanyとmemoTextとmemoNumとmemoDataを取得
            let editedTitle = searchData[(indexPath!.row)].title
            let editedCompany = searchData[(indexPath!.row)].company
            let editedMemoText = searchData[(indexPath!.row)].memoText
            let editedMemoNum = searchData[(indexPath!.row)].memoNum
            let editedMemoData = searchData[(indexPath!.row)].memoDate
            
            // 先ほど取得した5つのデータに合致するデータのみをfetchするようにfetchRequestを作成
            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title = %@ and company = %@ and memoText = %@ and memoNum = %@ and memoDate = %@", editedTitle!, editedCompany!, editedMemoText!, editedMemoNum!, editedMemoData!)
            // そのfetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たないはず）に代入し、それを渡す
            do {
                let memo = try context.fetch(fetchRequest)
                vc.detailData = memo[0]
            } catch {
                print("Fetching Failed.")
            }
        default:
            fatalError("Unknow segue: \(identifier)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        
        //検索結果配列を空にする。
        searchData.removeAll()

        if(searchText != ""){
            // AppDelegateクラスのインスタンスを取得
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            //%@はstring型を表す
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
            //複数条件かつ部分一致でじ検索
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or
                , subpredicates: [
                    NSPredicate(format: "%K CONTAINS %@","company", "\(searchText)"),
                    NSPredicate(format: "%K CONTAINS %@", "title","\(searchText)"),
                    ])
            fetchRequest.predicate = predicate
            
            let fetchData = try! context.fetch(fetchRequest)

            if(!fetchData.isEmpty){
                for i in 0..<fetchData.count{
                    searchData.append(fetchData[i] as! Memo)
                }
                do{
                    try context.save()
                }catch{
                    print(error)
                }
            }
        }
        resultTableView.reloadData()
    }
    
}

