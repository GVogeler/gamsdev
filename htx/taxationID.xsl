<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:h="http://gams.uni-graz.at/o:htx.ontology/"
    xmlns:hx="http://gams.uni-graz.at/context:hearthtax/?mode=odd#"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
<!--
    ******************************
    Sammlung von XSL-Funktionen, die aus TEI-Dateien IDs generieren, die als URIs verwendet werden können (z.B. im toRDF)
    Geschrieben von georg.vogeler@uni-graz.at, Juli 2018-Juli 20
    ****************************
-->
    <xsl:variable name="ontology-server" use-when="starts-with(static-base-uri(),'http')"><xsl:text>http://gams.uni-graz.at</xsl:text></xsl:variable>
    <xsl:variable name="ontology-server" use-when="not(starts-with(static-base-uri(),'http'))"><xsl:text>http://gams.uni-graz.at</xsl:text></xsl:variable>
    <xsl:variable name="global-countyID">
        <!-- Für geographische URIs braucht es manchmal das County als Differenzierungsmerkmal 
            ToDo: CountyID für access2RDF setzen
        -->
        <xsl:choose>
            <xsl:when test="(
                t:*[@type = 'county'
                or contains(@ana, 'h_county')
                or contains(@ana, 'h_levelCounty')]|hx:county)/t:head/t:placeName">
                <xsl:value-of select="h:prepareForURI(
                (t:*[@type = 'county'
                or contains(@ana, 'h_county')
                or contains(@ana, 'h_levelCounty')]|hx:county)/(t:head//t:placeName)[1])"/>
            </xsl:when>
            <xsl:when
                test="
                //t:*[contains(@ana, 'h_county')
                or contains(@ana, 'h_levelCounty')
                or (contains(@ana, 'h_area') and t:head//t:placeName/@type = 'county')]">
                <xsl:value-of
                    select="
                    h:prepareForURI(//t:*[contains(@ana, 'h_county')
                    or contains(@ana, 'h_levelCounty')
                    or contains(@ana, 'h_area')]/(t:head//t:placeName[@type = 'county'])[1])"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="h:prepareForURI(//t:placeName[contains(@type,'county')][1])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:function name="h:taxationID" xml:id="h:taxationID" as="xs:string">
        <xsl:param name="me"/>
        <xsl:choose>
            <xsl:when test="$me/@xml:id[starts-with(string(.),'e_')]">
                <xsl:value-of select="concat('t_',$me/@xml:id/substring-after(string(.),'e_'))"/>
            </xsl:when>
            <xsl:when test="$me/@xml:id[not(starts-with(.,'e_'))]">
                <xsl:value-of select="$me/@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('t_',$me/count(preceding::*[matches(@ana,'h_e')])+1)"/>
            </xsl:otherwise>
        </xsl:choose>
<!--        <xsl:value-of select="$me/generate-id()"/>-->
    </xsl:function>
    <xsl:function name="h:capitalise">
        <!-- Erster Buchstabe im Wort Groß, der Rest klein -->
        <xsl:param name="input"/>
        <xsl:value-of select="upper-case(substring(string($input),1,1))"/>
        <xsl:value-of select="substring(string($input),2)"/>
    </xsl:function>
    
    <!-- 
        ********************
        h:whereURI ermittelt zu einem area den Ortsnamen und baut daraus dann eine o:htx.places-URI 
        ********************
    -->
    <xsl:function name="h:whereURI">
        <xsl:param name="area"/><!-- $area = Eine t:div für eine h_area -->
        <xsl:variable name="input"><xsl:choose>
            <!-- Ermitteln des bestmöglichen Kandidaten aus dem Transkript-->
            <xsl:when test="$area/t:head[last()]//t:placeName/@ref!=''">
                <xsl:element name="ref"><xsl:value-of select="$area/t:head[last()]//t:placeName/@ref"/></xsl:element>
            </xsl:when>
            <!-- Die folgenden besser als Hash?
        z.B. https://gist.github.com/wjn/9253839 bzw. https://www.getsymphony.com/download/xslt-utilities/view/105477/
        oder über Datei+generateID(), denn der Knoten ist in der aktuellen Datei ja immer eindeutig-->
            <xsl:when test="count($area/t:head[last()]/t:placeName/t:choice/t:reg) = 1">
                <xsl:copy-of select="$area/t:head[last()]/t:placeName/t:choice/t:reg"/>
            </xsl:when>
            <xsl:when test="$area/t:head[last()]//t:placeName/t:note[@resp='#editor']">
                <xsl:copy-of select="$area/t:head[last()]//t:placeName/t:note[@resp='#editor']"/>
            </xsl:when>
            <xsl:when test="$area/t:head[last()]/t:note[@resp='#editor']">
                <xsl:copy-of select="$area/t:head[last()]/t:note[@resp='#editor']"/>
            </xsl:when>
            <xsl:when test="count($area/t:head[last()]/t:placeName) = 1">
                <xsl:copy-of select="$area/t:head[last()]/t:placeName"/>
            </xsl:when>
            <xsl:when test="$area/t:head">
                <!-- FixMe: Erzeugt das, weil es z.B. noch andere Fälle gibt -->
                <xsl:copy-of select="$area/t:head[last()]/normalize-space()"/>
            </xsl:when>
            <xsl:when test="$area/self::t:placeName/@ref!=''">
                <xsl:element name="ref"><xsl:value-of select="$area/@ref/normalize-space()"/></xsl:element>
            </xsl:when>
            <xsl:when test="$area/descendant-or-self::t:placeName">
                <xsl:copy-of select="$area/descendant-or-self::t:placeName[1]"/>
            </xsl:when>
        </xsl:choose></xsl:variable>
        <xsl:variable name="pid">
            <xsl:text>/o:htx.places#</xsl:text>
            <xsl:if test="$global-countyID!=h:prepareForURI($input)">
                <xsl:value-of select="$global-countyID"/><xsl:text>_</xsl:text>
            </xsl:if>
        </xsl:variable>
        <!-- FixMe: Für die Dublettenvermeidung sollte man hier noch eine weitere geographische Hierarchiestufe zum Bestandteil der URI machen -->
        <xsl:choose>
            <xsl:when test="matches($input,'^https?://')">
                <xsl:value-of select="$input/normalize-space()"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="h:createURI($input/normalize-space(),$pid)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="h:prepareForURI">
        <!-- Löscht für URIs ungünstige Zeichen aus einem String -->
        <xsl:param name="input"/>
        <xsl:value-of select="
            replace(
            translate(
            replace(
            string(string($input[last()])),
            '&amp;','and'
            ),
            '()[],.&#xA;',''
            ),
            '[\s/-]+', '-'
            )
            "/>
    </xsl:function>
    <xsl:function name="h:createURI">
        <!-- Erzeugt eine URI aus einer beliebigen Zeichenkette -->
        <xsl:param name="input"/>
        <xsl:param name="pid"/>
        <xsl:value-of select="$ontology-server"/>
        <xsl:value-of select="$pid"/>
        <xsl:value-of select="h:prepareForURI($input)"/>
    </xsl:function>
    
    
</xsl:stylesheet>