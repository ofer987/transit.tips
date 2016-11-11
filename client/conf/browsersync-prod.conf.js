const conf = require('./gulp.conf');

module.exports = function () {
  return {
    server: {
      baseDir: [conf.paths.build.prod]
    },
    open: false
  };
};
