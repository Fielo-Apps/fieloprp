/**
 *
 *  Web Starter Kit
 *  Copyright 2015 Google Inc. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License
 *
 */

'use strict';

// This gulpfile makes use of new JavaScript features.
// Babel handles this without us having to do anything. It just works.
// You can read more about the new JavaScript features here:
// https://babeljs.io/docs/learn-es2015/


import fs from 'fs';
import path from 'path';
import gulp from 'gulp';
import del from 'del';
import runSequence from 'run-sequence';
import browserSync from 'browser-sync';
import swPrecache from 'sw-precache';
import gulpLoadPlugins from 'gulp-load-plugins';
import {output as pagespeed} from 'psi';
import pkg from './package.json';

var shell = require('gulp-shell')

const $ = gulpLoadPlugins();
const reload = browserSync.reload;


/* ***************************** PLATFORM TASKS ***************************** */

// Sources
var platformSalesforceCss = [
  {
    src: [
      'resources/FieloPrp_Salesforce/styles/**/**/*.scss'
    ],
    dest: '../resource-bundles/FieloPrp_Salesforce.resource/styles'
 }
];

var platformSalesforceCssSources = [];
platformSalesforceCss.forEach(function (obj) {
  platformSalesforceCssSources = platformSalesforceCssSources.concat(obj.src);
});

var platformSalesforceJs = [
  {
    src: [
      // Components
      'resources/FieloPrp_Salesforce/scripts/programSelector.js',
      'resources/FieloPrp_Salesforce/scripts/invoiceItems.js',
      'resources/FieloPrp_Salesforce/scripts/formInvoice.js'
      // 'resources/FieloPlt_Salesforce/scripts/items.js',
      // 'resources/FieloPlt_Salesforce/scripts/levelOrder.js',
      // 'resources/FieloPlt_Salesforce/scripts/fileUpload.js',
      // Formularios
      // 'resources/FieloPlt_Salesforce/scripts/formMission.js',
      // 'resources/FieloPlt_Salesforce/scripts/formRule.js',
      // 'resources/FieloPlt_Salesforce/scripts/formLevel.js',
      // 'resources/FieloPlt_Salesforce/scripts/formSegment.js',
      // 'resources/FieloPlt_Salesforce/scripts/formRedemption.js',
      // 'resources/FieloPlt_Salesforce/scripts/formMember.js',
      // 'resources/FieloPlt_Salesforce/scripts/formChallengeReward.js',
      // 'resources/FieloPlt_Salesforce/scripts/formAction.js',
      // 'resources/FieloPlt_Salesforce/scripts/formLogicalExpression.js',
      // 'resources/FieloPlt_Salesforce/scripts/formAdjustTransaction.js',
      // 'resources/FieloPlt_Salesforce/scripts/formReward.js',
      // Landings
      // 'resources/FieloPlt_Salesforce/scripts/incentivesLanding.js',
      // 'resources/FieloPlt_Salesforce/scripts/redemptionLanding.js',
      // 'resources/FieloPlt_Salesforce/scripts/memberCreateFromAccount.js',
      // 'resources/FieloPlt_Salesforce/scripts/contactConvertion.js',
      // Views
      // 'resources/FieloPlt_Salesforce/scripts/challengeView.js',
      // 'resources/FieloPlt_Salesforce/scripts/programView.js',
      // 'resources/FieloPlt_Salesforce/scripts/promotionView.js',
      // Create
      // 'resources/FieloPlt_Salesforce/scripts/programCreate.js',
      // 'resources/FieloPlt_Salesforce/scripts/challengeCreate.js',
      // 'resources/FieloPlt_Salesforce/scripts/modelCreate.js',
      // 'resources/FieloPlt_Salesforce/scripts/promotionCreate.js'
    ],
    name: 'core.js',
    dest: '../resource-bundles/FieloPrp_Salesforce.resource/scripts'
  }
];

var platformSalesforceJsSources = [];
platformSalesforceJs.forEach(function (obj) {
  platformSalesforceJsSources = platformSalesforceJsSources.concat(obj.src);
});

// CSS
gulp.task('css', () => {
  const AUTOPREFIXER_BROWSERS = [
    'ie >= 11',
    'ff >= 30',
    'chrome >= 34',
    'safari >= 7',
    'ios >= 7',
    'android >= 4.4'
  ];
  return platformSalesforceCss.forEach(function (bundle) {
    return gulp.src(bundle.src)
      .pipe($.sourcemaps.init())
      .pipe($.sass({
        precision: 10
     }).on('error', $.sass.logError))
      .pipe($.autoprefixer(AUTOPREFIXER_BROWSERS))
      .pipe($.if('*.css', $.minifyCss()))
      .pipe($.size({title: 'styles'}))
      .pipe($.sourcemaps.write('./'))
      .pipe(gulp.dest(bundle.dest));
 });
});

// JavaScript concat and minify
gulp.task('js', ['lint'],
  () => {
    return platformSalesforceJs.forEach(function (bundle) {
      return gulp.src(bundle.src)
        .pipe($.sourcemaps.init())
        .pipe($.babel())
        .pipe($.sourcemaps.write())
        .pipe($.concat(bundle.name))
        .pipe($.uglify({preserveComments: 'some'}))
        // Output files
        .pipe($.size({title: 'scripts'}))
        .pipe($.sourcemaps.write('.'))
        .pipe(gulp.dest(bundle.dest))
   });
 });

// Local server
gulp.task('serve', ['css', 'js'], () => {
  browserSync({
    notify: false,
    // Customize the BrowserSync console logging prefix
    logPrefix: 'WSK',
    // Run as an https by uncommenting 'https: true'
    // Note: this uses an unsigned certificate which on first access
    //       will present a certificate warning in the browser.
    // https: true,
    server: ['resources', 'app'],
    port: 3000,
    ui: {
      weinre: {
        port: 3001
     }
   }
 });

  gulp.watch(['app/**/*.html'], reload);
  gulp.watch([
    'resources/FieloPrp_Salesforce/styles/**/*.{scss,css}'
    ], [
    'css', reload ]);
  gulp.watch([
    'resources/FieloPrp_Salesforce/scripts/**/*.js'
    ], [
    'js', reload ]);
});

// Watch
gulp.task('watch', () => {
  gulp.watch(platformSalesforceCssSources, ['css']);
  gulp.watch(platformSalesforceJsSources, ['js']);
});


// Javascript documentation
gulp.task('doc', ['cleanDoc'], () => {
  gulp.src([
    'resources/FieloPrp_Salesforce/scripts/'    ]
    )
    .pipe(shell(
      [
        './node_modules/.bin/jsdoc <%=(file.path)%> --recurse --private' +
        ' --template node_modules/jsdoc/templates/default' +
        ' --destination docs'
      ],
      {verbose: true})
    );
});

// JavaScript Linter
gulp.task('lint', () =>
  gulp.src(platformSalesforceJsSources)
  .pipe($.eslint())
  .pipe($.eslint.format())
);

// Clean Docs
gulp.task('cleanDoc', () => del([
  'docs/**',
  '!docs'
], {dot: true}));

// Clean Static Resource
gulp.task('clean', () => del([
  '../resource-bundles/FieloPrp_Salesforce.resource/**',
  '!../resource-bundles/FieloPrp_Salesforce.resource',
], {
  dot: true,
  force: true
}));

// Build production site files
gulp.task('build', ['clean'], cb => {
  runSequence(
    'css', 'js', // 'doc',
    cb
 );
});