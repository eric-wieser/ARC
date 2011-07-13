<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cfg="http://tempuri.org/config"
	exclude-result-prefixes="cfg">
	
	<xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
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
		<tags>
			<tag name="software" short="so"/>
			<tag name="electronics" short="el" />
			<tag name="mechanics" short="me" />
		</tags>
	</config>
	
	<xsl:variable name="config" select="document('')/*/cfg:config" />
	
	<xsl:template match="/pap">
		<!--<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>-->
		<html>
			<head>
				<title>PAP</title>
				<link rel="stylesheet" type="text/css" href="PAP.css" />
				<link rel="stylesheet" type="text/css" href="style.css" />
				<link href='http://fonts.googleapis.com/css?family=Terminal+Dosis+Light|Ubuntu:300|Ubuntu:300italic' rel='stylesheet' type='text/css' />
				<meta http-equiv="x-ua-compatible" content="IE=edge" />
			</head>
			<body>
				<h1><span>PAP - <xsl:value-of select="author"/></span></h1>
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
		<xsl:variable name="label" select="$config/cfg:months/cfg:month[@id = $m]/@name" />
		<section class="month" id="{$y}-{$m}">
			<h2 class="name">
				<xsl:value-of select="$label"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$y"/>
			</h2>
			<xsl:apply-templates mode="single" select="key('kEntryByMonth', $ym)">
				<xsl:sort select="date" />
			</xsl:apply-templates>
		</section>
	</xsl:template>
	
	<xsl:template match="entry" mode="single">
		<xsl:variable name="d" select="substring(date,1,2)" />
		<xsl:variable name="m" select="substring(date,4,2)" />
		<xsl:variable name="y" select="substring(date,7,4)" />
		<div class="entry" id="{$y}-{$m}-{$d}">
			<div class="date"><xsl:value-of select="$d"/></div>
			<ul class="tags"><xsl:apply-templates select="@tags" /></ul>
			<div class="content">
				<ul>
					<xsl:apply-templates select="work"/>
				</ul>
				<xsl:if test="todo">
					<div class="todo">
						<span class="subheading">Todo:</span>
						<xsl:copy-of select="todo/node()" />
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="work">
		<li>
			<div class="work">
				<xsl:if test="@commit">
					<a class="github" href="https://github.com/eric-wieser/Robocup-Junior-Soccer-2011/commit/{@commit}" title="View the code on github!" target="_blank">Commit</a>
				</xsl:if>
				<xsl:copy-of select="description/node()" />
			</div>
			<div class="purpose">
				<xsl:copy-of select="purpose/node()" />
			</div>
		</li>
	</xsl:template>

	<xsl:template match="@tags">
		<xsl:variable name="current" select="." />
		<xsl:for-each select="$config/cfg:tags/cfg:tag">
			<xsl:if test="contains($current, @name)">
				<li class="{@name}" title="{@name}"><xsl:value-of select="@name" /></li>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>