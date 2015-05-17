gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
iife       = require 'gulp-iife'
plumber    = require 'gulp-plumber'
del        = require 'del'
preprocess = require 'gulp-preprocess'

gulp.task 'default', ->
  gulp.start 'build'

dependencies = [
  {require: 'lodash', global: '_'}
  {require: 'yess'}
]

gulp.task 'build', ->
  gulp.src('source/coffee-concerns.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe iife {dependencies, global: 'Concerns'}
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('coffee-concerns.js')
    .pipe gulp.dest('build')

gulp.task 'coffeespec', ->
  del.sync 'spec/**/*.js'
  gulp.src('coffeespec/**/*.coffee')
    .pipe coffee(bare: yes)
    .pipe gulp.dest('spec')