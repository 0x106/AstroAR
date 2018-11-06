// Astro AR
// components/button
// Jordan Campbell
// November 2018
import React from 'react';

class Button extends React.Component {

  constructor (props) {
    super(props);
    this.onclick = this.onclick.bind(this);
  }

  onclick(element) {
    console.log('click');
  }

  render() {
    return (
      <button onClick={this.props.publishCallback} style={
        {
          position: 'absolute',
          right: 40,
          zIndex: 1000,
          bottom: 40,
          fontWeight: 400,
          color: '#001f54',
          backgroundColor: 'white',
          border: '1px solid #001f54',
          borderRadius: '0.3em',
          cursor: 'pointer',
          padding: '16px 32px',
          fontSize: '18px'
        }}
      >{this.props.value}</button>
    );
  }
}

export default Button;
