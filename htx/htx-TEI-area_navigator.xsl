<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Jakob Sonnberger
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: Adding sidebar with document information and geographical menu to transcripts 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:lido="http://www.lido-schema.org"
    xmlns:bibtex="http://bibtexml.sf.net/" exclude-result-prefixes="#all"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/">

    <xsl:variable name="pid" select="//t:publicationStmt/t:idno[@type = 'PID']"/>

    <xsl:variable name="pid-uri" select="concat($server, '/', $pid)"/>

    <xsl:variable name="handle"
        select="document(concat('/archive/objects/', $pid, '/datastreams/RELS-EXT/content'))//rdf:RDF/rdf:Description/oai:itemID"/>

    <xsl:variable name="lastchange"
        select="/t:TEI/t:teiHeader/t:revisionDesc/t:listChange/t:change[1]/@when"/>
    <xsl:variable name="lastchange_year" select="substring($lastchange, 1, 4)"/>

    <xsl:variable name="principal">
        <xsl:for-each select="(//t:titleStmt/t:principal)">
            <xsl:if test="preceding-sibling::t:principal">
                <xsl:text> and </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="editor">
        <xsl:for-each
            select="(//t:titleStmt/t:respStmt[t:resp = 'editor' or t:name/@xml:id = 'editor']/t:name)">
            <xsl:if test="../preceding-sibling::t:respStmt[t:resp = 'editor']">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="transcriber">
        <xsl:for-each select="(//t:titleStmt/t:respStmt[t:resp = 'transcriber']/t:name)">
            <xsl:if test="../preceding-sibling::t:respStmt[t:resp = 'transcriber']">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="area_navigator">

        <!--infobox-modal-->

        <div class="modal fade" id="infobox_tei" tabindex="-1" role="dialog" aria-hidden="true"
            aria-labelledby="modal-title">
            <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 id="modal_title" class="modal-title">Document details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true" class="oi oi-x"/>
                        </button>
                    </div>
                    <div class="modal-body">

                        <xsl:apply-templates select="//t:fileDesc" mode="infobox_tei"/>

                        <!--Icons-->

                        <a class="infobox_download"
                            download="{concat(substring-after($pid, 'o:htx.'), '_TEI.xml')}"
                            target="_blank">
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('/', $pid, '/TEI_SOURCE')"/>
                            </xsl:attribute>
                            <img src="/templates/img/tei_icon.jpg" height="48" alt="TEI-Document"
                                title="TEI-Document"/>
                        </a>
                        <a class="infobox_download"
                            download="{concat(substring-after($pid, 'o:htx.'), '_RDF.xml')}"
                            target="_blank">
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('/', $pid, '/RDF')"/>
                            </xsl:attribute>
                            <img src="/templates/img/RDF_icon.png" height="36" alt="RDF Download"
                                title="RDF Download"/>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <article class="col-md-3 area_navigator sticky-top d-none d-md-block">
            <div class="card">
                <div class="card-body">
                    <!--infobox-button-->
                    <button type="button" id="infobox_button" class="btn sticky-top"
                        data-target="#infobox_tei" data-toggle="modal">
                        <span class="oi oi-info"/>
                    </button>
                    <xsl:apply-templates
                        select="/t:TEI/t:text/t:body/descendant-or-self::*[matches(@ana, 'h[_:]area')][1]/t:div[contains(@ana, 'h_area')]"
                        mode="area_navigator"/>
                    <!--die div-ebene 'county' wird für die navigation übersprungen-->
                </div>
            </div>
        </article>

    </xsl:template>


    <xsl:template match="t:div[contains(@ana, 'h_area')]" mode="area_navigator">
        <xsl:choose>
            <xsl:when test="t:div[contains(@ana, 'h_area')]">
                <!-- wenn noch eine div@area darunter liegt, bau eine neue details/summery-konstruktion...-->
                <details
                    style="margin-left:{(count(ancestor::t:div[contains(@ana, 'h_area')][not(contains(@type, 'county'))]))*10}px">
                    <summary>
                        <xsl:call-template name="getNav"/>
                    </summary>
                    <xsl:apply-templates select="t:div[contains(@ana, 'h_area')]"
                        mode="area_navigator"/>
                </details>
            </xsl:when>
            <xsl:otherwise>
                <!--...wenn nicht, gib die finale ebene einfach aus-->
                <xsl:call-template name="getNav"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getNav">
        <xsl:choose>
            <!--irgendwo hat ein div keinen Head !!!!!!!!!!!!-->
            <!--A) Wenn head vorhanden, dann...-->
            <xsl:when test="t:head[1]">
                <!-- ...hol dir die xml:id für den link... -->
                <a href="{concat('#', t:head[1]/@xml:id)}">
                    <!-- ...wenn darunter keine area-Ebene mehr liegt, rücke ihn nochmal 10px ein! -->
                    <xsl:if test="not(descendant::t:div[contains(@ana, 'h_area')])">
                        <xsl:attribute name="style">margin-left:<xsl:value-of
                                select="
                                    (count(ancestor::t:div[contains(@ana,
                                    'h_area')][not(contains(@type, 'county'))]) * 10)"
                            />px</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <!-- Wenn es im head/placeName ein choice gibt, nimm den regulierten Namen...-->
                        <xsl:when test="t:head[1]/t:placeName/t:choice">
                            <xsl:value-of
                                select="normalize-space(t:head/t:placeName/t:choice/t:reg)"/>
                        </xsl:when>
                        <!-- ...ansonsten einfach den, der im placeName steht! -->
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(t:head[1])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <br/>
            </xsl:when>
            <!-- B) Wenn kein head, dann '[...]' ausgeben -->
            <xsl:otherwise>
                <xsl:text>[...]</xsl:text>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--infobox templates-->

    <xsl:template match="t:fileDesc" mode="infobox_tei">
        <p>
            <span class="info_label">Title: </span>
            <xsl:value-of select="t:titleStmt/t:title"/>
        </p>
        <p>
            <span class="info_label">Original Document<xsl:if
                    test="count(t:sourceDesc/t:msDesc/t:msIdentifier) gt 1"
                    ><xsl:text>s</xsl:text></xsl:if>: </span>
            <xsl:for-each select="t:sourceDesc/t:msDesc/t:msIdentifier">
                <xsl:if test="position() gt 1">
                    <xsl:text>; </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </p>
        <p>
            <span class="info_label">Transcribed by: </span>
            <xsl:value-of select="$transcriber"/>
        </p>
        <p>
            <span class="info_label">Editor<xsl:if test="(t:titleStmt/t:principal[2])">s</xsl:if>: </span>
            <xsl:value-of select="$principal"/>
        </p>
        <p>
            <span class="info_label">Encoding: </span>
            <xsl:value-of select="t:titleStmt/t:respStmt[t:resp = 'encoder']/t:name"/>
        </p>
        <xsl:if test="t:sourceDesc/t:bibl">
            <p>
                <span class="info_label">Print Edition: </span>
                <a href="https://www.britishrecordsociety.org/hearthtax/" target="_blank">
                    <xsl:value-of select="t:sourceDesc/t:bibl"/>
                </a>
            </p>
        </xsl:if>
        <p>
            <span class="info_label">Recommended citation: </span> Hearth Tax Digital: <xsl:value-of
                select="t:titleStmt/t:title"/>. Ed. by <xsl:value-of select="$editor"/>, digital
            version by <xsl:value-of select="t:titleStmt/t:respStmt[t:resp = 'encoder']/t:name"/>
                (<xsl:value-of select="$lastchange"/>). Graz/London: Zentrum für
            Informationsmodellierung / Roehampton University / British Academy, <xsl:value-of
                select="$lastchange_year"/>. Permalink: <a href="{$pid-uri}"><xsl:value-of
                    select="$pid-uri"/></a><xsl:if test="$handle">, DOI/Handle: <a target="_blank"
                    href="{concat('http://hdl.handle.net/', $handle)}"><xsl:value-of
                        select="$handle"/></a></xsl:if>
        </p>
        <xsl:if test="$lastchange">
            <p>
                <span class="info_label">Latest Revision: </span>
                <xsl:value-of select="$lastchange"/>
            </p>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
