//
//  ViewController.swift
//  wetherApp
//
//  Created by ISSHIN on 11/11/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //let mySecondViewController = ""
    var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ボタンの生成.
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 100
        let posX: CGFloat = (self.view.bounds.width - buttonWidth)/2
        let posY: CGFloat = (self.view.bounds.height - buttonWidth)/2
        myButton = UIButton(frame: CGRect(x: posX, y: posY, width: buttonWidth, height: buttonHeight))
        myButton.backgroundColor = UIColor.orange
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 50.0
        myButton.setTitle("Get", for: .normal)
        //myButton.addTarget(self, action: #selector(ViewController.onClickMyButton(sender:)), for: .touchDown)
        // TouchDownの時のイベントを追加する.
        myButton.addTarget(self, action: #selector(ViewController.onDownButton(sender:)), for: .touchDown)
        
        // TouchUpの時のイベントを追加する.
        myButton.addTarget(self, action: #selector(ViewController.onUpButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(myButton);
    }
    
    
    // ボタンイベント(Down)
    func onDownButton(sender: UIButton){
        //UIView.animateWithDuration
        //withDuration:秒数
        //animations:アニメーションの処理
        //completion:アニメーション後の処理
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        )
    }
    
    //ボタンイベント(Up)
    func onUpButton(sender: UIButton){
        UIView.animate(withDuration: 0.1,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 拡大用アフィン行列を作成する.
                self.myButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                self.myButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        },
            completion:{
                finished in
                // 遷移するViewを定義する.
                let mySecondViewController: UIViewController = SecondViewController()
                // アニメーションを設定する.
                //mySecondViewController.modalTransitionStyle = .partialCurl
                // Viewの移動する.
                self.navigationController?.pushViewController(mySecondViewController, animated: true)
                }
            
        )
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

