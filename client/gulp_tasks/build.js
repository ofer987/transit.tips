const path = require('path');

const gulp = require('gulp');
const del = require('del');
const run = require('gulp-run');
const filter = require('gulp-filter');

const conf = require('../conf/gulp.conf');

gulp.task('build:clean', clean);
gulp.task('build:compile', compile);
// gulp.task('build:dist', copyToDist);
gulp.task('build:rebuild', gulp.series('build:clean', 'build:compile'));

// Clean (i.e, remove) compile/ and dist/ dir
function clean() {
  return del([conf.paths.compile, conf.paths.dist]);
}

function compile(done) {
  // Compile typescript to JavaScript
  return run(`tsc --outDir ${conf.paths.compile}`).exec(() => {
    // Copy files (e.g., *.js*, html, css)
    // to dist/
    copy(conf.paths.dist);

    done();
  });
}

function copy(destination) {
  gulp
    .src([`${conf.paths.compile}/**/*`])
    .pipe(gulp.dest(destination));

  gulp
    .src([`${conf.paths.src}/**/!(*.ts)*`], { 'dot': true })
    .pipe(gulp.dest(destination));
}
