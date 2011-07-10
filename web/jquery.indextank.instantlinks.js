(function($){
    if(!$.Indextank){
        $.Indextank = new Object();
    };
    
    $.Indextank.InstantLinks = function(el, options){
        // To avoid scope issues, use 'base' instead of 'this'
        // to reference this class from internal events and functions.
        var base = this;
        
        // Access to jQuery and DOM versions of element
        base.$el = $(el);
        base.el = el;
        
        // Add a reverse reference to the DOM object
        base.$el.data("Indextank.InstantLinks", base);

        base.options = $.extend({},$.Indextank.InstantLinks.defaultOptions, options);

        base.init = function(){
            // Put your initialization code here
            var ize = $(base.el.form).data("Indextank.Ize");

            base.$el.autocomplete({
                select: function( event, ui ) {
                  window.location.href = ui.item[base.options.fieldUrl];
                },
                source: function ( request, responseCallback ) {
                  $.ajax( {
                      url: ize.apiurl + "/v1/indexes/" + ize.indexName + "/instantlinks",
                      dataType: "jsonp",
                      data: { query: request.term, field: base.options.fieldName, fetch: base.options.fields },
                      success: function( data ) {
                            // augment results, so that they contain the matched query
                            var results = $.map(data.results, function(r) {
                                r.queryTerm = request.term;
                                return r;
                            });
                            responseCallback(results);
                      }
                  } );
                },
                minLength: base.options.minLength,
                delay: base.options.delay,
                //autoFocus: true
              
            })
            .data( "autocomplete" )._renderItem = function( ul, item) {
                // create the list entry
                var $li = $("<li/>").addClass("result").data("item", item);

                // append a formatted item. 
                $li.append(base.options.format(item, base.options));
                    
                // put the li back on the ul
                return $li.appendTo( ul );
            };
        };
        
        // Run initializer
        base.init();
    };
    
    $.Indextank.InstantLinks.defaultOptions = {
        fieldName: "name",
        fieldUrl: "url",
        fieldThumbnail: "thumbnail",
        fieldDescription: "description",
        fields: "name,url,thumbnail,description",
        minLength: 2,
        delay: 100,
        format: function( item , options ) {

            function hl(text, query){
                rx = new RegExp(query,'i');
                bolds = $.map(text.match(rx) || [], function(i) { return "<span class='highlighted'>"+i+"</span>";});
                regulars = $( $.map(text.split(rx), function(i){ return $("<span></span>").addClass("regular").text(i).get(0);}));

                return regulars.append(function(i, h) {
                    return bolds[i] || ""; 
                });
            };


            var name = item[options.fieldName];
            var highlightedName = hl(name, item.queryTerm);
            
            
            var l =  $("<a></a>").attr("href", item[options.fieldUrl]);

            // only display images for those documents that have one
            if (item[options.fieldThumbnail]) {
                l.addClass("with-thumbnail");
                l.append( $("<img />")
                            .attr("src", item[options.fieldThumbnail])
                            .css( { "max-width": "50px", "max-height": "50px"} ) ) ;
            }

            l.append( $("<span/>").addClass("name").append(highlightedName) );
            
            // only add description for those documents that have one
            if (item[options.fieldDescription]) { 
                l.addClass("with-description");
                l.append( $("<span/>").addClass("description").text(item[options.fieldDescription]));
            }

            return l;
        }
    };

    $.fn.indextank_InstantLinks = function(options){
        return this.each(function(){
            (new $.Indextank.InstantLinks(this, options));
        });
    };

})(jQuery);
