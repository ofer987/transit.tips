const gulp = require('gulp');
const HubRegistry = require('gulp-hub');
const browserSync = require('browser-sync');

const conf = require('./conf/gulp.conf');

// Load some files into the registry
const hub = new HubRegistry([conf.path.tasks('*.js')]);

// Tell gulp to use the tasks just loaded
gulp.registry(hub);

function reloadBrowserSync(cb) {
  browserSync.reload();
  cb();
}

function watch(done) {
  gulp.watch(conf.path.tmp('index.html'), reloadBrowserSync);
  done();
}

gulp.task('test', gulp.series('karma:single-run'));
gulp.task('test:auto', gulp.series('karma:auto-run'));

gulp.task('serve', gulp.series('webpack:dist', 'browsersync:dist'));

gulp.task('watch', watch);

gulp.task('dev', gulp.series('dev:build', 'dev:server'))
gulp.task('dev:build', gulp.series('webpack:dev'))
gulp.task('dev:server', gulp.series('browsersync:dev'))
