import headerImg from './dr-manhattan-7-4KHuge.com_edited.jpg';
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
    const Button = styled.button`
      background-color: black;
      color: white;
      font-size: 20px;
      padding: 10px 60px;
      border-radius: 5px;
      margin: 10px 0px;
      cursor: pointer;
    `;

    let wisdomBlock;
    if (this.state.dataIsLoaded) {
      const images = [];
      for (let i = 0; i < this.state.imageUrls.length; i++)
        images[i] = <img key={i.toString()} src={this.state.imageUrls[i]} alt="Descriptive img" />;

      wisdomBlock =
        <div className="Content-section">
          <pre className="Wisdom">{this.state.wisdom}</pre>
          <p className="Wisdom-source">Source: {this.state.source}</p>
          <p className="Wisdom-categories">Categories: {this.state.categories.join(', ')}</p>
          <div id="images">
            {images}
          </div>
        </div>;
    }
    else {
      wisdomBlock = <p>Please wait until data is fetched from backend...</p>;
    }

    // Return-statement uses JSX (JavaScript Syntax Extension)
    // Only JavaScript expressions (but no statements) can be used inside JSX with curly braces {}
    // https://reactjs.org/docs/introducing-jsx.html
    return (
      <div className="App">
        <header className="App-header">
          <figure>
            <img src={headerImg} className="App-header-img" alt="header-img" />
            <figcaption className="App-header-img-source">Source: https://www.4khuge.com/album/dr-manhattan/dr-manhattan-7</figcaption>
          </figure>
          <h1>GetWise</h1>
          <Button onClick={this.reload}>Reload</Button>
        </header>
        {wisdomBlock}
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
