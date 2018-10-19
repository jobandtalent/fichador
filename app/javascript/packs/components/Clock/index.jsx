import React, { Component } from 'react';

class Clock extends Component {
  state = {
    footnote: 'Powered by JS'
  };

  render() {
    const { state } = this;
    return (
      <div>
        <button type="button">Comenzar</button>
        <p>{state.footnote}</p>
      </div>
    );
  }
}

export default Clock;
