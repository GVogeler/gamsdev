<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    >
    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:include href="htx-static.xsl"/>
    <xsl:template match="/">
        <html>
            <head>
                <meta encoding="utf-8"/>
                <title><xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/title"/></title>
            </head>
            <body>
                <nav><ul><li>Menu 1</li><li>menu 2</li></ul></nav>
                <main>
                    <xsl:apply-templates select="//text"/>
                </main>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="div">
        <div><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="head">
        <xsl:variable name="level" select="count(ancestor::div[head]) + 1"/>
        <xsl:element name="h{$level}"><xsl:apply-templates/></xsl:element>
    </xsl:template>
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
</xsl:stylesheet>
