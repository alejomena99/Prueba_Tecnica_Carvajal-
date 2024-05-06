import React, { useState } from 'react';
import axios from 'axios';
import { API_KEY } from '../../env';
const CitySearchBar = ({ countries }) => {
  const [selectedCountry, setSelectedCountry] = useState('');
  const [city, setCity] = useState('');
  const [weatherData, setWeatherData] = useState(null);
  const [error, setError] = useState(null);

  const handleCountryChange = (event) => {
    setSelectedCountry(event.target.value);
  };

  const handleCityChange = (event) => {
    setCity(event.target.value);
  };

  const fetchCityData = async(searchData) =>{
    try{
        const res =  await axios.get(`http://api.openweathermap.org/geo/1.0/direct?q=${searchData.city},${searchData.countryCode}&limit=5&appid=${API_KEY}`);
        const cityData = res.data[0];
        return cityData;
    }catch(e){
        console.log(e);
    }
  }; 
  const fetchWeatherData = async(cityData) =>{
    try{
        const res =  await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${cityData.lat}&lon=${cityData.lon}&appid=${API_KEY}`);
        const weatherData = res.data.main;
        return weatherData;
    }catch(e){
        console.log(e);
    }
  }; 

  const handleSearch = async() => {
    try {
        const searchData = {
            city: city,
            countryCode: selectedCountry
          };
      
          const cityData =  await fetchCityData(searchData);
          const weather = await fetchWeatherData(cityData);
          console.log(weather);
          setWeatherData(weather);
          setError(null);
    } catch (error) {
        console.error('Error fetching data:', error);
        setError('Error fetching weather data. Please try again.');
    }

  };

return (
  <div>
    {error && <p className="error">{error}</p>}
    {weatherData && (
      <div className="weather-info">
        <p className='label'>Temperature: {Math.round(weatherData.temp - 273.15)} C°</p>
        <p className='label'>Feels like: {Math.round(weatherData.feels_like - 273.15)} C°</p>
        <p className='label'>Pressure: {weatherData.pressure} PSI</p>
        <p className='label'>Humidity: {weatherData.humidity}%</p>
      </div>
    )}
    <div className='content-group'>
    <div className="form-group">
      <label className="label-right" htmlFor="country">Select a country:</label>
      <select className="select" id="country" value={selectedCountry} onChange={handleCountryChange}>
        <option value="">-- Select --</option>
        {countries.map((country, index) => (
          <option key={index} value={country.code}>
            {country.name}
          </option>
        ))}
      </select>
    </div>
    <div className="form-group">
      <label className="label-left" htmlFor="city">Enter city name:</label>
      <input className="input" type="text" id="city" value={city} onChange={handleCityChange} />
    </div>
    </div>
    <div className='content-group'>
    <button className="button" onClick={handleSearch}>Search</button>
    </div>
  </div>
);
};

export default CitySearchBar;