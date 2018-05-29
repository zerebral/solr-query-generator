# solr-query-generator
A custom search query generator for Solr - used for load testing Solr

Usage: 

ruby lib/generator.rb --solr-endpoint http://10.20.30.40:8983/solr/your_collection_name/select \
                     --output-path ~/out \ 
                     --min-year 2013 \
                     --search-level=make,model,year \ 
                     --build-geospatial \
                     --min-geospatial-distance 75
                     
Available command line parameter are - 
Options:
  -o, --output-size=<i>                            Size of the output sample set (default: 100)
  -s, --solr-endpoint=<s>                          Solr endpoint base url
  -b, --build-geospatial, --no-build-geospatial    Flag indicating whether to build geospatial queries or not (default: true)
  -f, --facet-fields=<s>                           List of fields to generate facets for (default: make_ss,model_ss,trim_ss,trim_r_ss,tramsmission_ss,interior_color_ss,exterior_color_ss)
  -t, --stats-fields=<s>                           List of fields to generate stats for (default: price_fs,miles_fs,dom_active_is)
  -u, --build-median, --no-build-median            Flag to indicate whether to build median or not in the stats output (default: true)
  -e, --search-level=<s>                           Param to set the search level - year,make,model,trim | if only year,make is present then search queries will include only year and make fields (default: year,make,model)
  -m, --min-year=<i>                               Minimum year value to use
  -p, --output-path=<s>                            Output file path of the sample
  -d, --default-filters=<s>                        List of default filters to apply on each (default: data_source_ss:mc AND inventory_type_ss:used)
  -i, --min-geospatial-distance=<i>                Distance value to use for geo filtering, in miles (default: 60)
  -r, --sort-order=<s>                             Sort order for results
  -l, --fl=<s>                                     Solr output field list - fl parameter (default: )
  -w, --rows=<i>                                   Rows to return for Search API call (default: 25)
  -a, --start=<i>                                  Start offset to return results for Search API call from (default: 0)
  -h, --help                                       Show this message

              
Most of these parameters are generic enough to be applied to any Solr collection.
