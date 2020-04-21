//
//  TitleListViewController.swift
//  FavoriteURLList
//
//  Created by 寺山和也 on 2020/04/10.
//  Copyright © 2020 寺山和也. All rights reserved.
//

import UIKit

//UITableViewDAtaSource, UITableViewDelegateのプロトコルを実装
class TitleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //タイトルを格納した配列
    var titleList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 保存しているURLの読み込み処理
        let userdefaults = UserDefaults.standard
        if let storedURLList = userdefaults.array(forKey: "titleList")as? [String]{
            titleList.append(contentsOf: storedURLList)
        }
        
        /* ここから引用
         * https://qiita.com/nasteng/items/895b594155f1a6cce94e
         **/
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //instance生成
        let Title1 = appDelegate.entityForInsert("Title") as! Title
        Title1.titleName = "テスト 太郎"
        Title1.title = 
        //CoreDataに登録
        appDelegate.saveContext()
    }
    
    //+ボタンをタップした時に呼ばれる処理
    @IBAction func tapAddButton(_ sender: Any) {
        //アラートダイアログを生成
        let alertContoller = UIAlertController(title: "タイトルの追加", message: "URLをまとめるタイトルを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        //テキストエリアの追加
        alertContoller.addTextField(configurationHandler: nil)
        //OKボタンを追加
        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            //OKボタンが押されたときの処理
            if let textField = alertContoller.textFields?.first{
                //titleリストの配列に入力値を挿入。先頭に挿入する。
                self.titleList.insert(textField.text!, at: 0)
                //テーブルに行が追加されたことをテーブルに通知(右からセルを追加)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                // titleの保存処理
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.titleList, forKey: "titleList")
                userDefaults.synchronize()
            }
        }
        
        //OKボタンがタップされたときの処理
        alertContoller.addAction(okAction)
        //CANCELボタンがタップされた時の処理
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        //CANCELボタンを追加
        alertContoller.addAction(cancelButton)
        //アラートダイアログを表示
        present(alertContoller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //titleListの配列の長さを返却
        return titleList.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardで指定したtitleCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        let titleListTitle = titleList[indexPath.row]
        //セルのラベルにURLのタイトルをセット
        cell.textLabel?.text=titleListTitle
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除(セル選択解除がないとApple審査に落ちる)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルを削除した時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle==UITableViewCell.EditingStyle.delete{
            //titleリストから削除
            titleList.remove(at: indexPath.row)
            //セルの削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //データの保存。Data型にシリアライズ
            do{
                let data:Data=try NSKeyedArchiver.archivedData(withRootObject: titleList, requiringSecureCoding: true)
                //UserDefaultsに保存
                let userDefaults=UserDefaults.standard
                userDefaults.set(data, forKey: "titleList")
                userDefaults.synchronize()
            }catch{
                //error処理なし
            }
        }
    }
}
