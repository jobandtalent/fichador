import 'url-search-params-polyfill';

global.requestAnimationFrame = callback => {
  setTimeout(callback, 0);
};
