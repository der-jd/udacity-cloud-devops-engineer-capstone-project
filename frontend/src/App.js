import logo from './logo.svg';
import './App.css';
import React from "react";
import styled from 'styled-components';

class App extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      wisdom: "",
      source: "",
      categories: [],
      imageUrls: [],
      dataIsLoaded: false
    };
  }

  reload() {
    window.location.reload();
  }

  render() {
    if (!this.state.dataIsLoaded)
      return <div><h1>Pleses wait until data from backend is fetched...</h1></div>;

    const Button = styled.button`
      background-color: black;
      color: white;
      font-size: 20px;
      padding: 10px 60px;
      border-radius: 5px;
      margin: 10px 0px;
      cursor: pointer;
    `;

    let image = <></>; // empty html tag if no images exist
    for (let url of this.state.imageUrls)
      image = <img src={url} alt="Descriptive img" />;

    // Return-statement uses JSX (JavaScript Syntax Extension)
    // Only JavaScript expressions (but no statements) can be used inside JSX with curly braces {}
    // https://reactjs.org/docs/introducing-jsx.html
    return (
      <div className="App">
        <header className="App-header">
          <h1>GetWise</h1>
          <Button onClick={this.reload}>Reload</Button>
          <pre>{this.state.wisdom}</pre>
          <p>Source: {this.state.source}</p>
          <p>Categories: {this.state.categories.join(', ')}</p>
          {image}
          <img src={logo} className="App-logo" alt="logo" />
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }

  // componentDidMount() is invoked immediately after a component is mounted --> use to fetch the backend api
  // https://www.geeksforgeeks.org/how-to-fetch-data-from-an-api-in-reactjs/
  // https://reactjs.org/docs/react-component.html#componentdidmount
  // TODO: add .env.production with host url of K8s Cluster
  componentDidMount() {
    let host = "";
    if (process.env.NODE_ENV === "production")
      host = process.env.REACT_APP_HOST;
    fetch(host + "/api/wisdom")
      .then(res => res.json())
      .then(jsonData => {
        this.setState({
          wisdom: jsonData.wisdom,
          source: jsonData.source,
          categories: jsonData.categories,
          imageUrls: jsonData["image-urls"],
          dataIsLoaded: true
        });
        console.log(jsonData);
      })
      .catch(error => {
        console.error("Error when fetching backend api:\n" + error);
      })
  }
}

export default App;
