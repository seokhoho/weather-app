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
    @IBOutlet weak var weatherStackView: UIStackView!
    
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
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        //도시 이름
        if let weather = weatherInformation.weather.first {
            //weather 배열의 첫번째 요소가 let weather에 대입되게 하고
            self.weatherDescriptionLabel.text = weather.description //현재 날씨 정보
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        //절대 온도에서 섭씨온도로 변환
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=94a9fa6ab5c543d2ac7ccff4cd63d74f") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            //json 객체에서 데이터 유형의 인스턴스로 디코딩하는 객체
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                //클로져에서 전달받은 response를 HTTPURLResponse로 다운캐스팅
                //응답받은 statusCode가 200대인지 확인
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                //첫번째 파라미터에는 json을 mapping시켜줄 Codable 프로토콜을 준수하는 사용자 정의 타입
                //from: 파라미터에는 서버에서 응답받은 json데이터를 넣어주면 된다
                //디코딩이 실패하면 error를 던져주기 때문에  try? 추가
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false//날씨정보 표시 StackView
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()//작업실행
        
    }

}

