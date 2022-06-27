//
//  ViewController.swift
//  Weather
//
//  Created by 정유진 on 2022/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
            //버튼이 눌리면 키보드가 사라지게
        }
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=94a9fa6ab5c543d2ac7ccff4cd63d74f") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            //json 객체에서 데이터 유형의 인스턴스로 디코딩하는 객체
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data)
            //첫번째 파라미터에는 json을 mapping시켜줄 Codable 프로토콜을 준수하는 사용자 정의 타입
            //from: 파라미터에는 서버에서 응답받은 json데이터를 넣어주면 된다
            //디코딩이 실패하면 error를 던져주기 때문에  try? 추가
            debugPrint(weatherInformation)
        }.resume()//작업실행
        
    }

}

