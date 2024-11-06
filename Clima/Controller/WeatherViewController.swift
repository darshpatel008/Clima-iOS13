import UIKit
import CoreLocation


class WeatherViewController: UIViewController{
    

    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }


    @IBAction func GPSButton(_ sender: UIButton) 
    {
        locationManager.requestLocation()
    }
    
}
//MARK: - UITextField

extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton)
    {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool 
    {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool 
    {
        if textField.text != "" 
        {
            return true
        } 
        else
        {
            textField.placeholder = "Type something"
            return false
        }
    }
  
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if let city = searchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
    
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate
{
    func didUpdateWeather(_ weather: WeatherModel)
   {
         DispatchQueue.main.async  // if we dont write app is goining to crash
       {
           self.temperatureLabel.text = weather.temperatureString
           self.conditionImageView.image = UIImage(systemName: weather.conditionName)
           self.cityLabel.text = weather.cityName
       }
    }
    
    func didFailWithError(error: Error)
        {
            print(error)
        }
}
//MARK: - CLLocationManagerDelegate:


extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) 
    {
        if let location = locations.last
        {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) 
    {
        print(error)
    }
}
