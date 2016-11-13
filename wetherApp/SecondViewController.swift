//
//  SecondViewController.swift
//  wetherApp
//
//  Created by ISSHIN on 11/11/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//

import UIKit
import CoreLocation
import CoreImage

class SecondViewController: UIViewController,CLLocationManagerDelegate,UINavigationControllerDelegate {

    var myLocationManager: CLLocationManager!
    
    
    // ベース画像.
    let myInputImage = CIImage(image: UIImage(named: "wallpaper.jpg")!)
    
    // 緯度表示用のラベル.
    var myLatitudeLabel: UILabel!
    
    // 経度表示用のラベル.
    var myLongitudeLabel: UILabel!
    
    // UIView
    var myImageView: UIImageView!
    
    override func viewDidLoad() {
        
        // UIImageに変換.
        let myInputUIImage: UIImage = UIImage(ciImage: myInputImage!)
        
        // ImageView.
        myImageView = UIImageView(frame: CGRect(x: 30, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        // UIImageViewの生成.
        myImageView.image = myInputUIImage
        self.view.addSubview(myImageView)
        
        
        // CIFilterを生成。nameにどんなを処理するのか記入.
        let myBlurFilter = CIFilter(name: "CIGaussianBlur")
        
        // ばかし処理をいれたい画像をセット.
        myBlurFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
        
        // フィルターを通した画像をアウトプット.
        let myOutputImage : CIImage = myBlurFilter!.outputImage!
        
        // UIImageに変換.
        let myOutputUIImage: UIImage = UIImage(ciImage: myOutputImage)
        
        // 画像の中心をスクリーンの中心位置に設定
        //myImageView.image = CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height/2)
        
        // 再びUIViewにセット.
        myImageView.image = myOutputUIImage
        
        // 再描画.
        myImageView.setNeedsDisplay()
        
        self.title = "My Second View"
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // Labelを作成.
        let Locationlabel: UILabel = UILabel(frame: CGRect(x: 90, y: 100, width: bWidth, height: bHeight))
        // Labelに文字を追加
        Locationlabel.text = "hello,world"
        //
        // Textを中央寄せにする.
        Locationlabel.textAlignment = NSTextAlignment.center
        //viewに追加
        self.view.addSubview(Locationlabel)
        // Do any additional setup after loading the view.
        
        // 緯度表示用のラベルを生成.
        myLatitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLatitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+100)
        
        // 軽度表示用のラベルを生成.
        myLongitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLongitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+130)
        
        // まだ承認が得られていない場合は、認証ダイアログを表示.
        //myLocationManager.requestWhenInUseAuthorization()
        
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status.rawValue)");
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
        if(status == .notDetermined) {
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        // 現在位置の取得を開始.
        myLocationManager.startUpdatingLocation()
    }
    
    //認証に変化があった際に呼ばれる
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr: String = "";
        switch (status) {
        case .notDetermined:
            statusStr = "未認証の状態"
        case .restricted:
            statusStr = "制限された状態"
        case .denied:
            statusStr = "許可しない"
        case .authorizedAlways:
            statusStr = "常に使用を許可"
        case .authorizedWhenInUse:
            statusStr = "このAppの使用中のみ許可"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // 緯度・経度の表示.
        print(manager.location!.coordinate.latitude)
        //myLatitudeLabel.text = "hoge"
        myLatitudeLabel.text = "緯度：\(manager.location!.coordinate.latitude)"
        myLatitudeLabel.textAlignment = .center
        print(manager.location!.coordinate.longitude)
        //myLongitudeLabel.text = "hoge"
        myLongitudeLabel.text = "経度：\(manager.location!.coordinate.longitude)"
        myLongitudeLabel.textAlignment = .center
        
        
        self.view.addSubview(myLatitudeLabel)
        self.view.addSubview(myLongitudeLabel)
        
    }
    
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
        print(error)
    }
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


