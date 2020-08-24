<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Project: GAMS Hearthtax
    Author: Jakob Sonnberger
    Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
    /////////////////////////////////////////////////////////////////////////////////////////////////
    Stylesheet Information: HTML Transformation of Basic Site Structure
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:lido="http://www.lido-schema.org"
	xmlns:bibtex="http://bibtexml.sf.net/" exclude-result-prefixes="#all">
	<xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="no"/>
	<!-- häufig verwendete variablen... -->
	<xsl:param name="mode"/>
	<xsl:param name="search"/>
	<xsl:variable name="model"
		select="substring-after(/s:sparql/s:results/s:result/s:model/@uri, '/')"/>
	<xsl:variable name="cid">
		<!-- das ist der pid des contextes, kommt aus dem sparql (ggfs. query anpassen) - wenn keine objekte zugeordnet sind, gibt es ihn nicht! -->
		<xsl:value-of select="/s:sparql/s:results/s:result[1]/s:cid"/>
	</xsl:variable>
	<xsl:variable name="teipid">
		<xsl:value-of select="//t:idno[@type = 'PID']"/>
	</xsl:variable>
	<xsl:variable name="querypid" select="//s:result[1]/s:query"/>
	<xsl:variable name="lidopid">
		<xsl:value-of select="//lido:lidoRecID"/>
	</xsl:variable>
	<!--variablen für Suchergebnisse-->
	<xsl:variable name="query" select="sparql/head/query"/>
	<xsl:variable name="hitTotal" select="/sparql/head/hitTotal"/>
	<xsl:variable name="hitPageStart" select="/sparql/head/hitPageStart"/>
	<xsl:variable name="hitPageSize" select="/sparql/head/hitPageSize"/>
	<xsl:variable name="hitsFrom" select="sparql/navigation/hits/from"/>
	<xsl:variable name="hitsTo" select="sparql/navigation/hits/to"/>
	<!-- GAMS global variables -->
	<xsl:variable name="zim">Zentrum für Informationsmodellierung - Austrian Centre for Digital
		Humanities</xsl:variable>
	<xsl:variable name="zim-acdh">ZIM-ACDH</xsl:variable>
	<xsl:variable name="gams">Geisteswissenschaftliches Asset Management System</xsl:variable>
	<xsl:variable name="uniGraz">Universität Graz</xsl:variable>
	<!-- project-specific variables -->
	
	<!-- #Glossa -->
<!--	<xsl:variable name="server">http://glossa.uni-graz.at</xsl:variable>
	<xsl:variable name="gamsdev">/gamsdev/sonnberger</xsl:variable>-->
	
	<!-- #GAMS -->
	<xsl:variable name="server">https://glossa.uni-graz.at</xsl:variable>
	<xsl:variable name="gamsdev">https://georg-vogeler.eu/gamsdev</xsl:variable>
	
	<xsl:variable name="projectTitle">
		<xsl:text>Hearth Tax Digital</xsl:text>
	</xsl:variable>
	<xsl:variable name="subTitle">
		<xsl:text>beta version</xsl:text>
	</xsl:variable>
	<!-- gesamtes css ist in dieser Datei zusammengefasst mit Ausnahme der Navigation -->
	<xsl:variable name="projectCss">
		<xsl:value-of select="concat($gamsdev, '/htx/css/htx.css')"/>
	</xsl:variable>
	<!--css für die navigation-->
	<xsl:variable name="projectNav">
		<xsl:value-of select="concat($gamsdev, '/htx/css/htx-navbar.css')"/>
	</xsl:variable>
	<xsl:template match="/">
		<html lang="en">
			<head>
				<meta charset="utf-8"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<meta name="keywords"
					content="hearthtax, GAMS, repository, digital, archive, edition"/>
				<meta name="description"
					content="Hearth Tax Digital - Geisteswissenschaftliches Asset Management System"/>
				<meta name="publisher"
					content="Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities"/>
				<meta name="content-language" content="en"/>
				<title>Hearth Tax Digital</title>
				<!-- Bootstrap core CSS ======================================================== -->
				<link href="/lib/2.0/bootstrap-4.1.0-dist/css/bootstrap.min.css" rel="stylesheet"
					type="text/css"/>
				<!-- Custom styles for htx CSS =========================================== -->
				<link href="{$projectCss}" rel="stylesheet" type="text/css"/>
				<link href="{$projectNav}" rel="stylesheet" type="text/css"/>
				<!-- Icons CSS-->
				<link href="/lib/2.0/open-iconic/font/css/open-iconic-bootstrap.css"
					rel="stylesheet" type="text/css"/>
				<!-- Leaflet CSS-->
				<link href="/lib/2.0/leaflet/leaflet.css" rel="stylesheet" type="text/css"/>
				<!-- Leaflet FullScreen CSS-->
				<link
					href="{concat($gamsdev, '/htx/plugins/leaflet_fullscreen/dist/leaflet.fullscreen.css')}"
					rel="stylesheet" type="text/css"/>
				<!-- jQuery core JavaScript ================================================= -->
				<script type="text/javascript" src="/lib/2.0/jquery-3.3.1.min.js"><xsl:text>//  </xsl:text></script>
				<!-- Bootstrap core JavaScript ============================================== -->
				<script type="text/javascript" src="/lib/2.0/bootstrap-4.1.0-dist/js/bootstrap.bundle.min.js"><xsl:text>//  </xsl:text></script>
				<!-- Databasket JavaScript ====================================== -->
				<script type="text/javascript" src="{concat($gamsdev, '/htx/js/databasket.js')}"><xsl:text>//  </xsl:text></script>
				<!-- Leaflet JavaScript ====================================== -->
				<script type="text/javascript" src="/lib/2.0/leaflet/leaflet.js"><xsl:text>//  </xsl:text></script>
				<!-- Leaflet FullScreen JavaScript ====================================== -->
				<script type="text/javascript" src="{concat($gamsdev, '/htx/plugins/leaflet_fullscreen/dist/Leaflet.fullscreen.min.js')}"><xsl:text>//  </xsl:text></script>
				<!-- Suche in Query-Objekt JavaScript-->
				<script type="text/javascript" src="{concat($gamsdev, '/htx/js/search.js')}"><xsl:text>//  </xsl:text></script>
			</head>
			<!-- Header ====================================== -->
			<body>
				<header>
					<div class="container">
						<div class="row flex">
							<div class="col-6">
								<h1>
									<xsl:value-of select="$projectTitle"/>
								</h1>
								<h2>
									<xsl:value-of select="$subTitle"/>
								</h2>
							</div>
							<div class="col-6">
								<div class="unilogo d-flex">
									<a href="https://www.britac.ac.uk" target="_blank">
										<img class="logoUni"
											src="{concat($gamsdev, '/htx/img/british_academy_logo.jpg')}"
											title="British Academy" alt="British Academy"/>
									</a>
									<a href="https://www.roehampton.ac.uk" target="_blank">
										<img class="logoUni"
											src="{concat($gamsdev, '/htx/img/roehampton_logo.png')}"
											title="University of Roehampton"
											alt="University of Roehampton"/>
									</a>
									<a
										href="https://www.roehampton.ac.uk/research-centres/centre-for-hearth-tax-research/"
										target="_blank">
										<img class="logoUni"
											src="{concat($gamsdev, '/htx/img/chtr_logo.jpg')}"
											title="Centre for Hearth Tax Research"
											alt="Centre for Hearth Tax Research"/>
									</a>
									<a href="http://www.uni-graz.at" target="_blank">
										<img class="logoUni"
											src="/templates/img/logo_uni_graz_4c.jpg"
											title="University of Graz" alt="University of Graz"/>
									</a>
								</div>
							</div>
						</div>
					</div>
				</header>
				<!-- Navbar ====================================== -->
				<nav class="hearthtax navbar navbar-expand-md navbar-dark sticky-top">
					<div class="container">
						<a class="navbar-brand d-md-none" href="#">Navigation</a>
						<button class="navbar-toggler" type="button" data-toggle="collapse"
							data-target="#navbarCollapse" aria-controls="navbarCollapse"
							aria-expanded="false" aria-label="Toggle navigation">
							<span class="navbar-toggler-icon"/>
						</button>
						<div id="navbarCollapse" class="collapse navbar-collapse">
							<ul class="hearthtax navbar-nav mr-auto">
								<li class="nav-item">
									<xsl:if test="$mode = '' and $cid = 'context:htx'">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link" href="/context:htx">Home</a>
								</li>
								<li class="nav-item">
									<xsl:if test="$mode = 'about'">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link"
										href="/archive/objects/context:htx/methods/sdef:Context/get?mode=about"
										>About</a>
								</li>
								<li class="nav-item">
									<xsl:if
										test="$mode = 'records' or starts-with($teipid, 'o:htx.')">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link"
										href="/archive/objects/context:htx/methods/sdef:Context/get?mode=records"
										>Records</a>
								</li>
								<li class="nav-item">
									<xsl:if test="$mode = 'advanced_search'">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link"
										href="/archive/objects/context:htx/methods/sdef:Context/get?mode=advanced_search"
										>Advanced Search</a>
								</li>

								<!--Databasket Menu-->
								<li class="nav-item">
									<xsl:if test="$mode = 'databasket'">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link"
										href="/archive/objects/context:htx/methods/sdef:Context/get?mode=databasket"
										title="Your own selection of entries">Databasket<span
											class="badge-pill badge-light" id="daba_length"/></a>
								</li>
								<!--Map Menu-->
								<li class="nav-item">
									<xsl:if test="//s:polygon">
										<xsl:attribute name="class">nav-item active</xsl:attribute>
									</xsl:if>
									<a class="nav-link" href="/query:htx.map">Map</a>
								</li>
							</ul>
							<form class="form-inline" role="search" method="get"
								action="/query:htx.search-fulltext" id="suche">
								<div class="input-group">
									<input name="$1" type="text" class="form-control" id="query"
										placeholder="Search in all documents"/>
									<button class="btn btn-outline-light" type="submit">
										<span class="oi oi-magnifying-glass"> </span>
										<span class="sr-only">Search</span>
									</button>
								</div>
							</form>
						</div>
						<!-- /.navbar-collapse -->
					</div>
					<!-- /.container -->
				</nav>
				<main class="container">
					<xsl:choose>
						<!-- Home ====================================== -->
						<xsl:when test="$mode = '' and $cid = 'context:htx'">
							<section class="row">
								<article class="col-md-6 teaser-img">
									<div class="card">
										<div class="card-body">
											<div id="home_carousel"
												class="carousel slide carousel-fade"
												data-interval="10000" data-ride="carousel">
												<div class="carousel-inner" role="listbox">
												<div class="carousel-item active">
												<img class="d-block" data-toggle="tooltip"
												data-placement="right"
												title="Thomas Farinor, baker, had paid the hearth tax
														on 5 hearths and one oven at his bakery in Pudding
														Lane, where the Great Fire of London began."
												src="{concat($gamsdev, '/htx/img/hearth_facsimile_4.jpg')}"
												alt="Facsimile of a hearth tax record"/>
												<div class="carousel-caption"> &#9400; TNA </div>
												</div>
												<!--
												<div class="carousel-item">
												<img class="d-block"
												src="{concat($gamsdev, '/htx/img/hearth_facsimile.jpg')}"
												alt="Facsimile of a hearth tax record"/>
												</div>
												<div class="carousel-item">
												<img class="d-block"
												src="{concat($gamsdev, '/htx/img/hearth_facsimile_2.jpg')}"
												alt="Facsimile of a hearth tax record"/>
												</div>
												<div class="carousel-item">
												<img class="d-block"
												src="{concat($gamsdev, '/htx/img/hearth_facsimile_3.jpg')}"
												alt="Facsimile of a hearth tax record"/>
												</div>
												<div class="carousel-item">
												<img class="d-block"
												src="{concat($gamsdev, '/htx/img/exemption_certificate.jpg')}"
												alt="Facsimile of an exemption certificate"/>
												</div>
												</div>
												<a class="carousel-control-prev"
												href="#home_carousel" role="button"
												data-slide="prev">
												<span class="carousel-control-prev-icon"
												aria-hidden="true"/>
												<span class="sr-only">Previous</span>
												</a>
												<a class="carousel-control-next"
												href="#home_carousel" role="button"
												data-slide="next">
												<span class="carousel-control-next-icon"
												aria-hidden="true"/>
												<span class="sr-only">Next</span>
												</a>-->
												</div>
											</div>
										</div>
									</div>
								</article>
								<article class="col-md-6 teaser-text">
									<div class="card">
										<div class="card-body">
											<xsl:apply-templates
												select="document(concat($server,'/archive/objects/context:htx/datastreams/HOME/content'))//t:TEI"
											/>
										</div>
									</div>
								</article>
							</section>
						</xsl:when>
						<xsl:when test="$mode = 'about'">
							<!-- About ====================================== -->
							<section class="row">
								<article class="col-md-8 about_site">
									<div class="card">
										<div class="card-body">
											<xsl:apply-templates
												select="document(concat($server,'/archive/objects/context:htx/datastreams/ABOUT/content'))//t:TEI"
											/>
										</div>
									</div>
								</article>
								<article class="col-md-4 about_links">
									<div class="card">
										<div class="card-body">
											<a
												href="https://www.roehampton.ac.uk/research-centres/centre-for-hearth-tax-research/"
												target="_blank">
												<img id="centre_logo"
												src="{concat($gamsdev, '/htx/img/centre_for_hearth_tax_research.jpg')}"
												width="100%" alt="Centre For Hearth Tax Research"
												/>
											</a>
											<div class="list-group centre_links">
												<a class="list-group-item list-group-item-action"
												href="https://www.roehampton.ac.uk/research-centres/centre-for-hearth-tax-research/the-hearth-tax/"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/roehampton_icon.ico')}"
												alt="University Of Roehampton"/>A brief
												introduction to the hearth tax</a>
												<a class="list-group-item list-group-item-action"
												href="https://www.roehampton.ac.uk/research-centres/centre-for-hearth-tax-research/research/"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/roehampton_icon.ico')}"
												alt="University Of Roehampton"/>Research</a>
												<a class="list-group-item list-group-item-action"
												href="https://www.roehampton.ac.uk/research-centres/centre-for-hearth-tax-research/publications/"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/roehampton_icon.ico')}"
												alt="University Of Roehampton"/>Publications</a>
											</div>
											<div class="list-group external_links">
												<a class="list-group-item list-group-item-action"
												href="https://scotlandsplaces.gov.uk/digital-volumes/historical-tax-rolls/hearth-tax-records-1691-1695/"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/national_records_of_scotland_logo.png')}"
												alt="National Records of Scotland"/>National
												Records of Scotland - Hearth Tax</a>
											</div>
											<div class="list-group follow_links">
												<a class="list-group-item list-group-item-action"
												href="https://hearthtax.wordpress.com/"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/blog_icon.ico')}"
												alt="Blog"/>Follow our Blog on Wordpress</a>
												<a class="list-group-item list-group-item-action"
												href="https://twitter.com/HearthTax"
												target="_blank"><img
												src="{concat($gamsdev, '/htx/img/twitter_icon.ico')}"
												alt="Twitter"/>Follow us on Twitter</a>
											</div>
										</div>
									</div>
								</article>
							</section>
						</xsl:when>
						<xsl:when test="$mode = 'advanced_search'">
							<!-- Advanced Search ====================================== -->
							<section class="row">
								<article class="col-md-12 advanced_search">
									<div class="card">
										<div class="card-body">
											<h3>Advanced Search</h3>
											<div class="alert alert-dismissible" role="alert">The
												transcripts of the hearth tax returns are stored
												additionally in a RDF database which can be searched
												here. This search allows you to control searches by
												single features and their combinations and will
												return a maximum of 500 hits.<button type="button"
												class="close" data-dismiss="alert"
												aria-label="Close">
												<span aria-hidden="true" class="oi oi-x"/>
												</button>
											</div>
											<form role="search-ext" method="get"
												action="/query:htx.search-structured"
												id="detailsuche">
												<div class="form-group">
												<label for="keyword">Keyword</label>
												<input type="text" class="form-control"
												placeholder="any keyword" id="keyword"
												name="keyword"/>
												<small class="form-text text-muted">Searches for
												personal names, place names and any other words
												occurring in the transcripts. You can use the
												asterisk (*) as wildcard to search right
												truncated</small>
												</div>
												<!--<div class="form-group">
												<label for="date">Date</label>
												<input type="text" class="form-control"
												placeholder="date..." id="date" name="date"/>
												</div>

												<!-\-
													ToDo: Replace by dropdown of counties in the database:
													
													<div class="input-group input-group-sm">
												<div class="input-group-prepend">
												<span class="input-group-text">County</span>
												</div>
												<input type="text" class="form-control"
												placeholder="county..." id="county" name="county"
												/>
												</div>-\->

												<div class="form-group">
												<label for="text">Place</label>
												<input type="text" class="form-control"
												placeholder="place..." id="place" name="place"/>
												</div>


												<div class="form-group">
												<label for="taxpayer">Taxpayer</label>
												<input type="text" class="form-control"
												placeholder="taxpayer..." id="taxpayer"
												name="taxpayer"/>
												<small class="form-text text-muted">Searches only
												for words occuring in taxpayer descriptions
												(names, social roles)</small>
												</div>-->
												<div class="form-group">
												<label for="text">Hearths</label>
												<input type="text" class="form-control"
												placeholder="min" id="hearths_min"
												name="hearths_min"/>
												<input type="text" class="form-control"
												placeholder="max" id="hearths_max"
												name="hearths_max"/>
												<small class="form-text text-muted">Search only
												for hearths within a given range by setting a
												minimum/maximum (or both)</small>
												</div>
												<div class="input-group input-group-sm">
												<input class="btn btn-secondary btn-sm"
												type="submit" id="submit" value="Search"/>
												</div>
											</form>
										</div>
									</div>
								</article>
							</section>
						</xsl:when>
						<!-- Databasket ====================================== -->
						<xsl:when test="$mode = 'databasket'">
							<section class="row">
								<article class="col-md-12" id="databasket" data-server="{$server}">
									<div class="card">
										<div class="card-body">
											<!--Modal-->
											<div class="modal fade" tabindex="-1" role="dialog"
												aria-hidden="true" aria-labelledby="modal-title"
												id="clear_databasket_modal">
												<div class="modal-dialog modal-dialog-centered"
												role="document">
												<div class="modal-content">
												<div class="modal-header">
												<h5 class="modal-title">Sure you want to delete
												all databasket-entries?</h5>
												<button type="button" class="close"
												data-dismiss="modal" aria-label="Close">
												<span class="oi oi-x" aria-hidden="true"/>
												</button>
												</div>
												<div class="modal-footer">
												<button type="button" class="btn"
												data-dismiss="modal">No</button>
												<button type="button" id="clear_databasket"
												class="btn" data-dismiss="modal">Yes</button>
												</div>
												</div>
												</div>
											</div>
											<h3>Databasket</h3>
											<div class="alert alert-dismissible" role="alert">The
												databasket contains entries you have selected when
												<a href="/context:htx?mode=records">browsing the
												records</a> or <a
												href="/context:htx?mode=advanced_search">searching
												the dataset</a>. You can sort the list or download
												it as a spreadsheet (<img
												src="{concat($gamsdev, '/htx/img/excel_icon.png')}"
												height="14"/>).<button type="button" class="close"
												data-dismiss="alert" aria-label="Close"><span
												aria-hidden="true" class="oi oi-x"
												/></button></div>
											<div id="databasket_tools">
												<a id="to_CSV">
												<img
												src="{concat($gamsdev, '/htx/img/excel_icon.png')}"
												height="36" alt="CSV Download"
												title="CSV Download" data-toggle="tooltip"/>
												</a>
												<a id="clear_databasket"
												data-target="#clear_databasket_modal"
												data-toggle="modal">
												<span class="oi oi-x" title="Clear Basket"
												data-toggle="tooltip"/>
												</a>
											</div>
											<table class="col-md-12 table table-hover">
												<thead>
												<tr>
												<th style="width:10%">ID<span id="xml_id"
												class="sort oi oi-elevator"/></th>
												<th style="width:20%">text<span id="text"
												class="sort oi oi-elevator"/></th>
												<th style="width:10%">hearths<span id="hearths"
												class="sort oi oi-elevator"/></th>
												<th style="width:10%"> paid <span id="status"
												class="sort oi oi-elevator"/>
												</th>
												<th style="width:15%">place<span id="place"
												class="sort oi oi-elevator"/></th>
												<th style="width:15%">book<span id="book"
												class="sort oi oi-elevator"/></th>
												<th style="width:15%">date<span id="date"
												class="sort oi oi-elevator"/></th>
												<th style="width:5%"> </th>
												</tr>
												</thead>
												<tbody/>
												<tfoot>
												<tr>
												<td>SUM</td>
												<td/>
												<td id="daba_sum"/>
												<td/>
												<td/>
												<td/>
												<td/>
												<td/>
												</tr>
												</tfoot>
											</table>
										</div>
									</div>
								</article>
							</section>
							<script>
								show_databasket();
							</script>
						</xsl:when>
						<!-- Home ====================================== -->
						<xsl:when test="$mode = 'imprint'">
							<section class="row">
								<article class="col-md-12 imprint">
									<div class="card">
										<div class="card-body">
											<xsl:variable name="imprint"
												select="document(concat($server,'/archive/objects/context:htx/datastreams/IMPRINT/content'))/t:TEI"/>
											<xsl:apply-templates select="$imprint//t:text"/>
											<xsl:call-template name="publication">
												<xsl:with-param name="imprint" select="$imprint"/>
											</xsl:call-template>
										</div>
									</div>
								</article>
							</section>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="content"/>
						</xsl:otherwise>
					</xsl:choose>
				</main>
				<footer class="footer">
					<div class="container">
						<div class="row">
							<div class="col-md-6">
								<h6>Further Informations</h6>
								<p>
									<a
										href="/archive/objects/context:htx/methods/sdef:Context/get?mode=imprint"
										>Imprint</a>
									<xsl:if test="contains($server, 'gams')">
										<br/>
										<a
											href="https://gams.uni-graz.at/archive/objects/context:gams/methods/sdef:Context/get?mode=dataprotection&amp;locale=en"
											>Privacy</a>
									</xsl:if>
								</p>
								<div class="icons">
									<a href="https://gams.uni-graz.at/context:gams" target="_blank">
										<img class="footer_icons"
											src="/templates/img/gamslogo_weiss.gif" height="48"
											title="{$gams}" alt="{$gams}"/>
									</a>
									<a href="https://informationsmodellierung.uni-graz.at/"
										target="_blank">
										<img class="footer_icons" src="/templates/img/ZIM_weiss.png"
											height="48" title="{$zim-acdh}" alt="{$zim-acdh}"/>
									</a>
									<a href="http://creativecommons.org/licenses/by-nc/4.0/"
										target="_blank">
										<img class="footer_icons" src="/templates/img/by-nc.png"
											height="45" title="License" alt="License"/>
									</a>
								</div>
							</div>
							<div class="col-md-6 contact">
								<h6>Contact</h6>
								<p>Dr Andrew Wareham<br/>British Academy Hearth Tax Project &amp;
									Centre for Hearth Tax Research<br/>Department of Humanities<br/>
									University of Roehampton<br/> London SW15 5PU<br/>
									<a href="mailto:a.wareham@roehampton.ac.uk"
										>a.wareham@roehampton.ac.uk</a>
								</p>
							</div>
						</div>
					</div>
				</footer>
				<!-- Databasket JavaScript ====================================== -->
				<script type="text/javascript" src="{concat($gamsdev, '/htx/js/databasket.js')}"><xsl:text>//  </xsl:text></script>
				<script type="text/javascript">
                    count_databasket();
                    $(document).ready(function () {<!--
                        BS4 Tooltips//-->
						$('[data-toggle="tooltip"]').tooltip(); 
						enable_checkboxes();
						check_checkboxes();
						//scrolldown on entry-links to skip navbar
						if (window.location.href.indexOf("#") != -1) {
							window.scrollBy(0, -60);
						}
					});
					//scrolldown on manual URL-change to skip navbar
					$(window).on('hashchange', function(){
						window.scrollBy(0, -60);
					});
				</script>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="t:teiHeader" priority="-5"/>
	<xsl:template name="publication">
		<xsl:param name="imprint"/>
		<div>
			<h3>Publication</h3>
			<p>Published in <xsl:value-of
					select="$imprint/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:date"/> in the
					<xsl:value-of
					select="$imprint/t:TEI/t:teiHeader/t:fileDesc/t:seriesStmt/t:title"/> series
				number <xsl:value-of
					select="$imprint/t:TEI/t:teiHeader/t:fileDesc/t:seriesStmt/t:idno"/>.</p>
		</div>
	</xsl:template>
	<xsl:template match="t:div" priority="-5">
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="t:p" priority="-5">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="t:head" priority="-5">
		<xsl:variable name="level" select="count(ancestor::t:div[t:head]) + 2"/>
		<xsl:element name="h{$level}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="t:ref" priority="-5">
		<a href="{@target}" target="{@rend}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="t:bibl" priority="-5">
		<a href="{@corresp}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="t:code" priority="-5">
		<code>
			<xsl:apply-templates/>
		</code>
	</xsl:template>
	<xsl:template match="t:lb" priority="-5">
		<br/>
	</xsl:template>
	<xsl:template match="t:listBibl" priority="-5">
		<xsl:apply-templates select="t:head"/>
		<ul class="list-group">
			<xsl:apply-templates select="t:bibl" mode="list"/>
		</ul>
	</xsl:template>
	<xsl:template match="t:bibl" mode="list">
		<li class="list-group-item" id="{@xml:id}">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

</xsl:stylesheet>
