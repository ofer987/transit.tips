const gulp = require('gulp');
const browserSync = require('browser-sync');
const spa = require('browser-sync-spa');

const browserSyncDevConf = require('../conf/browsersync-dev.conf');
const browserSyncDistConf = require('../conf/browsersync-dist.conf');

browserSync.use(spa());

gulp.task('browsersync:dev', browserSyncDevServe);
gulp.task('browsersync:dist', browserSyncDistServe);

function browserSyncDevServe(done) {
  browserSync.init(browserSyncDevConf());
  done();
}

function browserSyncDistServe(done) {
  browserSync.init(browserSyncDistConf());
  done();
}
