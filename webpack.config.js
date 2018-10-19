const extname = require('path-complete-extname');
const fs = require('fs');
const glob = require('glob');
const path = require('path');
const webpack = require('webpack');
const argv = require('yargs').argv;
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

const isDevServer = path.basename(argv.$0).includes('webpack-dev-server');

const environment = process.env.TARGET || 'production';
const isDevelopment = environment === 'development';
let outputPublicPath;
const devServerConfig = {};
if (isDevServer) {
  devServerConfig.port = argv.port || 3001;
  devServerConfig.public = argv.public || `localhost:${devServerConfig.port}`;
  outputPublicPath = argv.outputPublicPath || `http://${devServerConfig.public}/packs/`;
  devServerConfig.headers = {
    'Access-Control-Allow-Origin': '*'
  };
} else {
  outputPublicPath = argv.outputPublicPath || '/packs/';
}
const outputPath = path.resolve(__dirname, argv.outputPath || 'public/packs');
const sourcePath = 'app/javascript';
const cachePath = 'tmp/cache/webpacker';
const hmr = process.argv.includes('--hot');

const extensions = [
  '.erb',
  '.js',
  '.jsx',
  '.css',
  '.less',
  '.png',
  '.svg',
  '.gif',
  '.jpeg',
  '.jpg',
  '.yaml',
  '.yml'
];

const rootPath = path.resolve(__dirname, `${sourcePath}/packs`);
const extensionsGlob = `*{${extensions.join(',')}}`;
const entries = {};
glob.sync(path.join(rootPath, extensionsGlob)).forEach(source => {
  const namespace = path.relative(path.join(rootPath), path.dirname(source));
  const name = path.join(namespace, path.basename(source, extname(source)));
  entries[name] = path.resolve(source);
});

const loaders = {};
loaders.babel = {
  test: /\.(js|jsx)?(\.erb)?$/,
  exclude: /node_modules/,
  use: [
    {
      loader: 'babel-loader',
      options: {
        cacheDirectory: path.join(cachePath, 'babel-loader')
      }
    }
  ]
};
loaders.file = {
  test: /\.(jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|woff2)$/i,
  use: {
    loader: 'file-loader',
    options: {
      name: '[path][name]-[hash].[ext]',
      context: path.join(sourcePath)
    }
  }
};
const defaultCssLoaders = [
  {
    loader: 'css-loader',
    options: {
      minimize: !isDevelopment,
      sourceMap: isDevelopment,
      importLoaders: 2,
      modules: false
    }
  }
];
const styleLoader = {
  loader: hmr ? 'style-loader' : MiniCssExtractPlugin.loader,
  options: {
    hmr,
    sourceMap: isDevelopment
  }
};
const lessLoader = {
  loader: 'less-loader',
  options: { sourceMap: isDevelopment }
};
loaders.css = {
  test: /\.css$/i,
  use: [styleLoader, 'css-loader']
};
loaders.less = {
  test: /\.less$/i,
  use: [styleLoader, 'css-loader', lessLoader]
};
loaders.yaml = {
  test: /\.ya?ml$/,
  use: [
    {
      loader: 'json-loader'
    },
    {
      loader: 'yaml-loader'
    }
  ]
};

const plugins = {};
plugins.CaseSensitivePaths = new CaseSensitivePathsPlugin();
plugins.ExtractCss = new MiniCssExtractPlugin({
  filename: !isDevelopment ? '[name].[hash].css' : '[name].css',
  chunkFilename: !isDevelopment ? '[id].[hash].css' : '[id].css'
});
plugins.Manifest = new ManifestPlugin({
  publicPath: outputPublicPath,
  writeToFileEmit: true,
  seed: { hmr }
});
plugins.Provider = new webpack.ProvidePlugin({ jQuery: 'jquery' });
if (isDevServer) {
  const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
  plugins.BundleAnalyzerPlugin = new BundleAnalyzerPlugin();
}

const config = {
  mode: isDevelopment ? 'development' : 'production',
  devServer: devServerConfig,
  devtool: isDevelopment ? 'inline-source-map' : 'nosources-source-map',
  stats: isDevelopment ? { errorDetails: true } : 'normal',
  entry: entries,
  module: {
    strictExportPresence: true,
    rules: Object.values(loaders)
  },
  node: {
    dgram: 'empty',
    fs: 'empty',
    net: 'empty',
    tls: 'empty',
    child_process: 'empty'
  },
  output: {
    filename: isDevelopment ? '[name]-[hash].js' : '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    publicPath: outputPublicPath,
    path: outputPath,
    pathinfo: true
  },
  optimization: {
    namedModules: true,
    splitChunks: {
      name: 'vendor-libs',
      cacheGroups: {
        'vendor-libs': {
          test: /node_modules/,
          chunks: 'initial',
          enforce: true
        },
        default: false
      }
    },
    noEmitOnErrors: false,
    concatenateModules: true,
    minimizer: [
      new UglifyJsPlugin({
        parallel: true,
        cache: true,
        sourceMap: isDevelopment,
        uglifyOptions: {
          ie8: false,
          ecma: 8,
          warnings: false,
          mangle: {
            safari10: true
          },
          compress: {
            dead_code: true,
            drop_console: true,
            warnings: false,
            comparisons: false
          },
          output: {
            ascii_only: true,
            comments: false
          }
        }
      })
    ]
  },
  plugins: Object.values(plugins),
  resolve: {
    extensions,
    alias: {
      Locales: path.resolve(__dirname, 'config/locales')
    },
    modules: [path.resolve(__dirname, sourcePath), 'node_modules']
  },
  resolveLoader: {
    modules: ['node_modules']
  }
};

module.exports = config;
