//
//  ViewController.swift
//  What the weather is like
//
//  Created by Karol Chmiel on 05/09/2017.
//  Copyright © 2017 Karol Chmiel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var counter: Int = 0
    var timer = Timer()
    
    @IBAction func checkWeatherAction(_ sender: Any) {
        checkWeather(for: textField.text!)
    }
    
    func checkWeather(for place:String) -> Void {
        textField.text = ""
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + place.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            print(url)
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                var message = ""
                if error != nil {
                    print(error as Any)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span"
                                let newContentArray = contentArray[1].components(separatedBy:   stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(newContentArray[0])
                                }
                            }
                        }
                    }
                }
            if message == "" {
                message = "The weather there couldn't be found. Please try again"
            }
            DispatchQueue.main.sync {
                self.weatherInfoLabel.text = message
            }
        }
        task.resume()
        } else {
            weatherInfoLabel.text = "The weather there couldn't be found. Please try again"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }
    
    func startAnimation() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    func changeImage() -> Void {
        counter += 1
        if counter == 86 {
            counter = 0
        }
        setNewImage(counter)
    }
    
    func setNewImage(_ counter: Int) -> Void {
        if counter < 10 {
            self.imageView.image = UIImage(named: "frame_00" + String(counter) + ".gif")
        } else {
            self.imageView.image = UIImage(named: "frame_0" + String(counter) + ".gif")
        }
    }
    
    func shouldResetTimer(_ counter: Int) -> Bool {
        return counter == 86
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

