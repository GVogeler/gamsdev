/*Project: GAMS Hearthtax
Author: Jakob Sonnberger
Company: ZIM-ACDH (Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities)*/

//////////////////////
/*CSV Export Button*/

$('a#to_CSV').on("click", function () {
    //on Export-Button click
    databasket2csv();
});

///////////////////////
/*Local Storage to CSV*/
function databasket2csv() {
    var csv = '"sep=,"\nID,text,hearths,paid,place,book,date\n';
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    $('span#daba_length').html(itemsArray.length);
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        csv += '"' + itemsArray[outerCount].xml_id + '","' + itemsArray[outerCount].text + '","' + itemsArray[outerCount].hearths + '","' + itemsArray[outerCount].status + '","' + itemsArray[outerCount].place + '","' + itemsArray[outerCount].book + '","' + itemsArray[outerCount].date + '"\n';
    };
    //console.log(csv);
    //create, click and remove fake download link
    var fakeLink = document.createElement('a');
    fakeLink.setAttribute('href', 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv));
    fakeLink.setAttribute('download', 'databasket.csv');
    
    fakeLink.style.display = 'none';
    document.body.appendChild(fakeLink);
    
    fakeLink.click();
    
    document.body.removeChild(fakeLink);
};

///////////////////////
/*checkbox grouping*/

$('input:checkbox.cb_head').on('change', function () {
    //get entry from localStorage...
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    //if any head_checkbox gets checked...
    if ($(this).is(':checked')) {
        $(this).closest('div').find('input:checkbox').each(function () {
            // ...all sub-level checkboxes check
            $(this).prop('checked', true);
        });
        $(this).closest('div').find('input:checkbox.cb').each(function () {
            //create JS-object...
            if ($(this).parent('td').length) {
                //if checkbox is situated in table (=Database-View)
                var tr = $(this).closest('tr');
                
                var xml_id = tr.find('td:nth-of-type(1)').text().trim();
                var text = tr.find('td:nth-of-type(2)').clone().children().remove().end().text().trim();
                //removes the 'same-name'-link
                var hearths = tr.find('td:nth-of-type(3)').text().trim();
                var status = tr.find('td:nth-of-type(4)').text().trim();
                var place = tr.find('td:nth-of-type(5)').text().trim();
                var book = tr.find('td:nth-of-type(6)').text().trim();
                var date = tr.find('td:nth-of-type(7)').text().trim() || '';
            } else {
                //(Transcript-View)
                var p = $(this).closest('p');
                
                var xml_id = p.attr('xml:id');
                var text = p.find('span.text').text().replace(/[\s\n\r]+/g, ' ').trim() || '';
                //getting the note text from the comment boxes in transcripts
                p.find('span.oi').each(function () {
                    text += " [" + $(this).attr('data-original-title') + "]"
                });
                var hearths = p.find('span.hearths').attr('data-n') || '';
                var status = p.closest('div.status').attr('data-status') || '';
                var place = p.closest('div.place').attr('data-place') || '';
                var book = p.closest('article').attr('data-book').trim() || '';
                var date = p.closest('article').attr('data-taxationDate'.trim()) || '';
            }
            var new_entry = {
                'xml_id': xml_id,
                'text': text,
                'hearths': hearths,
                'status': status,
                'place': place,
                'book': book,
                'date': date
            };
            //...and if entries are NOT in databasket yet...
            var in_array = false;
            for (var outerCount = 0;
            outerCount < itemsArray.length;
            outerCount++) {
                var item_id = itemsArray[outerCount].xml_id;
                if (item_id == xml_id) {
                    in_array = true;
                }
            };
            if (in_array == false) {
                //add new entry to Array...
                itemsArray.push(new_entry)
            }
        });
    }
    
    //if any heading-checkbox unchecks...
    else {
        $(this).closest('div').find('input:checkbox').each(function () {
            //...all sub-level checkboxes uncheck
            $(this).prop('checked', false);
            //...and their entries are removed from localStorage
            var xml_id = $(this).closest($('p, tr')).attr('xml:id');
            for (var outerCount = 0;
            outerCount < itemsArray.length;
            outerCount++) {
                var item_id = itemsArray[outerCount].xml_id;
                if (item_id == xml_id) {
                    //remove entry from selection
                    itemsArray.splice(outerCount, 1);
                }
            }
        });
    };
    //commit back to localStorage
    localStorage.setItem('hearthtax_databasket', JSON.stringify(itemsArray));
    //update Databasket Counter
    $('span#daba_length').html(itemsArray.length);
});

$('input:checkbox.cb').on('change', function () {
    //if any entry-checkbox gets checked...
    if ($(this).is(':checked')) {
        //...entry goes to databasket
        to_databasket(this);
    }
    //if any entry-checkbox gets UNchecked...
    else {
        //remove entry from localStorage
        remove_from_localStorage(this);
        //head_checkbox uncheck
        $(this).parents('div').find('input:checkbox.cb_head').prop('checked', false);
    }
});

$(document).on("click", 'span.delete_entry', function () {
    //remove entry from localStorage
    remove_from_localStorage(this);
    //remove table row
    $(this).closest($('p, tr')).remove();
    //get & draw sum
    $('td#daba_sum').html(get_databasket_sum());
});

$("button#clear_databasket").on("click", function () {
    clear_databasket()
});

$(document).on("click", 'article#databasket table span.oi-elevator', function () {
    sort_databasket(this.id);
    $('article#databasket table span.sort').attr('class', 'sort oi oi-elevator');
    $(this).attr('class', 'sort oi oi-caret-top');
});

$(document).on("click", 'article#databasket table span.oi-caret-top', function () {
    sort_databasket(this.id, 'reverse');
    // commit 'reverse' for descending sortation
    $('article#databasket table span.sort').attr('class', 'sort oi oi-elevator');
    $(this).attr('class', 'sort oi oi-caret-bottom');
});

$(document).on("click", 'article#databasket table span.oi-caret-bottom', function () {
    sort_databasket(this.id);
    $('article#databasket table span.sort').attr('class', 'sort oi oi-elevator');
    $(this).attr('class', 'sort oi oi-caret-top');
});
////////////////////////////////////////////////////////////////////////FUNCTIONS////////////////////////////////////////////////////////////////////////

////////////////////////////////////
/*show number of databasket-entries*/

function count_databasket() {
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    $('span#daba_length').html(itemsArray.length);
};

/////////////////////////
/*adding to databasket*/

function to_databasket(trigger) {
    if ($(trigger).parent('td').length) {
        //if checkbox is situated in table (=Database-View)
        var tr = $(trigger).closest('tr');
        
        var xml_id = tr.find('td:nth-of-type(1)').text().trim();
        var text = tr.find('td:nth-of-type(2)').clone().children().remove().end().text().trim();
        //removes the 'same-name'-link
        var hearths = tr.find('td:nth-of-type(3)').text().trim();
        var status = tr.find('td:nth-of-type(4)').text().trim();
        var place = tr.find('td:nth-of-type(5)').text().trim();
        var book = tr.find('td:nth-of-type(6)').text().trim();
        var date = tr.find('td:nth-of-type(7)').text().trim() || '';
    } else {
        //(Transcript-View)
        var p = $(trigger).closest('p');
        
        var xml_id = p.attr('xml:id');
        var text = p.find('span.text').text().replace(/[\s\n\r]+/g, ' ').trim() || '';
        //getting the note text from the comment boxes in transcripts
        p.find('span.oi').each(function () {
            text += " [" + $(this).attr('data-original-title') + "]"
        });
        var hearths = p.find('span.hearths').attr('data-n') || '';
        var status = p.closest('div.status').attr('data-status') || '';
        var place = p.closest('div.place').attr('data-place') || '';
        var book = p.closest('article').attr('data-book') || '';
        var date = p.closest('article').attr('data-taxationDate').trim() || '';
    }
    var new_entry = {
        'xml_id': xml_id,
        'text': text,
        'hearths': hearths,
        'status': status,
        'place': place,
        'book': book,
        'date': date
    };
    //get entry from localStorage...
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    //...add new entry...
    itemsArray.push(new_entry);
    //update Databasket Counter
    $('span#daba_length').html(itemsArray.length);
    //and commit back to localStorage
    localStorage.setItem('hearthtax_databasket', JSON.stringify(itemsArray));
};

/////////////////////////////
/*creating databasket table*/

function show_databasket() {
    //clear table body
    $('article#databasket table tbody').empty();
    var server = $('article').attr('data-server');
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        $('article#databasket table tbody').append('<tr xml:id="' + itemsArray[outerCount].xml_id + '"><td><a href="' + server + '/o:htx.' + itemsArray[outerCount].xml_id + '">' + itemsArray[outerCount].xml_id + '</a></td><td>' +
        itemsArray[outerCount].text + '</td><td>' + itemsArray[outerCount].hearths + '</td><td>' + itemsArray[outerCount].status + '</td><td>' +
        itemsArray[outerCount].place + '</td><td>' + itemsArray[outerCount].book + '</td><td>' + itemsArray[outerCount].date +
        '</td><td><span class="oi oi-trash delete_entry"></span></td></tr>');
    };
    //get & draw sum
    $('td#daba_sum').html(get_databasket_sum());
};

/////////////////////////////////////////////////
/*removes entry from localstorage*/

function remove_from_localStorage(trigger) {
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        var item_id = itemsArray[outerCount].xml_id;
        var entry_id = $(trigger).closest($('tr, p')).attr('xml:id');
        if (item_id == entry_id) {
            //remove entry from selection
            itemsArray.splice(outerCount, 1);
        }
    }
    //update Databasket Counter
    $('span#daba_length').html(itemsArray.length);
    //and commit back to localStorage
    localStorage.setItem('hearthtax_databasket', JSON.stringify(itemsArray));
};

////////////////////////////////////
/*clear databasket (+localstorage)*/

function clear_databasket() {
    //clear localStorage
    localStorage.clear();
    //clear table body
    $('article#databasket table tbody').empty();
    //reset sum in tfoot
    $('td#daba_sum').html(get_databasket_sum());
    //reset sum in navbar
    $('span#daba_length').html(get_databasket_sum());
};

///////////////////////////////////////////////////
/*checks if entry allready exists in localstorage*/

function is_in_localStorage(trigger) {
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        var item_id = itemsArray[outerCount].xml_id;
        var entry_id = $(trigger).closest($('p, tr')).attr('xml:id');
        if (item_id == entry_id) {
            //return true if entry exists
            return true;
        };
    };
};

//////////////////////////////////////
/*enable checkboxes after page load*/

function enable_checkboxes() {
    $('input:checkbox').prop('disabled', false);
};

///////////////////////////////////
/*checkbox check after page load*/

function check_checkboxes() {
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        $('p, tr').each(function () {
            if ($(this).attr('xml:id') == itemsArray[outerCount].xml_id) {
                $(this).find('input:checkbox.cb').prop('checked', true);
            };
        });
    };
};

/////////////////////////////
/*calculate databasket sum*/

function get_databasket_sum() {
    var daba_sum = 0;
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    for (var outerCount = 0;
    outerCount < itemsArray.length;
    outerCount++) {
        if ($.isNumeric(itemsArray[outerCount].hearths)) {
            daba_sum += parseInt(itemsArray[outerCount].hearths);
        }
    };
    return daba_sum
};

///////////////////////////////////
/*sort function databasket/////*/

function sort_databasket(category, direction) {
    var itemsArray = JSON.parse(localStorage.getItem('hearthtax_databasket')) ||[];
    //re-sort array ascending
    itemsArray.sort(function (a, b) {
        var x = ($.isNumeric(a[category]) ? parseInt(a[category]): a[category].toUpperCase().replace(/\s+/g, ""));
        var y = ($.isNumeric(b[category]) ? parseInt(b[category]): b[category].toUpperCase().replace(/\s+/g, ""));
        return ((x < y) ? -1: (x > y) ? 1: 0);
    });
    // commit 'reverse' for descending sortation
    if (direction == 'reverse') itemsArray.reverse();
    //commit back to localStorage
    localStorage.setItem('hearthtax_databasket', JSON.stringify(itemsArray));
    show_databasket();
};