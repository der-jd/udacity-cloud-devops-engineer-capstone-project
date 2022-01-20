import logo from './logo.svg';
import './App.css';
import React from "react";

class App extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      items: [],
      DataIsLoaded: false
    };
  }

  // https://www.geeksforgeeks.org/how-to-fetch-data-from-an-api-in-reactjs/
  render() {
    const { DataIsLoaded, items } = this.state;
    if (!DataIsLoaded)
      return <div><h1>Pleses wait until data from backend is fetched...</h1></div>;

    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>

        <h1>GetWise</h1>
        {
          <p>Data from backend api: {items}</p> // TODO: Format and output JSON response (items) correctly
        }
      </div>
    );
  }

  // componentDidMount() is invoked immediately after a component is mounted --> use to fetch the backend api
  // https://reactjs.org/docs/react-component.html#componentdidmount
  // https://www.geeksforgeeks.org/how-to-fetch-data-from-an-api-in-reactjs/
  componentDidMount() {
    fetch("./wisdom")
      .then((res) => res.json()) // TODO FIX ERROR: Response is interpreted as HTMl so error message with leading '<' ?!
      .then((jsonData) => {
        this.setState({
          items: jsonData,
          DataIsLoaded: true
        });
        console.log(jsonData);
      })
      .catch((error) => {
        console.error("Error when fetching backend api:\n" + error);
      })
  }
}

export default App;
