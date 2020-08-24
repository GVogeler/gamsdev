<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Jakob Sonnberger
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: Indexing objects (Transcripts and Database-Representations)
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="#all">
    <!--<xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="no"/>-->
    <xsl:include href="htx-static.xsl"/>
    <xsl:variable name="taxations-total">1234567890</xsl:variable>
        <!-- select="doc('htts://gams.uni-graz.at/archive/objects/query:htx.taxations-total/methods/sdef:Query/getXML')//s:taxations"/> -->
    <xsl:template name="content">
        <section class="row">
            <article class="col-md-12 records">
                <div class="card">
                    <div class="card-body">
                        <div class="alert alert-dismissible" role="alert">Hearth Tax Digital
                            currently contains <xsl:value-of select="$taxations-total"/>
                                entries.<button type="button" class="close" data-dismiss="alert"
                                aria-label="Close">
                                <span aria-hidden="true" class="oi oi-x"/>
                            </button>
                        </div>
                        <!--TEI objects-->
                        <details open="open">
                            <summary>Transcripts</summary>
                            <ul class="list-group">
                                <xsl:for-each
                                    select="s:sparql/s:results/s:result[s:model/@uri = 'info:fedora/cm:TEI']">
                                    <xsl:sort select="./s:title"/>
                                    <li class="list-group-item">
                                        <span class="results">
                                            <a href="{concat('/', ./s:identifier)}">
                                                <xsl:value-of select="./s:title"/>
                                            </a>
                                        </span>
                                        <br/>
                                        <!--<span class="permalink">
                                        <a href="{concat('/', ./s:identifier)}">
                                            <xsl:value-of
                                                select="concat('Permalink: ', $server, '/', ./s:identifier)"
                                            />
                                        </a>
                                    </span>-->

                                        <!--Icons-->
                                        <span class="icon-span">
                                            <!--TEI-->
                                            <a target="_blank"
                                                href="{concat('/', ./s:identifier, '/TEI_SOURCE')}"
                                                download="{concat(substring-after(./s:identifier, 'o:htx.'), '_TEI.xml')}">
                                                <img src="/templates/img/tei_icon.jpg" height="18"
                                                  alt="TEI Download" title="TEI Download"/>
                                            </a>
                                            <!--<!-\-Excel-\->
                                        <a
                                            href="{concat('/archive/objects/', s:identifier, '/methods/sdef:TEI/getHSSF')}">
                                            <img
                                                src="{concat($gamsdev, '/htx/img/excel_icon.png')}"
                                                height="18" alt="XLS Download" title="XLS Download"
                                            />
                                        </a>-->
                                            <!--RDF-->
                                            <a target="_blank"
                                                href="{concat('/', ./s:identifier, '/RDF')}"
                                                download="{concat(substring-after(./s:identifier, 'o:htx.'), '_RDF.xml')}">
                                                <img src="/templates/img/RDF_icon.png" height="18"
                                                  alt="RDF Download" title="RDF Download"/>
                                            </a>
                                        </span>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </details>

                        <!--Ontology objects-->
                        <details>
                            <summary>Returns in Database format</summary>
                            <ul class="list-group">
                                <xsl:for-each
                                    select="s:sparql/s:results/s:result[s:model/@uri = 'info:fedora/cm:Ontology']">
                                    <xsl:sort
                                        select="replace(./s:title, 'book (\d)(\D|$)', 'book 0$1$2')"/>
                                    <li class="list-group-item">
                                        <span class="results">
                                            <a href="{concat('/', ./s:identifier)}">
                                                <xsl:value-of select="./s:title"/>
                                            </a>
                                        </span>
                                        <!-- <br/>
                                    <span class="permalink">
                                        <a href="{concat('/', ./s:identifier)}">
                                            <xsl:value-of
                                                select="concat('Permalink: ', $server, '/', ./s:identifier)"
                                            />
                                        </a>
                                    </span>-->

                                        <!--Icons-->
                                        <span class="icon-span">
                                            <!--RDF-->
                                            <a target="_blank" class="icons"
                                                href="{concat('/', ./s:identifier, '/ONTOLOGY')}"
                                                download="{concat(substring-after(./s:identifier, 'o:htx.'), '_RDF.xml')}">
                                                <img src="/templates/img/RDF_icon.png" height="18"
                                                  alt="RDF Download" title="RDF Download"/>
                                            </a>
                                        </span>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </details>
                    </div>
                </div>
            </article>
        </section>
    </xsl:template>

    <!--  <xsl:template match="s:result[s:model/@uri = '']">

        <li class="list-group-item">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('/', ./s:identifier)"/>
                </xsl:attribute>
            </a>

            <span class="results">
                <a>
                    <xsl:attribute name="href">

                        <xsl:value-of select="concat('/', ./s:identifier)"/>

                    </xsl:attribute>


                    <xsl:value-of select="./s:title"/>

                </a>
            </span>
            <br/>
            <span class="permalink">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('/', ./s:identifier)"/>

                    </xsl:attribute>
                    <xsl:value-of select="concat('Permalink: ', $server, '/', ./s:identifier)"/>

                </a>

            </span>

            <!-\-Icons-\->
            <span class="icon-span">

                <!-\-TEI-\->
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('/', ./s:identifier, '/TEI_SOURCE')"/>

                    </xsl:attribute>
                    <img src="htx-context.xsl-Dateien/tei_icon.jpg" alt="TEI Download"
                        title="TEI Download" height="18"/>
                </a>

                <!-\-RDF-\->
                <a target="_blank" class="icons">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('/', ./s:identifier, '/RDF')"/>
                    </xsl:attribute>
                    <img src="htx-context.xsl-Dateien/RDF_icon.png" alt="RDF Download"
                        title="RDF Download" height="18"/>
                </a>
            </span>
        </li>
    </xsl:template>-->

    <!--<xsl:template match="s:result[s:model/@uri = 'info:fedora/cm:Ontology']">
        <li>
            <a
                href="http://glossa.uni-graz.at/query:htx.bybook?params=%241%7C%3C{s:identifier}%3E">
                <xsl:value-of select="./s:title"/>
            </a>
            <a target="_blank" class="icons"
                href="http://glossa.uni-graz.at/%7Bs:identifier%7D'/RDF')">
                <img src="htx-context.xsl-Dateien/RDF_icon.png" alt="RDF Download"
                    title="RDF Download" height="18"/>
            </a>
        </li>
    </xsl:template>-->
</xsl:stylesheet>
