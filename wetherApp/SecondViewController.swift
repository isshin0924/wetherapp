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
    
    // UIView系
    //天気に画像の設定
    var WeatherImage: UIImageView!
    
    //場所表示用のラベル
    var locationLavel:UILabel!
    
    let bWidth: CGFloat = 200
    let bHeight: CGFloat = 50
    
    
    
    override func viewDidLoad() {
        
        
        // アニメーション用の画像
        let image1 = UIImage(named:"para1")!
        let image2 = UIImage(named:"para2")!
        let image3 = UIImage(named:"para3")!
        let image4 = UIImage(named:"para4")!
        
        // UIImage の配列を作る
        var imageListArray :Array<UIImage> = []
        // UIImage 各要素を追加、ちょっと冗長的ですが...
        imageListArray.append(image1)
        imageListArray.append(image2)
        imageListArray.append(image3)
        imageListArray.append(image4)
        
        // 画像サイズ、元画像が少し小さいのでx2にしました
        let rect = CGRect(x:0, y:0, width:image1.size.width, height:image1.size.height)
        
        // UIImageView のインスタンス生成,ダミーでimage1を指定
        let imageView:UIImageView = UIImageView(image:image1)
        imageView.frame = rect
        
        // 画像が画面中央にくるように位置合わせ
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
        imageView.center = CGPoint(x:100, y:600)
        // view に追加する
        self.view.addSubview(imageView)
        
        // 画像の配列をアニメーションにセット
        imageView.animationImages = imageListArray
        
        // 1.5秒間隔
        imageView.animationDuration = 1.5
        // 3回繰り返し
        imageView.animationRepeatCount = 0
        // アニメーションを開始
        imageView.startAnimating()
        
        // アニメーションを終了
        //imageView.stopAnimating()
        
        // UIImageViewのx,yを設定する
        let posX: CGFloat = (self.view.bounds.width - bWidth)/2
        let posY: CGFloat = (self.view.bounds.height - bHeight)/2
        
        // UIImageViewを作成.
        WeatherImage = UIImageView(frame: CGRect(x: 20, y: self.view.bounds.width/2-50, width: 100, height: 100))
        
        //背景画像の設定
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "wallpaper.jpg")?.draw(in: self.view.bounds)
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
//        // UIImageに変換.
//        let myInputUIImage: UIImage = UIImage(ciImage: myInputImage!)
//        
//        // ImageView.
//        myImageView = UIImageView(frame: CGRect(x: 30, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        
//        // UIImageViewの生成.
//        myImageView.image = myInputUIImage
//        self.view.addSubview(myImageView)
//        
//        
//        // CIFilterを生成。nameにどんなを処理するのか記入.
//        let myBlurFilter = CIFilter(name: "CIGaussianBlur")
//        
//        // ばかし処理をいれたい画像をセット.
//        myBlurFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
//        
//        // フィルターを通した画像をアウトプット.
//        let myOutputImage : CIImage = myBlurFilter!.outputImage!
//        
//        // UIImageに変換.
//        let myOutputUIImage: UIImage = UIImage(ciImage: myOutputImage)
//        
//        // 画像の中心をスクリーンの中心位置に設定
//        //myImageView.image = CGPoint(x:self.view.bounds.width/2, y:self.view.bounds.height/2)
//        
//        // 再びUIViewにセット.
//        myImageView.image = myOutputUIImage
//        
//        // 再描画.
//        myImageView.setNeedsDisplay()
        
        self.title = "My Second View"
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        
        // 緯度表示用のラベルを生成.
        myLatitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        myLatitudeLabel.layer.position = CGPoint(x: 340, y:190)
        
        // 軽度表示用のラベルを生成.
        myLongitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        myLongitudeLabel.layer.position = CGPoint(x: 340, y:220)
        
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
        //myLatitudeLabel.textAlignment = .center
        print(manager.location!.coordinate.longitude)
        //myLongitudeLabel.text = "hoge"
        myLongitudeLabel.text = "経度：\(manager.location!.coordinate.longitude)"
        //myLongitudeLabel.textAlignment = .center
        
        
        self.view.addSubview(myLatitudeLabel)
        self.view.addSubview(myLongitudeLabel)
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(String(manager.location!.coordinate.latitude))&lon=\(String(manager.location!.coordinate.longitude))&APPID=47a738728ecba24e1da71b745ada7b08")
        let request = URLRequest(url:url!)
        print(request)
       var jsondata = (try! NSURLConnection.sendSynchronousRequest(request, returning: nil))
        let jsonDictionary = (try! JSONSerialization.jsonObject(with: jsondata, options: [])) as! NSDictionary
        for(key, data) in jsonDictionary{
            if (key as! String == "weather"){
                var resultArray = data as! NSArray
                for (eachWether) in resultArray{
                    var wether:NSDictionary = eachWether as! NSDictionary
                    self.locationLavel.text = String(describing: wether["main"]!)
                    self.locationLavel.textColor = UIColor.white
                    
                    if String(describing: wether["main"]!)=="Sunny"  {
                        // UIImageを作成.
                        let myImage: UIImage = UIImage(named: "sunny.png")!
                        // 画像をUIImageViewに設定する.
                        self.WeatherImage.image = myImage
                        // UIImageViewをViewに追加する
                        self.view.addSubview(self.WeatherImage)
                    }
                    if String(describing: wether["main"]!)=="Clouds"  {
                        // UIImageを作成.
                        let myImage: UIImage = UIImage(named: "clouds.png")!
                        // 画像をUIImageViewに設定する.
                        self.WeatherImage.image = myImage
                        // UIImageViewをViewに追加する
                        self.view.addSubview(self.WeatherImage)
                    }
                    if String(describing: wether["main"]!)=="Mist"  {
                        // UIImageを作成.
                        let myImage: UIImage = UIImage(named: "mist.png")!
                        // 画像をUIImageViewに設定する.
                        self.WeatherImage.image = myImage
                        // UIImageViewをViewに追加する
                        self.view.addSubview(self.WeatherImage)
                    }
                
            }
        }
//            if (data as! String == "main") {
//             var result = data as! NSArray
//                for (eachwether) in result{
//                    var Wether:NSDictionary = eachwether as! NSDictionary
//                    self.myLatitudeLabel.text = String(describing:Wether["humidity"])
//                    self.myLatitudeLabel.textColor = UIColor.white
//                }
            //}
        
        
        // Labelを作成.
        self.locationLavel = UILabel(frame: CGRect(x: 100, y: 120, width: self.bWidth, height: self.bHeight))
        // Textを中央寄せにする.
        locationLavel.textAlignment = NSTextAlignment.center
        //viewに追加
        self.view.addSubview(locationLavel)

        
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

}
