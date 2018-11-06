// Astro AR
// components/button
// Jordan Campbell
// November 2018

import React from 'react';

class Button extends React.Component {

  constructor (props) {
    super(props);
  }

  render() {
    return (

      // When this button is clicked we trigger a callback on the parent element.
      // Add the style inline since this is only a very simple demo, otherwise
      // I would consider this very bad practice since buttons are likely to take
      // on a number of styles.
      // Whenever possible, I always do things the easy way to begin with as it
      // is always easier to change small pieces, rather than building entirely
      // from scratch.
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
