const {src, dest, watch, series} = require('gulp');
const pump = require('pump');

// Packages
const concat = require('gulp-concat');
const uglify = require('gulp-uglify');
const cleanCSS = require('gulp-clean-css');

// Build CSS
function css(done) {
    pump([
        src('assets/css/*.css', {sourcemaps: true}),
        concat('screen.css'),
        cleanCSS(),
        dest('assets/built/', {sourcemaps: '.'})
    ], done);
}

// Build JS (if you add JavaScript files)
function js(done) {
    pump([
        src('assets/js/*.js', {sourcemaps: true}),
        concat('main.js'),
        uglify(),
        dest('assets/built/', {sourcemaps: '.'})
    ], done);
}

// Watch files
function watchFiles() {
    watch('assets/css/*.css', css);
    // watch('assets/js/*.js', js);
}

// Default task
exports.default = series(css);
exports.watch = series(css, watchFiles);