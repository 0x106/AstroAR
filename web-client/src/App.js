import React, { Component } from 'react';
import Editor from './components/editor';
import './App.css';
import AstroLogo from './images/astro-logo.png'

class App extends Component {
  render() {

    console.log("~~~~ Welcome! ~~~~")
    console.log("The repo for this website can be found at: https://github.com/Jordan-Campbell/AstroAR")
    console.log("I built this app while listening to this soundtrack: https://open.spotify.com/album/3vaofIDja1ihEoBF2dl467")
    console.log("Happy hacking!")

    return (
      <div>
        <Editor />
        <div style={{position: 'absolute', right: 20, zIndex: 1000, top: 20}}>
          <img src={AstroLogo} alt="Astro Logo" width="140"/>
        </div>
      </div>
    );
  }
}

export default App;
