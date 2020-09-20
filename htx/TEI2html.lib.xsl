<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Jakob Sonnberger
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: HTML representation of TEI-transcripts: Templates
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://gams.uni-graz.at/o:htx/" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/"
    xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:lido="http://www.lido-schema.org"
    xmlns:bibtex="http://bibtexml.sf.net/" exclude-result-prefixes="#all">

    <!--DIVs=========================================================================-->

    <xsl:template match="t:div[contains(@ana, 'h_area')]">

        <xsl:variable name="data-place">
            <xsl:choose>
                <xsl:when test="t:head[1]/t:placeName/t:choice">
                    <xsl:value-of select="normalize-space(t:head[1]/t:placeName/t:choice/t:reg)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(t:head[1])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div id="{@xml:id}" class="place" data-place="{$data-place}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--h_ch-->
    <xsl:template match="t:div[contains(@ana, 'h_ch')]">
        <div id="{@xml:id}" class="status" data-status="chargeable">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--h_nc-->
    <xsl:template match="t:div[contains(@ana, 'h_nc')] | t:body[contains(@ana, 'h:nc')]">
        <div id="{@xml:id}" class="status" data-status="not chargeable">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--    <!-\-Reason for exemption-\->
    <xsl:template match="t:div[contains(@ana, 'h_Reason-for-exemption')]">
        <div id="{@xml:id}" class="status" data-status="not chargeable">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-\-No goods-\->
    <xsl:template match="t:div[contains(@ana, 'h_No-goods-to-take')]">
        <div id="{@xml:id}" class="status" data-status="chargeable">
            <xsl:apply-templates/>
        </div>
    </xsl:template>-->

    <!--Omitted by Poverty-->
    <xsl:template match="t:div[contains(@ana, 'h_Omitted-by-poverty')]">
        <div id="{@xml:id}" class="status" data-status="not chargeable">
            <p id="{@xml:id}" class="head">
                <span class="text">
                    <xsl:value-of select="t:head"/>
                </span>
                <xsl:apply-templates select="t:p/t:measure"/>
            </p>
        </div>
    </xsl:template>

    <!--source-->
    <xsl:template match="t:div[@source]">
        <xsl:variable name="anchor-source" select="substring-after(./@source, '#')"/>
        <xsl:variable name="reg-source" select="//t:sourceDesc/t:msDesc[@xml:id = $anchor-source]"/>
        <div id="{@xml:id}" class="source">
            <p>
                <span class="oi oi-comment-square" data-toggle="tooltip"
                    title="The following entries are supplied by: {$reg-source}">
                    <xsl:text> </xsl:text>
                </span>
            </p>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="t:p[@source]">
        <xsl:variable name="anchor-source" select="substring-after(./@source, '#')"/>
        <xsl:variable name="reg-source" select="//t:sourceDesc/t:msDesc[@xml:id = $anchor-source]"/>
        <p id="{@xml:id}" class="source">
            <xsl:apply-templates/>
            <span class="oi oi-comment-square" data-toggle="tooltip"
                title="Supplied by: {$reg-source}">
                <xsl:text> </xsl:text>
            </span>
        </p>
    </xsl:template>

    <xsl:template match="t:div" priority="-2">
        <div id="{@xml:id}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--Heads=========================================================================-->

    <xsl:template match="t:teiHeader">
        <h1>
            <xsl:value-of select="t:fileDesc/t:titleStmt/t:title"/>
        </h1>
    </xsl:template>

    <xsl:template match="t:body/t:head">
        <h2 class="head">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <xsl:template match="t:div[contains(@ana, 'h_area')]/t:head">
        <xsl:variable name="level"
            select="count(ancestor-or-self::t:div[contains(@ana, 'h_area')]) + 2"/>
        <xsl:variable name="placeType" select=".//t:placeName[1]/@type"/>

        <xsl:element name="h{$level}">
            <xsl:attribute name="id" select="@xml:id"/>
            <xsl:attribute name="class">
                <xsl:text>head</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
            <xsl:if
                test="not(parent::t:div[contains(@ana, 'h_area')]/t:div[contains(@ana, 'h_area')])">
                <input class="cb_head form-check-input" type="checkbox" disabled="true"
                    title="select {$placeType} for databasekt"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="t:div[contains(@ana, 'h_hc') or contains(@ana, 'h_nc') or contains(@ana, 'h_ad')]/t:head">
        <h6 class="head">
            <xsl:apply-templates/>
        </h6>
    </xsl:template>

    <!--Nr. hearths head-->

    <xsl:template match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]">
        <p class="h_Hearths-Column-Heading">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template
        match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]/t:seg[contains(@rend, 'h_all')]">
        <span style="position:absolute; right:250px">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template
        match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]/t:seg[contains(@rend, 'h_walled-up')]">
        <span style="position:absolute; right:150px">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template
        match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]/t:seg[contains(@rend, 'h_new')]">
        <span style="position:absolute; right:50px">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template
        match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]/t:seg[contains(@rend, 'h_paid')]">
        <span style="position:absolute; right:50px">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template
        match="t:p[contains(@ana, 'h_Hearths-Column-Heading')]/t:seg[contains(@rend, 'h_unpaid')]">
        <span style="position:absolute; right:150px">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--orig/reg-->
    <xsl:template match="t:choice[t:reg and t:orig]">
        <span data-toggle="tooltip" title="{t:reg}">
            <xsl:apply-templates select="t:orig"/>
        </span>
    </xsl:template>

    <xsl:template match="t:p[@ana = 'h_tpDisch']">
        <h6>
            <xsl:apply-templates/>
        </h6>
    </xsl:template>

    <xsl:template match="t:p[@ana = 'h_tpDisch']">
        <h6>
            <xsl:apply-templates/>
        </h6>
    </xsl:template>



    <!--Tax entry ==========================================================-->

    <xsl:template match="t:p[contains(@ana, 'h_e')]">

        <p id="{@xml:id}" xml:id="{concat(substring-after($teipid, '.'), '#', @xml:id)}">
            <span class="text">
                <xsl:apply-templates select="text() | *[name() != 'measure']"/>
                <xsl:if test="t:persName/@ref and not(t:persName/text())">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </span>
            <xsl:apply-templates select="t:measure"/>
            <input class="cb form-check-input" type="checkbox" disabled="true"
                title="select entry for databasekt"/>
        </p>
    </xsl:template>

    <!--measure ==========================================================-->

    <xsl:template match="t:measure">
        <xsl:choose>
            <xsl:when test="contains(@ana, 'h_all')">
                <span class="hearths" data-n="{h:quantity(.)}"
                    style="position:absolute; right:250px">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="contains(@ana, 'h_walled-up')">
                <span style="position:absolute; right:150px" data-toggle="tooltip" title="walled up">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="contains(@ana, 'h_new')">
                <span style="position:absolute; right:50px" data-toggle="tooltip" title="new">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="contains(@ana, 'h_paid')">
                <span style="position:absolute; right:50px" data-toggle="tooltip" title="paid"
                    class="hearths" data-n="{h:quantity(.)}">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="contains(@ana, 'h_unpaid')">
                <span style="position:absolute; right:150px" data-toggle="tooltip" title="unpaid"
                    class="hearths" data-n="{h:quantity(.)}">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="hearths" data-n="{h:quantity(.)}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Tax sum entry ==========================================================-->

    <xsl:template match="t:p[@ana = 'h_total']">
        <hr/>
        <p class="{@ana}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--Non-taxation entries ======================================================-->

    <xsl:template match="t:body//t:p" priority="-1">
        <p id="{@xml:id}" xml:id="{concat(substring-after($teipid, '.'), '#', @xml:id)}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--Notes Tooltip=======================================================-->

    <xsl:template match="t:note">
        <span class="oi oi-comment-square" data-toggle="tooltip" title="{normalize-space(.)}">
            <xsl:text> </xsl:text>
        </span>
    </xsl:template>

    <!--Damage Tooltip=======================================================-->

    <xsl:template match="t:damage">
        <span class="edit" data-toggle="tooltip"
            title="damage{if (@agent) then (' (', @agent, ')') else ()}">
            <!--Damage in eckigen Klammern-->
            <xsl:text>&#91;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#93;</xsl:text>
        </span>
    </xsl:template>

    <!--sic! Tooltip=======================================================-->

    <xsl:template match="t:sic">
        <span class="edit" data-toggle="tooltip" title="sic!">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--Unclear Tooltip=======================================================-->

    <xsl:template match="t:unclear[not(parent::t:choice)]">
        <span class="edit" data-toggle="tooltip" title="unclear">
            <!--angestelltes [?]-->
            <xsl:apply-templates/>
            <xsl:text>&#91;&#63;&#93;</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="t:choice/t:unclear[1]">
        <span class="edit" data-toggle="tooltip" title="or '{following-sibling::t:unclear/text()}'">
            <!--angestelltes [?]-->
            <xsl:apply-templates/>
            <xsl:text>&#91;&#63;&#93;</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="t:choice/t:unclear[2]"/>

    <!--Supplied Tooltip=======================================================-->

    <xsl:template match="t:supplied">
        <span class="edit" data-toggle="tooltip"
            title="supplied{if (@source) then (' (', @source, ')') else ()}">
            <!--Supplied in eckigen Klammern-->
            <xsl:text>&#91;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#93;</xsl:text>
        </span>
    </xsl:template>

    <!--Extended Tooltip=======================================================-->

    <xsl:template match="t:ex">
        <span class="edit" data-toggle="tooltip" title="abbreviation">
            <!--Extentions in runden Klammern-->
            <xsl:text>&#40;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#41;</xsl:text>
        </span>
    </xsl:template>

    <!--Deletion Tooltip=======================================================-->

    <xsl:template match="t:del">
        <span class="edit del" data-toggle="tooltip" title="deletion">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--Addition Tooltip=======================================================-->

    <xsl:template match="t:add">
        <xsl:variable name="anchor-hand" select="substring-after(./@hand, '#')"/>
        <xsl:variable name="reg-hand" select="//t:handNote[@xml:id = $anchor-hand]"/>
        <span class="edit" data-toggle="tooltip"
            title="added{if (@hand) then (concat(' (', $reg-hand, ')')) else ()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <!--Correction Tooltip=======================================================-->

    <xsl:template match="t:corr">
        <xsl:variable name="anchor-hand" select="substring-after(./@hand, '#')"/>
        <xsl:variable name="reg-hand" select="//t:handNote[@xml:id = $anchor-hand]"/>
        <span class="edit" data-toggle="tooltip"
            title="correction{if (@hand) then (concat(' (', $reg-hand, ')')) else ()}">
            <!--Damage in eckigen Klammern-->
            <xsl:text>&#91;</xsl:text>
            <xsl:apply-templates/>
            <!--Damage in eckigen Klammern-->
            <xsl:text>&#93;</xsl:text>
        </span>
    </xsl:template>


    <!--Gap Tooltip=======================================================-->

    <xsl:template match="t:gap">
        <xsl:choose>
            <xsl:when test="ancestor::t:p">
                <span class="edit" data-toggle="tooltip"
                    title="gap{if (@reason) then (' (', @reason, ')') else ()}">&#91; ...
                    &#93;</span>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <span class="edit" data-toggle="tooltip"
                        title="gap{if (@reason) then (' (', @reason, ')') else ()}">&#91; ...
                        &#93;</span>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Pagebreaks, Columbreaks===========================================================-->

    <xsl:template match="t:pb | t:cb">

        <xsl:choose>
            <xsl:when test="preceding-sibling::t:row">
                <tr>
                    <td colspan="20">
                        <xsl:call-template name="newpbcb"/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="newpbcb"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="newpbcb">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="ends-with(current()/name(), 'cb')">
                    <xsl:text>column</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>page</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <p class="edit">
            <!--pb in eckigen Klammern-->
            <xsl:text>&#91;</xsl:text>
            <xsl:choose>
                <xsl:when test="@n">
                    <xsl:value-of select="@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>new </xsl:text>
                    <xsl:value-of select="$type"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#93;</xsl:text>
        </p>
    </xsl:template>

    <!--form words===========================================================-->

    <xsl:template match="t:fw">
        <h4>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>

    <!--tables===========================================================-->

    <xsl:template match="t:table">
        <table id="{@xml:id}" class="table table-borderless table-hover">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="t:row[contains(@role, 'label')]">
        <tr class="label">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="t:row[contains(@role, 'total')]">
        <tr class="total">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="t:row" priority="-1">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="t:row[contains(@role, 'label')]/t:cell">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>

    <xsl:template match="t:cell[contains(@role, 'label')]" priority="-1">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>

    <xsl:template match="t:cell" priority="-2">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <!--generic elements=====================================================-->
    <xsl:template match="t:ref">
        <a href="{@target}">
            <xsl:if test="contains(@rend, '_blank')">
                <xsl:attribute name="target">
                    <xsl:text>_blank</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:if>
        </a>
    </xsl:template>
    <xsl:template match="t:code">
        <span class="code">
            <xsl:apply-templates select="@* | node()"/>
        </span>
    </xsl:template>
    <xsl:template match="t:p//t:bibl[not(@corresp)]">
        <span class="bibl">
            <xsl:apply-templates select="@* | node()"/>
        </span>
    </xsl:template>
    <xsl:template match="t:p//t:bibl[@corresp]">
        <a class="bibl" href="{@corresp}">
            <xsl:apply-templates select="@* | node()"/>
        </a>
    </xsl:template>
    <xsl:template match="t:listBibl">
        <div id="{@xml:id}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="t:head"/>
            <ul class="listBibl">
                <xsl:apply-templates select="@* | t:bibl"/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="t:listBibl/t:bibl">
        <li id="{@xml:id}" class="bibl">
            <xsl:apply-templates select="@* | node()"/>
        </li>
    </xsl:template>
    <xsl:template match="t:hi" priority="-2">
        <span style="{@rend}">
            <xsl:apply-templates select="@* | node()"/>
        </span>
    </xsl:template>
    <xsl:template match="t:head" priority="-2">
        <xsl:variable name="level" select="count(ancestor::t:div[t:head]) + 2"/>
        <xsl:element name="h{$level}">
            <xsl:attribute name="class">
                <xsl:text>head</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <!--fallback templates==================================================== -->
    <xsl:template match="@*" priority="-2"/>

    <!--functions=========================================================== -->
    <xsl:function name="h:quantity">
        <xsl:param name="measure-element"/>
        <xsl:choose>
            <xsl:when test="$measure-element/@quantity">
                <xsl:value-of select="$measure-element/@quantity"/>
            </xsl:when>
            <xsl:when test="$measure-element/number(string()) != 0">
                <xsl:value-of select="$measure-element/number(string())"/>
            </xsl:when>
            <xsl:when
                test="matches($measure-element/normalize-space(string()), '^[IiVvXxLlJjMmCcDd]+$')">
                <xsl:value-of select="bk:roman2int($measure-element/normalize-space(string()))"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
