//
//  ViewController.swift
//  FavoriteURLList
//
//  Created by 寺山和也 on 2020/04/05.
//  Copyright © 2020 寺山和也. All rights reserved.
//

import UIKit

//UITableViewDAtaSource, UITableViewDelegateのプロトコルを実装
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //URLを格納した配列
    var URLList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 保存しているURLの読み込み処理
        let userdefaults = UserDefaults.standard
        if let storedURLList = userdefaults.array(forKey: "URLList")as? [String]{
            URLList.append(contentsOf: storedURLList)
        }
    }

    //+ボタンをタップした時に呼ばれる処理
    @IBAction func tapAddButton(_ sender: Any) {
        //アラートダイアログを生成
        let alertContoller = UIAlertController(title: "URLリストの追加", message: "URLを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        //テキストエリアの追加
        alertContoller.addTextField(configurationHandler: nil)
        //OKボタンを追加
        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            //OKボタンが押されたときの処理
            if let textField = alertContoller.textFields?.first{
                //URLリストの配列に入力値を挿入。先頭に挿入する。
                self.URLList.insert(textField.text!, at: 0)
                //テーブルに行が追加されたことをテーブルに通知(右からセルを追加)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                // URLの保存処理
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.URLList, forKey: "URLList")
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
        //URLListの配列の長さを返却
        return URLList.count
    }
    
    //テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath)
        let URLTitle = URLList[indexPath.row]
        //セルのラベルにURLのタイトルをセット
        cell.textLabel?.text=URLTitle
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除(セル選択解除がないとApple審査に落ちる)
        tableView.deselectRow(at: indexPath, animated: true)
        
        //セルに記載されているURLを起動する。
        let urlStr=URLList[indexPath.row]
        let url = URL(string: urlStr)
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルを削除した時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle==UITableViewCell.EditingStyle.delete{
            //URLリストから削除
            URLList.remove(at: indexPath.row)
            //セルの削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //データの保存。Data型にシリアライズ
            do{
                let data:Data=try NSKeyedArchiver.archivedData(withRootObject: URLList, requiringSecureCoding: true)
                //UserDefaultsに保存
                let userDefaults=UserDefaults.standard
                userDefaults.set(data, forKey: "URLList")
                userDefaults.synchronize()
            }catch{
                //error処理なし
            }
        }
    }
    
}

