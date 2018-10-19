process.on('unhandledRejection', r => console.log(r)); // eslint-disable-line no-console

module.exports = {
  roots: ['app/javascript'],
  collectCoverage: true,
  collectCoverageFrom: ['app/javascript/packs/**/*.js', 'app/javascript/packs/**/*.jsx'],
  moduleDirectories: ['./node_modules', '../app/javascript'],
  moduleNameMapper: {
    '\\.(css|less|sass)$': 'identity-obj-proxy'
  },
  setupFiles: ['./app/javascript/packs/__tests__/__helpers__/setup.js'],
  setupTestFrameworkScriptFile: './node_modules/jest-enzyme/lib/index.js',
  testPathIgnorePatterns: ['/node_modules/', './app/javascript/packs/__tests__/__helpers__/']
};
