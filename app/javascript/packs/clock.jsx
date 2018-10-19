import React from 'react';
import { render } from 'react-dom';
import { hot } from 'react-hot-loader';
import Clock from './components/Clock';
import 'styles/clock.css';

const mountEnvironment = () => {
  const appMountPoint = document.getElementById('clock');
  const Component = hot(module)(Clock);
  render(<Component />, appMountPoint);
};

if (document.readyState === 'ready' || document.readyState !== 'loading') {
  mountEnvironment();
} else {
  document.addEventListener('DOMContentLoaded', mountEnvironment);
}
