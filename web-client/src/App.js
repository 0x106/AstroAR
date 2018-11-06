import React, { Component } from 'react';
import Editor from './components/editor';
import './App.css';
import AstroLogo from './images/astro-logo.png'

class App extends Component {
  render() {
    return (
      <div>
        <Editor />
        <div style={{position: 'absolute', right: 40, zIndex: 1000, top: 20}}>
          <img src={AstroLogo} alt="Astro Logo" width="200"/>
        </div>
      </div>
    );
  }
}

export default App;
