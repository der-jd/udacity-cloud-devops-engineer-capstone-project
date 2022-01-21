import logo from './logo.svg';
import './App.css';
import React from "react";

function validImageUrl(url) {
  if (url) {
    let tag = document.createElement("img");
    tag.src = url;
    tag.alt = "Descriptive img";
    //document.getElementById("img").appendChild(tag);
    return tag;
  }
}

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

  // https://www.geeksforgeeks.org/how-to-fetch-data-from-an-api-in-reactjs/
  render() {
    if (!this.state.dataIsLoaded)
      return <div><h1>Pleses wait until data from backend is fetched...</h1></div>;

    console.log("type wisdom: " + typeof this.state.wisdom)
    console.log("type categories: " + typeof this.state.categories)
    console.log("type items: " + typeof this.state.items)

    // TODO: Format and output JSON response correctly
    //<img src={this.state.imageUrls[0]} alt="Descriptive img" />
    //displayImage(this.state.imageUrls[0])</script>
    return (
      <div className="App">
        <h1>GetWise</h1>
        <pre>{this.state.wisdom}</pre>
        <p>Source: {this.state.source}</p>
        <p>Categories: {this.state.categories.join(', ')}</p>
        <div id="img"/>
        <script>{document.getElementById("img").appendChild(validImageUrl(this.state.imageUrls[0]))}
        </script>
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
