gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
iife       = require 'gulp-iife-wrap'
plumber    = require 'gulp-plumber'
del        = require 'del'
preprocess = require 'gulp-preprocess'

try
  require('./gulp-preprocess/node_modules/preprocess/lib/regexrules').coffee.include = "^(.*?)#+[ \t]*\%include(?!-)[ \t]+(.*?)[ \t]*$"
catch
  require('./node_modules/preprocess/lib/regexrules').coffee.include = "^(.*?)#+[ \t]*\%include(?!-)[ \t]+(.*?)[ \t]*$"

gulp.task 'default', ['build'], ->

gulp.task 'build', ->
  dependencies = [
    {require: 'lodash'}
    {require: 'yess',      global: '_'}
    {global:  'Object',    native: true}
    {global:  'TypeError', native: true}
    {global:  'Function',  native: true}
  ]
  gulp.src('source/__manifest__.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe iife {dependencies, global: 'Concerns'}
    .pipe concat('coffee-concerns.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('coffee-concerns.js')
    .pipe gulp.dest('build')

gulp.task 'coffeespec', ->
  del.sync 'spec/**/*'
  gulp.src('coffeespec/**/*.coffee')
    .pipe coffee(bare: true)
    .pipe gulp.dest('spec')
  gulp.src('coffeespec/support/jasmine.json')
    .pipe gulp.dest('spec/support')
