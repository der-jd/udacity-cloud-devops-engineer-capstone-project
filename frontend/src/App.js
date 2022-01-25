import logo from './logo.svg';
import './App.css';
import React from "react";

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

  render() {
    if (!this.state.dataIsLoaded)
      return <div><h1>Pleses wait until data from backend is fetched...</h1></div>;

    console.log("type wisdom: " + typeof this.state.wisdom)
    console.log("type source: " + typeof this.state.source)
    console.log("type categories: " + typeof this.state.categories)
    console.log("type imageUrls: " + typeof this.state.imageUrls)

    let image = <div></div>; // empty html tag if no images exist
    for (let url of this.state.imageUrls) {
      console.log("image url: " + url);
      image = <img src={url} alt="Descriptive img" />;
    }

    // TODO: Format and output JSON response correctly
    // Return-statement uses JSX (JavaScript Syntax Extension)
    // Only JavaScript expressions (but no statements) can be used inside JSX with curly braces {}
    // https://reactjs.org/docs/introducing-jsx.html
    return (
      <div className="App">
        <h1>GetWise</h1>
        <pre>{this.state.wisdom}</pre>
        <p>Source: {this.state.source}</p>
        <p>Categories: {this.state.categories.join(', ')}</p>
        <div id="img"/>
        {image}
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
      </div>
    );
  }

  // componentDidMount() is invoked immediately after a component is mounted --> use to fetch the backend api
  // https://www.geeksforgeeks.org/how-to-fetch-data-from-an-api-in-reactjs/
  // https://reactjs.org/docs/react-component.html#componentdidmount
  // TODO: add .env.production with host url of K8s Cluster
  componentDidMount() {
    fetch("./api/wisdom")
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
