const gulp = require('gulp');
const browserSync = require('browser-sync');
const spa = require('browser-sync-spa');

const browserSyncDevConf = require('../conf/browsersync-dev.conf');
const browserSyncProdConf = require('../conf/browsersync-prod.conf');

browserSync.use(spa());

gulp.task('browsersync:dev', browserSyncDevServe);
gulp.task('browsersync:prod', browserSyncProdServe);

function browserSyncDevServe(done) {
  browserSync.init(browserSyncDevConf());
  done();
}

function browserSyncProdServe(done) {
  browserSync.init(browserSyncProdConf());
  done();
}
