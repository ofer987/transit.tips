const gulp = require('gulp');
const gulpConf = require('../conf/gulp.conf');

gulp.task('spec:build', done => {
  let ts = require('gulp-typescript');
  let tsProject = ts.createProject('./tsconfig/spec.json');

  return gulp
    .src([
      `${gulpConf.paths.spec}/**/*.ts`,
      `${gulpConf.paths.spec}/**/*.tsx`
    ])
    .pipe(tsProject())
    .pipe(gulp.dest(gulpConf.paths.build.spec));

  done();
});
