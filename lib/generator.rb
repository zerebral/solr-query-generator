require "ap"
require 'json'
require "trollop"
require "csv"
require "addressable/uri"
require "./lib/utils/cities.rb"
require "./lib/utils/functions.rb"
require "uri"

@opts = Trollop::options do
  opt "output-size", "Size of the output sample set", :type => :integer, :default=> 100
  opt "solr-endpoint", "Solr endpoint base url", :default => nil, :type => :string, :required => true
  opt "build-geospatial", "Flag indicating whether to build geospatial queries or not",  :type => :boolean, :default => true
  opt "facet-fields", "List of fields to generate facets for",  :type => :string, :default => "make_ss,model_ss,trim_ss,trim_r_ss,tramsmission_ss,interior_color_ss,exterior_color_ss"
  opt "stats-fields", "List of fields to generate stats for",  :type => :string, :default => "price_fs,miles_fs,dom_active_is"
  opt "build-median", "Flag to indicate whether to build median or not in the stats output",  :type => :boolean, :default => true
  opt "search-level", "Param to set the search level - year,make,model,trim | if only year,make is present then search queries will include only year and make fields",  :type => :string, :default => "year,make,model"
  opt "min-year", "Minimum year value to use", :type => :integer, :required => false
  opt "output-path", "Output file path of the sample", :type => :string, :required => true
  opt "default-filters", "List of default filters to apply on each", :type => :string, :default => "data_source_ss:mc AND inventory_type_ss:used"
  opt "min-geospatial-distance", "Distance value to use for geo filtering, in miles", :type => :integer, :default => 60
  opt "sort-order", "Sort order for results", :type => :string
  opt "fl", "Solr output field list - fl parameter", :type => :string, :default => ""
  opt "rows", "Rows to return for Search API call", :type => :integer, :default => 25
  opt "start", "Start offset to return results for Search API call from", :type => :integer, :default => 0
end

ap @opts

ymm_data = File.readlines("./data/ymmt.csv")

output_sample = []

while true do
  line = CSV.parse(ymm_data.sample.gsub("\n", ""))[0] rescue next

  next if @opts["min-year"] && (line[0].to_i < @opts["min-year"])

  q = generate_solr_query(line) rescue next
  ap q

  output_sample << "#{@opts["solr-endpoint"]}?#{URI.encode_www_form(q)}"
  break if output_sample.size >= @opts["output-size"]
end

open(@opts["output-path"], 'w') { |f|
  output_sample.each {|l| f.puts l}
}


