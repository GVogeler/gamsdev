/*Project: GAMS Hearthtax
 Author: Jakob Sonnberger
 Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)
 HTML Table Data to GeoJson to Leaflet */

function toGeoJson() {
    var geojsonstring = '{"type": "FeatureCollection","name": "shapes","crs": {"type": "name", "properties": {"name": "urn:ogc:def:crs:OGC:1.3:CRS84"}},"features":[';
    $('tbody tr').each(function () {
        var uri = $(this).find('td#uri').text().trim();
        var parturis = $(this).find('td#parturis').text().trim();
        var label = $(this).find('td#label').text().trim();
        var acres = parseFloat($(this).find('td#acres').text().trim());
        var polygon = '[[[[' + $(this).find('td#polygon').text().trim().replace(/\s/g, '],[') + ']]]]';
        var households = $(this).find('td#households').text().trim();
        var households1total = $(this).find('td#households1').text().trim();
        var households1 = (100 * (households1total / households)).toFixed(2);
        //console.log(households1);
        var households2total = $(this).find('td#households2').text().trim();
        var households2 = (100 * (households2total / households)).toFixed(2);
        //console.log(households2);
        var households3total = $(this).find('td#households3').text().trim();
        var households3 = (100 * (households3total / households)).toFixed(2);
        //console.log(households3);
        var hhsacres = $(this).find('td#hhsacres').text().trim();
        var hhsmike = $(this).find('td#hhsmike').text().trim();
        var hearths = $(this).find('td#hearths').text().trim();
        var hearthsacres = $(this).find('td#hearthsacres').text().trim();
        var hearthsmike = $(this).find('td#hearthsmike').text().trim();
        var average = parseFloat($(this).find('td#average').text().trim());
        var uri_enc = encodeURIComponent(uri);
        geojsonstring += '{"type": "Feature", "properties": {"URI":"' + uri + '","parturis":"' + parturis + '","uri_enc":"' + uri_enc + '", "Label":"' + label + '", "Acres": ' + acres + ', "Hearths": ' + hearths + ',"hearthsacres": ' + hearthsacres + ', "Households": ' + households + ', "Households1": ' + households1 + ', "Households2": ' + households2 + ', "Households3": ' + households3 + ', "hhsacres": ' + hhsacres + ', "Average": ' + average + '},"geometry": {"type": "MultiPolygon", "coordinates": ' + polygon + ' }},';
    });
    geojsonstring.trim();
    geojsonstring = geojsonstring.substring(0, geojsonstring.length -1) + ']}';
    //console.log(geojsonstring);
    var geojson = JSON.parse(geojsonstring);
    return geojson;
};

//On changing parameter, change ranges
function adapt_parameters() {
    
    switch ($('select#parameter option:selected').val()) {
        case 'Average':
        $('input#val_xxs').val(1);
        $('input#val_xs').val(1.5);
        $('input#val_s').val(2);
        $('input#val_m').val(2.5);
        $('input#val_l').val(3);
        $('input#val_xl').val(3);
        break;
        case 'Households1':
        $('input#val_xxs').val(50);
        $('input#val_xs').val(60);
        $('input#val_s').val(70);
        $('input#val_m').val(80);
        $('input#val_l').val(90);
        $('input#val_xl').val(90);
        break;
        case 'Households3':
        case 'Difference':
        $('input#val_xxs').val(5);
        $('input#val_xs').val(10);
        $('input#val_s').val(15);
        $('input#val_m').val(20);
        $('input#val_l').val(25);
        $('input#val_xl').val(25);
        break;
        default:
        $('input#val_xxs').val(20);
        $('input#val_xs').val(40);
        $('input#val_s').val(60);
        $('input#val_m').val(80);
        $('input#val_l').val(100);
        $('input#val_xl').val(100);
    }
}

//Platzierung der Karte
var mymap = L.map('map').setView([53.9, -0.31], 9);
//Add FullScreen mode
mymap.addControl(new L.Control.Fullscreen());

//Einbinden der Grundkarte
L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
    maxZoom: 18, minZoom: 6,
    attribution: 'Map data © <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
    '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    id: 'mapbox.streets'
}).addTo(mymap);

// Einbinden der Geojson Karte
var shapes = toGeoJson();

function assert_parameters() {
    if (typeof geojson !== 'undefined') {
        geojson.remove();
    };
    var param = $('#parameter option:selected').val();
    var xxs = parseFloat($('input#val_xxs').val());
    var xs = parseFloat($('input#val_xs').val());
    var s = parseFloat($('input#val_s').val());
    var m = parseFloat($('input#val_m').val());
    var l = parseFloat($('input#val_l').val());
    geojson = L.geoJson(shapes, {
        style:
        //Füllfarben
        function (feature) {
            var mag = feature.properties[param];
            /*
             COLORCHART MIKE:
             #4040ff -> blue, cmyk(75%, 75%, 0%, 0%)
             #ff0000 -> red, cmyk(0%, 100%, 100%, 0%)
             #ff8099 -> dark orange, cmyk(0%, 50%, 40%, 0%)
             #ffb380 -> mid-orange, cmyk(0%, 30%, 50%, 0%)
             #ffd9bf -> light-orange, cmyk(0%, 15%, 25%, 0%)
             #ffffbf->  yellow, cmyk(0%, 0%, 25%, 0%)
             */
            if (mag > l) {
                
                return {
                    fillColor: "#4040ff"
                };
            } else if (mag > m) {
                return {
                    fillColor: "#ff0000" /*rot*/
                };
            } else if (mag > s) {
                return {
                    fillColor: "#ff8099" /*hellrot*/
                };
            } else if (mag > xs) {
                return {
                    fillColor: "#ffb380" /*orange*/
                };
            } else if (mag > xxs) {
                return {
                    fillColor: "#ffd9bf" /*rosa*/
                };
            } else {
                return {
                    fillColor: "#ffffbf" /*gelb*/
                };
            }
        },
        //Umriss
        color: "white",
        fillOpacity: 0.75,
        //Umrissbreite
        weight: 0.1,
        //Popup
        onEachFeature: function (feature, layer) {
            
            if (feature.properties.parturis != '') {
            var showuris = '';
              feature.properties.parturis.split(',').forEach(function (uri) {
              
                    showuris += "<a href='/query:htx.byplace?params=$1|%3C" + encodeURIComponent(uri) + "%3E'>" + uri + "</a><br/>";
                });
              }
              else
              {
                 var showuris = "<a href = '/query:htx.byplace?params=$1|%3C" + feature.properties.uri_enc + "%3E'>" + feature.properties.URI + "<a/></b>";
              };
            var popupText = "<b>Parish:</b> " + feature.properties.Label +
            "<br /><b>Acres: </b> " + feature.properties.Acres +
            "<br /><b>Households: </b> " + feature.properties.Households +
            "<br /><b>Households / 1000 acres:</b> " + feature.properties.hhsacres +
            "<br /><b>Hearths: </b> " + feature.properties.Hearths +
            "<br /><b>Hearths / 1000 acres: </b> " + feature.properties.hearthsacres +
            "<br /><b>Hearths / Household: </b> " + feature.properties.Average +
            "<br /><b>Taxpayers: </b></br>" + showuris;
            
            var tooltipText = feature.properties.Label + ': ' + feature.properties[param];
            
            layer.bindTooltip(tooltipText, {
                sticky: true
            });
            
            layer.bindPopup(popupText, {
                closeButton: true,
                offset: L.point(0, -20)
            });
            layer.on('click', function () {
                layer.openPopup();
            });
            layer.on('mouseover', function () {
                layer.openTooltip();
                this.setStyle({
                    fillOpacity: 0.25
                });
            });
            layer.on('mouseout', function () {
                this.setStyle({
                    fillOpacity: 0.75
                });
            });
        },
    }).addTo(mymap);
};
assert_parameters();

$('select#parameter').change(function () {
    adapt_parameters();
});

$('input#val_l').on('input', function () {
    $('input#val_xl').val($(this).val())
});