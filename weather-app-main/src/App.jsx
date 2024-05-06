import countries from './assets/countries'
import CitySearchBar from './components/CitySearchBar'
import './App.css';
function App() {

  return (
    <div className="container">
      <div className="title">
        <h1>Weather Comparison</h1>
      </div>
      <div className="blank">  </div>
      <div className="search-bar">
        <CitySearchBar countries={countries} />
      </div>
      <div className="search-bar">
        <CitySearchBar countries={countries} />
      </div>
    </div>
  );
}

export default App
