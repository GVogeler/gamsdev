$(function () {
    /* define search for functionalities */
    var suche = "#suche";
    var extendedsearch = "#detailsuche"
    $(suche).on('submit', function () {
        loading_animation();
        form2params(suche);
        return false;
    });
    $(extendedsearch).on('submit', function () {
        loading_animation();
        buildquery_hearthtax(extendedsearch);
        return false;
    });
});

/*************************************Für die erweiterte Suche*******************************/
function buildquery_hearthtax(form) {
    /* build SPARQL-fragment for query:htx.search from a html:form
     *
     * iterate through input elements
     * test if they contain a value
     * formulate correct SPARQL fragment
     * concatenate the fragments
     * hand them over to the query-object as ?params
     *
     *  */
    /*******************Suche über VALUES (Teil 1/2)*****************************/
    /*    var min = 0;
    var max = 250;*/
    /* ************************************************************* */
    
    /*******************Suche über FILTER (Teil 1/2)******************************/
    var min = "";
    var max = "";
    /* ************************************************************** */
    var clause = "";
    var clause_filter = "";
    var query = "";
    var quantity_statement = " ?entryID ^h:recordedBy/h:on/bk:quantity ?quantity . ";
    /*****
     *  iterate through input elements
     * *****/
    $(form + " :input:not([type='submit'])").each(function () {
        console.log(this);
        if (this.value != '') {
            /* id="date" name="date"
             *  ToDo: Datumsangaben sollte man auch mit Zeiträumen suchen können (min/max)
             * Und unvollständige Angaben wie 1666 => 1666-03-25
             */
            if (this.name == 'date') {
                clause += ' ?taxationID h:recordedBy ?entryID .';
                clause += ' ?taxationID bk:when "' + this.value + '" .';
                if (query != '') {
                    query += ' and '
                }
                query += ' date=' + this.value;
            }
            /*  id="county" name="county":
             *      setzt voraus, daß county eine URI ist =>
             *      ToDo: Auswahlliste ins Formular
             */
            if (this.name == 'county') {
                var counties = '';
                var counties_str = '';
                $(this.options).each(function () {
                    if (this.selected) {
                        if (counties != '') {
                            counties += " || ";
                            counties_str += ', '
                        }
                        counties += 'sameTerm(?countyID, <' + this.value + '>))';
                        counties_str += this.value;
                    }
                });
                clause_filter += ' FILTER(' + counties + ')';
                if (query != '') {
                    query += ' and '
                }
                query += ' counties=' + counties_str;
            }
            /*******
             *  id="place" name="place"
             */
            if (this.name == 'place') {
                clause += ' {?placeID t:placeName ?placename . } UNION {?placeID skos:prefLabel ?placename . } ?placename bds:search "' + this.value + '" ; bds:matchAllTerms true .';
                if (query != '') {
                    query += ' and '
                }
                query += ' place=' + this.value;
            }
            /*******
             *  id="taxpayer" name="taxpayer"
             *     ToDo: Einbeziehung der normalisierten Formen
             */
            if (this.name == 'taxpayer') {
                clause += ' ?taxationID h:recordedBy ?entryID ; h:of ?taxpayerID .';
                clause += ' ?taxpayerID t:persName ?taxpayer . ?taxpayer bds:search "' + this.value + '" ; bds:matchAllTerms true .';
                if (query != '') {
                    query += ' and '
                }
                query += ' taxpayer=' + this.value;
            }
            
            if (this.name == 'hearths_min') {
                min = Math.ceil(this.value) || 0;
                if (query != '') {
                    query += ' and '
                }
                query += ' hearths >=' + this.value;
            }
            if (this.name == 'hearths_max') {
                max = Math.floor(this.value);
                if (query != '') {
                    query += ' and '
                }
                query += ' hearths <=' + this.value;
            }
            if (this.name == 'keyword') {
                clause += ' ?text bds:search "' + this.value + '" ; bds:matchAllTerms true .';;
                if (query != '') {
                    query += ' and '
                }
                query += ' keywords=' + this.value;
            }
        }
    });
    
    /*******************Suche über VALUES (Teil 2/2)*****************************/
    /*    if (min != 0 || max != 250) {
    var clause_filter = 'VALUES ?quantity {';
    for (var count = min;
    count <= max;
    count++) {
    clause_filter += count + ' ';
    }
    clause_filter += '}';
    //alert(clause_filter); /\* Debug *\/
    clause += quantity_statement;
    }*/
    /********************************************************************/
    
    
    /*******************Suche über FILTER (Teil 2/2)********************************/
    var clause_filter = "";
    if (min != "" || max != "") {
        clause += quantity_statement;
    }
    if (min != "") {
        clause_filter += "FILTER (?quantity >= " + min + ")"
    }
    if (max != "") {
        clause_filter += "FILTER (?quantity <= " + max + ")"
    }
    /********************************************************************/
    
    /*
    regionale Beschränkung (Mehrfachauswahl!? Hierarchie!)
    zu/abwählbar:
    h:on (Taxpayer => mit Normalisierungen für Vornamen und Rolenames)
    Role (Auswahlliste? Incl. Normalisierungen?)
    h:chargeable
    h:notPayedFor
    gender (Warnung, daß die nicht immer vorhanden sind!)
     *
    
     */
    
    console.log("clause : " + clause + clause_filter);
    params = '$1|' + (clause.trim() + clause_filter.trim()) + ';$2|' + query;
    //alert(params);
    /* Debug */
    var actionUrl = $(form).attr('action') + "?params=" + encodeURIComponent(params);
    //alert(actionUrl); /* Debug */
    window.location.href = actionUrl.trim();
    return false;
}

/*************************************Für die Volltextsuche*******************************/
function form2params(form) {
    var params = "";
    var dollar = 0;
    //iteriere über alle options im #suche-Formular:
    $(form + " :input:not([type='submit'])").each(function () {
        if (this.type == 'radio' && this.checked) {
            //Radio-Boxen werden nur ausgewertet, wenn sie angewählt sind
            var value = this.value; //Werte sollte URL-kodiert sein
            if (params != '') {
                params += ";"
            }
            //params-Parameter werden mit Semikolon von einander abgetrennt.
            dollar++; //jede Iteration erzeugt ein neues $x
            params += "$" + dollar + "|" + value; //Hier werden die $x mit den Werten zusammengebaut.
        } else if (this.multiple) {
            //Multiple Select wird hier in mehrere $x zerlegt
            $(this.options).each(function () {
                if (this.selected) {
                    if (params != '') {
                        params += ";"
                    }
                    //params-Parameter werden mit Semikolon von einander abgetrennt.
                    dollar++; //jede Iteration erzeugt ein neues $x
                    var value = this.value; //Werte sollte URL-kodiert sein
                    params += "$" + dollar + "|" + value; //Hier werden die $x mit den Werten zusammengebaut.
                }
            });
        } else if (this.type == 'checkbox' || this.type == 'select-one' || this.type == 'text') {
            var value = this.value; //Werte sollte URL-kodiert sein
            if (params != '') {
                params += ";"
            }
            //params-Parameter werden mit Semikolon von einander abgetrennt.
            dollar++; //jede Iteration erzeugt ein neues $x
            params += "$" + dollar + "|" + value; //Hier werden die $x mit den Werten zusammengebaut.
        }
    });
    console.log(params);
    //alert(params); /* Debug */
    if (params.trim() != '') {
        var actionUrl = $(form).attr('action') + "?params=" + encodeURIComponent(params + ";$2|" + query);
        //alert(actionUrl); /* Debug */
        window.location.href = actionUrl.trim();
    }
    return false;
}

function loading_animation() {
    /* define search for functionalities */
    $("main").addClass("loading");
};