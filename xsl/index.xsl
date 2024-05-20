<?xml version="1.0" encoding="UTF-8"?>
<!--
MIT License

Copyright (c) 2024 Zerocracy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:import href="awards.xsl"/>
  <xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:param name="version"/>
  <xsl:param name="source"/>
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>zerocracy</title>
        <meta charset="UTF-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <link rel="icon" href="https://www.zerocracy.com/logo.svg" type="image/svg"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js">
          <xsl:text> </xsl:text>
        </script>
        <style>
          td, th { font-family: monospace; font-size: 18px; line-height: 1em; }
          td.top { vertical-align: middle; }
          .num { text-align: right; }
          .left { border-bottom: 0; }
          section { width: auto; }
          header { text-align: center; }
          footer { text-align: center; font-size: 0.8em; line-height: 1.2em; color: gray; }
          article { border: 0; }
          td.avatar { vertical-align: middle; text-align: center; }
          td.avatar img { width: 1.5em; height: 1.5em; vertical-align: middle; }
          .subtitle { font-size: 0.8em; line-height: 1em; color: gray; }
          .sorter { cursor: pointer; }
        </style>
      </head>
      <body>
        <section>
          <header>
            <p>
              <a href="">
                <img src="https://www.zerocracy.com/logo.svg" style="width:64px" alt="Zerocracy"/>
              </a>
            </p>
          </header>
          <article>
            <xsl:apply-templates select="/" mode="awards"/>
          </article>
          <footer>
            <p>
              <xsl:text>The page was generated by the </xsl:text>
              <a href="https://github.com/zerocracy/pages-action">
                <xsl:text>pages-action</xsl:text>
              </a>
              <xsl:text> plugin (</xsl:text>
              <xsl:value-of select="$version"/>
              <xsl:text>) on </xsl:text>
              <xsl:value-of select="fb/@dob"/>
              <br/>
              <xsl:text>FB: </xsl:text>
              <xsl:value-of select="count(fb/f)"/>
              <xsl:text> facts, </xsl:text>
              <xsl:value-of select="fb/@size"/>
              <xsl:text> bytes, version </xsl:text>
              <xsl:value-of select="fb/@version"/>
              <xsl:text>.</xsl:text>
              <br/>
              <xsl:text>The XML with all the data </xsl:text>
              <a href="{$source}">
                <xsl:text>is here</xsl:text>
              </a>
              <xsl:if test="fb/@size > 100000">
                <xsl:text> (it's big)</xsl:text>
              </xsl:if>
              <xsl:text>.</xsl:text>
            </p>
          </footer>
        </section>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
