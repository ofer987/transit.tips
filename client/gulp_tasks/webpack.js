const gulp = require('gulp');
const gutil = require('gulp-util');

const webpack = require('webpack');
const webpackDevConf = require('../conf/webpack-dev.conf');
const webpackProdConf = require('../conf/webpack-prod.conf');
const gulpConf = require('../conf/gulp.conf');

gulp.task('webpack:dev', done => {
  webpackWrapper(false, webpackDevConf, done);
});

gulp.task('webpack:watch', done => {
  webpackWrapper(true, webpackDevConf, done);
});

gulp.task('webpack:prod', done => {
  webpackWrapper(false, webpackProdConf, done);
});

function webpackWrapper(watch, conf, done) {
  const webpackBundler = webpack(conf);

  const webpackChangeHandler = (err, stats) => {
    if (err) {
      gulpConf.errorHandler('Webpack')(err);
    }
    gutil.log(stats.toString({
      colors: true,
      chunks: false,
      hash: false,
      version: false
    }));
    if (done) {
      done();
      done = null;
    }
  };

  if (watch) {
    webpackBundler.watch(200, webpackChangeHandler);
  } else {
    webpackBundler.run(webpackChangeHandler);
  }
}
