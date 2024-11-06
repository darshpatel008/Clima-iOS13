
import Foundation
import CoreLocation

protocol WeatherManagerDelegate 
{
    func didUpdateWeather(_  weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5aa9dac3a8a40526eba48d9e263001e3&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) 
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    func fetchWeather(lat: CLLocationDegrees , lon: CLLocationDegrees)
    {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil
                {
                   
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data 
                {
                    // receiving data from parseJSON
                    if let weather = self.parseJSON(safeData)
                    {
                        self.delegate?.didUpdateWeather(weather) // passing data
                    }
                }
            }
            task.resume()
        }
    }
    // decoding data and sending decoded data back
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
          
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            // storing decoded data at weatherModel
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        
            return weather
            
        }
        catch
        {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
