<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Georg Vogeler
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: 
        bk:roman2int: Converting Roman numerals to Latin Numbers
        metaphone: Creating a metaphone representation of a string
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:m = "http://gams.uni-graz.at/htx/conversions.xsl#"
    exclude-result-prefixes="xs" version="2.0">
    <!--  -->
    <xsl:function name="bk:roman2int" xml:id="bk:roman2int">
        <xsl:param as="xs:string" name="r"/>
        <xsl:variable name="r2" select="translate(upper-case(normalize-space($r)), 'J', 'I')"/>
        <xsl:choose>
            <xsl:when test="ends-with($r2, 'XC')">
                <xsl:sequence select="90 + bk:roman2int(substring($r2, 1, string-length($r2) - 2))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, 'XL')">
                <xsl:sequence select="40 + bk:roman2int(substring($r2, 1, string-length($r2) - 2))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, 'L')">
                <xsl:sequence select="50 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, 'C')">
                <xsl:sequence select="100 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, 'D')">
                <xsl:sequence select="500 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, 'M')">
                <xsl:sequence
                    select="1000 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'IV')">
                <xsl:sequence select="4 + bk:roman2int(substring($r2, 1, string-length($r2) - 2))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'IX')">
                <xsl:sequence select="9 + bk:roman2int(substring($r2, 1, string-length($r2) - 2))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'IIX')">
                <xsl:sequence select="8 + bk:roman2int(substring($r2, 1, string-length($r2) - 2))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'I')">
                <xsl:sequence select="1 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'V')">
                <xsl:sequence select="5 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"/>
            </xsl:when>
            <xsl:when test="ends-with($r2, 'X')">
                <xsl:sequence select="10 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"
                />
            </xsl:when>
            <xsl:when test="ends-with($r2, '̶')">
                <xsl:sequence
                    select="-0.5 + bk:roman2int(substring($r2, 1, string-length($r2) - 1))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!--
        *******************************************************************
        XSLT based implementation of Lawrence Philipp's Metaphone algorithm
        Georg Vogeler, georg.vogeler@uni-graz.at, 2020
        *******************************************************************
        
        ToDo: consider creating a representation of initial vowels:
        U = A
        E = I
        
        ToDo: Test against other implementations, in particular possible JavaScript-Solution (e.g. https://words.github.io/metaphone/) as they would be used in query construction in the search
        
    -->
    <xsl:template name="metaphone">
        <xsl:param name="input"/>
        <!-- Drop duplicate adjacent letters, except for C. -->
        <xsl:variable name="step1" select="replace(upper-case($input),'([ABD-Z])\1','$1')"/>
        <!-- If the word begins with 'KN', 'GN', 'PN', 'AE', 'WR', drop the first letter. -->
        <xsl:variable name="step2">
            <xsl:choose>
                <xsl:when test="matches($step1,'^(KN|GN|PN|AE|WR)')">
                    <xsl:value-of select="substring($step1,2)"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$step1"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Drop 'B' if after 'M' at the end of the word. -->
        <xsl:variable name="step3" select="replace($step2,'MB$','M')"/>
        <!-- convert string to sequence -->
        <xsl:variable name="sequence">
            <xsl:for-each select="tokenize(replace($step3,'(.)', '$1 '),' ')">
                <m:character><xsl:value-of select="."/></m:character>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="output">
            <xsl:apply-templates select="$sequence/m:character"/>
        </xsl:variable>
        <!-- Drop all vowels unless it is the beginning.
            Abweichend vom Metaphone wir hier noch ein einleitender Vokal auf 'A' abgebildet (wie in double metaphone ) -->
        <xsl:value-of select="concat(translate(substring($output,1,1),'AEIOU','A'),replace(substring($output,2),'[AEIOU]',''))"/>
    </xsl:template>
    
    <xsl:template match="m:character">
        <xsl:variable name="f1">
            <xsl:if test="following-sibling::m:character[1]">
                <xsl:value-of select="following-sibling::m:character[1]"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="f2">
            <xsl:if test="following-sibling::m:character[2]">
                <xsl:value-of select="following-sibling::m:character[2]"/>
            </xsl:if>
        </xsl:variable> 
        <xsl:variable name="f3">
            <xsl:if test="following-sibling::m:character[3]">
                <xsl:value-of select="following-sibling::m:character[3]"/>
            </xsl:if>
        </xsl:variable> 
        <xsl:variable name="p1"> 
            <xsl:if test="preceding-sibling::m:character[1]"><xsl:value-of select="preceding-sibling::m:character[1]"/></xsl:if>
        </xsl:variable>
        <xsl:variable name="p2"> 
            <xsl:if test="preceding-sibling::m:character[2]"><xsl:value-of select="preceding-sibling::m:character[2]"/></xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test=".='C'">
                <!-- 'C' transforms to 'X' if followed by 'IA' or 'H' 
            (unless in latter case, it is part of '-SCH-', in which case it transforms to 'K'). 
            'C' transforms to 'S' if followed by 'I', 'E', or 'Y'. 
            Otherwise, 'C' transforms to 'K'. -->
                <xsl:choose>
                    <xsl:when test="
                        ($f1 = 'I' and $f2 = 'A')
                        or
                        ($f1='H' and $p1 !='S')
                        ">
                        <xsl:text>X</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches($f1,'[IEY]')">
                        <xsl:text>S</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>K</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".='H' and $f1='C'"/>
            <xsl:when test=".='D'">
                <!-- 'D' transforms to 'J' if followed by 'GE', 'GY', or 'GI'. Otherwise, 'D' transforms to 'T'. -->
                <xsl:choose>
                    <xsl:when test="$f1 ='G' and matches($f2,'[EYI]')">
                        <xsl:text>J</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>T</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".='G'">
                <!-- Drop 'G' if followed by 'H' and 'H' is not at the end or before a vowel. Drop 'G' if followed by 'N' or 'NED' and is at the end. -->
                <!-- 'G' transforms to 'J' if before 'I', 'E', or 'Y', and it is not in 'GG'. Otherwise, 'G' transforms to 'K'. -->
                <xsl:choose>
                    <xsl:when test="matches($f1,'H') and ($f2!='' or matches($f3,'[AEIOU]'))"/>
                    <xsl:when test="$f1='N' and ($f2='' or ($f2='E' and $f3='D' and not(following-sibling::m:character[4])))"/>
                    <xsl:when test="matches($f1,'IEY') and $f2!='G'">
                        <xsl:text>J</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>K</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".='H' and matches($p1,'[AEIOU]') and not(matches($f1,'[AEIOU]'))">
                <!-- Drop 'H' if after vowel and not before a vowel. -->
            </xsl:when>
            <xsl:when test=".='K' and $p1='C'">
                <!-- 'CK' transforms to 'K'. -->
            </xsl:when>
            <xsl:when test="(.='P' and $f1='H')">
                <!-- 'PH' transforms to 'F'. -->
                <xsl:text>F</xsl:text>
            </xsl:when>
            <xsl:when test=" .='H' and $p1='P'"/>
            <xsl:when test=".='Q'">
                <!-- 'Q' transforms to 'K'. -->
                <xsl:text>K</xsl:text>
            </xsl:when>
            <xsl:when test=".='S' and ($f1='H' or ($f1='I' and ($f2='O' or $f2='A')))">
                <!-- 'S' transforms to 'X' if followed by 'H', 'IO', or 'IA'. -->
                <xsl:text>X</xsl:text>
            </xsl:when>
            <xsl:when test=".='T'">
                <!-- 'T' transforms to 'X' if followed by 'IA' or 'IO'. 
                'TH' transforms to '0'. 
                Drop 'T' if followed by 'CH'. -->
                <xsl:choose>
                    <xsl:when test="$f1='I' and matches($f2,'[AO]')">
                        <xsl:text>X</xsl:text>
                    </xsl:when>
                    <xsl:when test="$f1='H'">
                        <xsl:text>0</xsl:text>
                    </xsl:when>
                    <xsl:when test="$f1='C' and $f2='H'"/>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".='V'">
                <!-- 'V' transforms to 'F'. -->
                <xsl:text>F</xsl:text>
            </xsl:when>
            <xsl:when test=".='H' and (($p1='W' and $p2='') or $p1='T')">
                <!-- 'WH' transforms to 'W' if at the beginning. 
                'TH' transforms to '0'. -->
            </xsl:when>
            <xsl:when test=".='W' and not(matches($f1,'[AEIOU]'))">
                <!-- Drop 'W' if not followed by a vowel. -->
            </xsl:when>
            <xsl:when test=".='X'">
                <!-- 'X' transforms to 'S' if at the beginning. Otherwise, 'X' transforms to 'KS'. -->
                <xsl:choose>
                    <xsl:when test="$f1=''">
                        <xsl:text>S</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>KS</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".='Y' and not(matches($f1,'[AEIOU]'))">
                <!-- Drop 'Y' if not followed by a vowel. -->
            </xsl:when>
            <xsl:when test=".='Z'">
                <!-- 'Z' transforms to 'S'. -->
                <xsl:text>S</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="m:createSequence">
        <!-- Zerlegt einen String eine Sequenz von m:character-Elementen -->
        <xsl:param name="input"/>
        <m:string><xsl:for-each select="tokenize(
            replace(
                replace($input,'\s+','_')
                ,'(.)', '$1 ')
            ,' '
            )">
            <m:character><xsl:value-of select="replace(.,'_',' ')"/></m:character>
        </xsl:for-each></m:string>
    </xsl:function>
</xsl:stylesheet>
