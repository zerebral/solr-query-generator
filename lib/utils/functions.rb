def all_cases_combos(string)
  ["\"#{string}\"", "\"#{string.upcase}\"", "\"#{string.downcase}\"", "\"#{string.capitalize}\""].uniq
end

def generate_solr_query(line)
 q = []

 q.concat build_search(line)
 q.concat build_facets if @opts["facet-fields"]
 q.concat build_stats if @opts["stats-fields"]
 q.concat build_geospatial if @opts["build-geospatial"]
 q.concat [["rows", @opts["rows"]]] if @opts["rows"]
 q.concat [["sort", @opts["sort-order"]]] if @opts["sort-order"]
 q
end

def build_facets
  q = [[:facet, true]]
  @opts["facet-fields"].split(",").each{|f|
    q << ["facet.field", f]
  }
  q
end

def build_stats
  q = [[:stats, true]]
  @opts["stats-fields"].split(",").each{|f|
    if @opts["build-median"]
      q << ["stats.field", "{!min=true mean=true max=true count=true missing=true sum=true sumOfSquares=true stddev=true percentiles=\"50\"}" + f]
    else
      q << ["stats.field", f]
    end
  }
  q
end

def build_geospatial
  q = [[:fq, "{!geofilt field=location_ll}"], [:sfield, "location_ll"]]

  city = US_CITIES.sample
  q << ["d", @opts["min-geospatial-distance"] * 1.61]
  q << ["pt", "#{city["latitude"]},#{city["longitude"]}"]

  q
end

def build_search(line)
  q = []

  @opts["default-filters"].split(" AND ").each{|x|
    q << [x.split(":")[0], x.split(":")[1]]
  }

  q << ["year_is", line[0]] if @opts["search-level"].include? "year"
  q << ["make_ss", "(" + all_cases_combos(line[1]).join(" ") + ")"] if @opts["search-level"].include? "make"
  q << ["model_ss", "(" + all_cases_combos(line[2]).join(" ") + ")"] if @opts["search-level"].include? "model"
  q << ["trim_ss", "(" + all_cases_combos(line[3]).join(" ") + ")"] if(@opts["search-level"].include?("trim") && (line[3] && !line[3].empty?))

  q = [["q", q.map{|x| "#{x[0]}:#{x[1]}"}.join(" AND ")]]

  q
end


