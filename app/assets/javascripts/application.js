// DO NOT REQUIRE jQuery or jQuery-ujs in this file!
// DO NOT REQUIRE TREE!

// CRITICAL that generated/vendor-bundle must be BEFORE bootstrap-sprockets and turbolinks
// since it is exposing jQuery and jQuery-ujs

//= require generated/vendor-bundle
//= require generated/app-bundle

# application specific content, must require the following js
//= require core_application
//= require initialization
//= require_tree ./vendor
//= require_tree ./public
//= require bz_highcharts

# application specific requirement
//= require expensable
