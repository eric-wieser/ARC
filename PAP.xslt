<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cfg="http://tempuri.org/config"
  exclude-result-prefixes="cfg">
  
  <xsl:output method="html" encoding="utf-8" indent="yes" />

  <!-- index news by their "yyyy-mm" value (first 7 chars) -->
  <xsl:key
    name="kEntryByMonth"
    match="entry"
    use="concat(substring(date,7,4), substring(date,4,2))"/>

  <!-- translation table (month number to name) -->
  <config xmlns="http://tempuri.org/config">
    <months>
      <month id="01" name="January" />
      <month id="02" name="February" />
      <month id="03" name="March" />
      <month id="04" name="April" />
      <month id="05" name="May" />
      <month id="06" name="June" />
      <month id="07" name="July" />
      <month id="08" name="August" />
      <month id="09" name="September" />
      <month id="10" name="October" />
      <month id="11" name="November" />
      <month id="12" name="December" />
    </months>
  </config>
  
  <xsl:template match="/pap">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
	  <html>
		  <head>
			  <title>PAP</title>
        <link rel="stylesheet" type="text/css" href="PAP.css" />
        <link href='http://fonts.googleapis.com/css?family=Terminal+Dosis+Light|Ubuntu:300|Ubuntu:300italic' rel='stylesheet' type='text/css' />
        <meta http-equiv="x-ua-compatible" content="IE=edge" />
		  </head>
		  <body>
			  <h1>PAP - <xsl:value-of select="author"/></h1>
        <div id="wrapper">
          <xsl:apply-templates mode="month" select="entry[ generate-id() = generate-id(key('kEntryByMonth', concat(substring(date,7,4), substring(date,4,2)))[1]) ]">
            <xsl:sort select="substring(date,7,4)"/>
            <xsl:sort select="substring(date,4,2)"/>
            <xsl:sort select="substring(date,1,2)"/>
          </xsl:apply-templates>
        </div>
		  </body>
	  </html>
  </xsl:template>

  <xsl:template match="entry" mode="month">
    <xsl:variable name="m" select="substring(date,4,2)" />
    <xsl:variable name="y" select="substring(date,7,4)" />
    <xsl:variable name="ym" select="concat($y, $m)" />
    <xsl:variable name="label" select="document('')/*/cfg:config/cfg:months/cfg:month[@id = $m]/@name" />
    <div class="month">
      <span class="name">
        <xsl:value-of select="$label"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$y"/>
      </span>
      <xsl:apply-templates mode="single" select="key('kEntryByMonth', $ym)">
        <xsl:sort select="date" />
      </xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="entry" mode="single">
	  <div class="entry">
		  <div class="date"><xsl:value-of select="substring(date,1,2)"/></div>
      <div class="content">
        <dl>
          <xsl:apply-templates select="work"/>
        </dl>
        <xsl:if test="todo">
          <div class="todo">
            <span class="subheading">Todo:</span>
            <xsl:value-of select="todo"/>
          </div>
        </xsl:if>
      </div>
	  </div>
  </xsl:template>

  <xsl:template match="work">
    <dt>
      <xsl:if test="@commit">
        <a class="github" href="https://github.com/eric-wieser/Robocup-Junior-Soccer-2011/commit/{@commit}" title="View the code on github!">Commit</a>
      </xsl:if>
      <xsl:value-of select="description"/>
    </dt>
    <xsl:if test="purpose">
    <dd>
      <xsl:value-of select="purpose"/>
    </dd>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>