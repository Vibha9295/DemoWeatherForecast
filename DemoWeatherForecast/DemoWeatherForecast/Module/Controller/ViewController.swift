
import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: -  Outlets
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblForecast: UITableView!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var imgSymbol: UIImageView!
    
    //MARK: - Variable Declaration
    let networkManager = WeatherNetworkManager()
    var forecastData: [ForecastTemperature] = []
    var locationManager = CLLocationManager()
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    //MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    //MARK: - Initialization Method
    func initView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - UIAction button methods
    @IBAction func btnRefresh(_ sender: Any) {
        forecastData = []
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    //MARK: - Load weather data based on location
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            let calendar = Calendar.current
            let f = DateFormatter()
            let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
            let currentWeekDay = currentDayComponent.weekday! - 1
            let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
            self.networkManager.fetchNextFiveWeatherForecast(city: city) { (forecast) in
                self.forecastData = forecast
                DispatchQueue.main.async {
                    self.tblForecast.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.lblTemp.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                self.lblCity.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.lblTime.text = "\(currentweekdaysymbol), \(stringDate)"
                self.lblTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                self.lblDescription.text = weather.weather[0].description
                self.lblHumidity.text = "Humidity: \(String(weather.main.humidity))%"
                self.imgSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            self.loadData(city: "\(weather.name ?? "") , \(weather.sys.country ?? "")")
        }
    }
}

//MARK: - Loctaion Delegate Extension
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTblCell", for: indexPath) as! ForecastTblCell
        cell.configure(with: forecastData[indexPath.row])
        
        return cell
    }
    
}
