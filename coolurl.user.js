// ==UserScript==
// @name         链接重定向
// @namespace    sgcell
// @version      2.4
// @description  自动跳过中转页面，支持：酷安、知乎、简书、CSDN
// @author       sgcell@github
// @license      MIT
// @homepageURL  sgcell.github.io/via/
// @match        *www.coolapk.com/link*
// @match        *://link.zhihu.com/*
// @match        *www.jianshu.com/go-wild*
// @match        *://link.csdn.net/*
// @run-at       document-start
// ==/UserScript==
(function () {
 'use strict';
 let n = window.location.href.match(/(?<=url=|target=)https?(?::|%3A)(?:\/\/|%2F%2F)[^&]+/i);
 if (n) {
  document.body.innerHTML = '跳转中…';
  window.location.replace(decodeURIComponent(n[0]));
 }
})();
