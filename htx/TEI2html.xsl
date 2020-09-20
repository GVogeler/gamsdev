<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Jakob Sonnberger
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: HTML representation of TEI-transcripts
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://gams.uni-graz.at/o:htx/" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/"
    xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:lido="http://www.lido-schema.org"
    xmlns:bibtex="http://bibtexml.sf.net/" exclude-result-prefixes="#all">
    <xsl:include href="htx-static.xsl"/>
    <xsl:include href="htx-TEI-area_navigator.xsl"/>
    <xsl:include href="conversions.xsl"/>
    <xsl:include href="TEI2html.lib.xsl"/>
    
    <!--Basic Site Structure==========================================================-->
    <xsl:template name="content">
        <section class="row">
            <xsl:call-template name="area_navigator"/>

            <article class="col-md-9" id="transcript"
                data-book="{/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier}" data-taxationDate="{(//t:date[@ana='h_taxationDate'])[1]/@when}">
                <div class="card">
                    <div class="card-body">
                        <xsl:apply-templates/>
                    </div>
                </div>
            </article>
        </section>
    </xsl:template>

</xsl:stylesheet>
