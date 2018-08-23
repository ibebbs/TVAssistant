<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="channel">
    <xmltv-channel>
      <xsl:variable name="id" select="@id"/>
      <xsl:attribute name="id">
        <xsl:value-of select="$id"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="display-name"/>
      </xsl:attribute>
      <xsl:attribute name="programCount">
        <xsl:value-of select="count(//programme[@channel=$id])"/>
      </xsl:attribute>
    </xmltv-channel>
  </xsl:template>

  <xsl:template match="number">
    <channel>
      <xsl:variable name="name" select="@channel"/>
      <xsl:variable name="altname">
        <xsl:choose>
          <xsl:when test="contains(@channel, ' +1')">
            <xsl:value-of select="concat(substring-before(@channel, ' +1'),'+1')"/>
          </xsl:when>
          <xsl:otherwise>{!NOMATCH!}</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="name">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
      <xsl:attribute name="altname">
        <xsl:value-of select="$altname"/>
      </xsl:attribute>
      <xsl:attribute name="number">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <matches>
        <xsl:apply-templates select="//channel[display-name=$name]"/>
        <xsl:apply-templates select="//channel[display-name=$altname]"/>
      </matches>
      <alternates>
        <xsl:apply-templates select="//channel[display-name!=$name and starts-with(display-name, $name)]"/>
        <xsl:apply-templates select="//channel[display-name!=$name and starts-with($name, display-name)]"/>
      </alternates>
    </channel>
  </xsl:template>

  <!--<xsl:template match="channel">
    <channel>
      <xsl:variable name="id" select="@id"/>
      <xsl:attribute name="id">
        <xsl:value-of select="$id"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="display-name"/>
      </xsl:attribute>
    </channel>
  </xsl:template>-->

  <xsl:template match="/">
    <channels>
      <xsl:apply-templates select="//number"/>
    </channels>
  </xsl:template>
</xsl:stylesheet>
