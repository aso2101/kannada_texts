<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:variable name="language">
    <xsl:value-of select="//tei:body/@xml:lang"/>
  </xsl:variable>
  <xsl:variable name="abbrev">
    <xsl:value-of select="//tei:TEI/@n"/>
  </xsl:variable>
  <xsl:variable name="cRefPattern">
    <xsl:value-of select="//tei:cRefPattern[1]/@matchPattern"/>
  </xsl:variable>


  <!-- BODY !-->
  <xsl:template match="tei:body">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- teiHeader !-->
  <xsl:template match="tei:teiHeader"/>
  <!-- titleStmt !-->
  <xsl:template match="tei:titleStmt">
    <xsl:element name="h1">
      <xsl:attribute name="id">teiHeading</xsl:attribute>
      <xsl:element name="span">
	<xsl:attribute name="class">translit</xsl:attribute>
	<xsl:if test="tei:title[1]/@xml:lang">
	  <xsl:attribute name="lang">
	    <xsl:value-of select="tei:title[1]/@xml:lang"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:attribute name="id">worktitle</xsl:attribute>
	<xsl:apply-templates select="tei:title[1]"/>
      </xsl:element>
      <xsl:if test="tei:author">
	<xsl:element name="span">
	  <xsl:attribute name="class">translit</xsl:attribute>
	  <xsl:if test="tei:author[1]/@xml:lang">
	    <xsl:attribute name="lang">
	      <xsl:value-of select="tei:author[1]/@xml:lang"/>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:attribute name="id">authorname</xsl:attribute>
	  <xsl:apply-templates select="tei:author[1]"/>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!-- abbreviations !-->
  <xsl:template match="tei:expan"/>
  <xsl:template match="tei:abbr">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- additions by previous scribes/editors !-->
  <xsl:template match="tei:add">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- ab elements !-->
  <xsl:template match="tei:ab[@type='sūtra']">
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="../@n">
      <xsl:text> // </xsl:text>
      <xsl:call-template name="make-abbrev">
	<xsl:with-param name="title" select="$abbrev"/>
	<xsl:with-param name="chapter" select="./ancestor::tei:div[@type='section'][@n][1]/@n"/>
	<xsl:with-param name="verse" select="./ancestor::tei:div[@type='sūtra'][@n][1]/@n"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:text>

</xsl:text>
  </xsl:template>

  <!-- section divisions !-->
  <xsl:template match="tei:body/tei:div">
    <xsl:apply-templates/>
    <xsl:text>
</xsl:text>
<xsl:if test="count(following-sibling::tei:div) > 0">
  <xsl:text>
---------------------------------------------------------------------
</xsl:text>
</xsl:if>
  </xsl:template>

  <!-- headers !-->
  <xsl:template match="tei:head[not(@type='toc')]">
    <xsl:text>[</xsl:text>
      <xsl:if test="parent::tei:div[@type='section'][@n]">
	<xsl:value-of select="parent::tei:div[@type='section']/@n"/>
	<xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:text>]

</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:head[@type='toc']"/>

  <!-- paragraphs !-->
  <xsl:template match="tei:p">
    <xsl:apply-templates/>
    <xsl:text>
</xsl:text>
    <xsl:if test="not(./following-sibling::tei:list[@type='examples'])">
    <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- line breaks !-->
  <xsl:template match="tei:lb[@break='no']">
    <xsl:text>-
</xsl:text>
  </xsl:template>
  <xsl:template match="tei:lb[not(@break='no')]">
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- lists !-->
  <xsl:template match="tei:list[@type='examples']">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:item">
    <xsl:text> - </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- base text !-->
  <xsl:template match="tei:quote[@type='base-text']">
    <xsl:element name="div">
      <xsl:attribute name="class">base-text</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- sentences !-->
  <xsl:template match="tei:s">
    <xsl:variable name="precedingchar">
      <xsl:value-of select="normalize-space(./preceding-sibling::tei:s[1]/text())[last()]"/>
    </xsl:variable>
    <xsl:if test="ends-with($precedingchar,'.') or ends-with($precedingchar,'?')">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="not(ends-with(normalize-space(text()[last()]),'—'))">
      <xsl:if test="not(ends-with(normalize-space(text()[last()]),'.'))">
	<xsl:if test="not(ends-with(normalize-space(text()[last()]),'?'))">
	  <xsl:text>. </xsl:text>
	</xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- trailers !-->
  <xsl:template match="tei:trailer">
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- labels !-->
  <xsl:template match="tei:label">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]
</xsl:text>
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:text>      (- </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)

</xsl:text>
  </xsl:template>

  <!-- verses !-->
  <xsl:template match="tei:lg">
    <xsl:if test="@type = 'sūtra'">
      <xsl:text>SŪTRAṀ </xsl:text>
      <xsl:value-of select="./ancestor::tei:div[@type='sūtra']/@n"/>
      <xsl:text>
</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::tei:ref)">
      <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:l">
    <xsl:apply-templates/>
    <xsl:if test="not(following-sibling::tei:l)">
      <xsl:if test="../@n">
	<xsl:text> // </xsl:text>
	<xsl:call-template name="make-abbrev">
	  <xsl:with-param name="title" select="$abbrev"/>
	  <xsl:with-param name="chapter" select="./ancestor::tei:div[@n][1]/@n"/>
	  <xsl:with-param name="verse" select="./ancestor::tei:lg[@n][1]/@n"/>
	</xsl:call-template>
	<xsl:if test="../@met">
	  <xsl:text> [</xsl:text><xsl:value-of select="../@met"/><xsl:text>]</xsl:text>
	</xsl:if>
      </xsl:if>
    </xsl:if>

    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- quotations
         use quote for block,
	 q for inline
       !-->
  <xsl:template match="tei:quote[not(@type='base-text')]">
    
    <xsl:choose>
      <xsl:when test="not(ancestor::tei:cit)">
	<xsl:element name="div">
	  <xsl:attribute name="class">d-flex flex-grow justify-content-start align-items-start</xsl:attribute>
	  <xsl:element name="div">
	    <xsl:attribute name="class">pt-1</xsl:attribute>
	    <xsl:element name="i">
	      <xsl:attribute name="class">fas fa-quote-left text-muted</xsl:attribute>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="div">
	    <xsl:attribute name="class">quote flex-grow-1</xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="span">
	  <xsl:attribute name="class">quotation translit</xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:cit">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:q">
    <xsl:text>“</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>”</xsl:text>
  </xsl:template>

  <!-- notes !-->
  <xsl:template match="tei:note[not(ancestor::tei:app)]"/>

  <!-- apparatus entries !-->
  <xsl:template match="tei:app">
    <xsl:apply-templates select="tei:lem"/>
  </xsl:template>

  <!-- page numbers !-->
  <xsl:template match="tei:pb"><xsl:text>
[p. </xsl:text>
    <xsl:value-of select="@n"/>
    <xsl:text>]
</xsl:text>
  </xsl:template>

  <!-- titles !-->
  <xsl:template match="tei:title">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <xsl:template name="make-label">
    <xsl:param name="wit"/>
    <xsl:param name="resp"/>
    <xsl:param name="source"/>
    <xsl:variable name="witnesses" select="tokenize($wit,' ')"/>
    <xsl:for-each select="$witnesses">
      <xsl:variable name="symbol">
	<xsl:value-of select="translate(.,'#','')"/>
      </xsl:variable>
      <xsl:variable name="expansion">
	<xsl:value-of select="translate(.,'#','')"/>
      </xsl:variable>
      <xsl:element name="span">
	<xsl:attribute name="class">expansion d-none</xsl:attribute>
	<xsl:attribute name="lang">eng</xsl:attribute>
	<xsl:value-of select="$expansion"/>
      </xsl:element>
      <xsl:element name="a">
	<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
	<xsl:attribute name="class">p-tooltip</xsl:attribute>
	<xsl:attribute name="data-bs-toggle">tooltip</xsl:attribute>
	<xsl:attribute name="data-bs-placement">top</xsl:attribute>
	<xsl:value-of select="$symbol"/><xsl:text> </xsl:text>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="make-abbrev">
    <xsl:param name="title"/>
    <xsl:param name="chapter"/>
    <xsl:param name="verse"/>
    <xsl:value-of select="$title"/>
    <xsl:text>.</xsl:text>
    <xsl:choose>
      <xsl:when test="count(tokenize($cRefPattern,'\.')) = 3">
	<xsl:value-of select="$chapter"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="$verse"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$verse"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
