require 'json'
require 'net/http'


HYRISE_DEFAULT_URL = URI('http://192.168.30.31:5000/')

def query(data, url = HYRISE_DEFAULT_URL)
	req = Net::HTTP::Post.new(url.path)
	req.set_form_data({:query=> data, :limit => 0})

	response = Net::HTTP.new(url.host, url.port).start {|http|
      http.read_timeout = nil
      http.request(req)
    }

    response_body = response.body
    json = JSON.parse(response_body)

    jj json
    json
end

def build_layout_op(table, layout, core=7)
  {
    "core" => core,
    "operators" => {
      "get" => {
        "type" => "GetTable",
        "core" => core,
        "name" => "#{table}"
      },
      "layout" => {
        "type" => "LayoutTable",
        "layout" => "#{File.read(layout)}",
        "core" => core
      },
      "replace" => {
        "type" => "ReplaceTable",
        "core" => core,
        "name" => "#{table}"
      },
      "noop" => {
        "type" => "NoOp",
        "core" => core
      }
    },
    "edges" => [
                ["get", "layout"],
                ["layout", "replace"],
                ["replace", "noop"]
               ]
  }
end

def build_operator(query_type, weight, selectivity, attributes)
	{
		"type" => query_type,
		"selectivity" => selectivity.to_f,
		"weight" => weight,
		"attributes" => attributes
	}
end


def build_query(attributes, operators)
	{"edges" => [["0","0"]], 
		"operators"  => { "0" => {
		"attributes" => attributes,
		"max_results" => 1,
		"num_rows" => 3000000,
		"operators" => operators,
		"type" => "LayoutSingleTable",
		"layouter" => "CandidateLayouter"}}
	}
end
