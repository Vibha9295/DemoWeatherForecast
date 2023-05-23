
import UIKit

struct WeatherInfo {
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let description: String
    let icon: String
    let time: String
}

struct ForecastTemperature {
    let date: String?
    let weekDay: String?
    let hourlyForecast: [WeatherInfo]?
}
