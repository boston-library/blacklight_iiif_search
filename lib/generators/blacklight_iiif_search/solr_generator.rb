# adds iiif_suggest SuggestComponent to solrconfig.xml
# to allow for suggestions limited by a contextField
require 'rails/generators'

module BlacklightIiifSearch
  class SolrGenerator < Rails::Generators::Base
    source_root ::File.expand_path('../templates', __FILE__)

    desc 'Adds iiif_suggest SuggestComponent to solrconfig.xml'

    #def copy_solr_conf
    #  directory 'solr', force: true
    #end

    def inject_iiif_suggest
      unless IO.read('solr/conf/solrconfig.xml').include?('iiif_suggest')
        marker = '</config>'
        insert_into_file 'solr/conf/solrconfig.xml', before: marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
  <searchComponent name=\"iiif_suggest\" class=\"solr.SuggestComponent\">
    <lst name=\"suggester\">
      <str name=\"name\">iiifSuggester</str>
      <str name=\"lookupImpl\">AnalyzingInfixLookupFactory</str>
      <str name=\"highlight\">false</str>
      <str name=\"dictionaryImpl\">DocumentDictionaryFactory</str>
      <str name=\"suggestAnalyzerFieldType\">iiif_suggest</str>
      <!-- <str name=\"suggestTokenizingAnalyzerFieldType\">textSuggestTokenizer</str> -->
      <str name=\"contextField\">is_page_of_s</str>
      <str name=\"buildOnCommit\">true</str>
      <str name=\"field\">iiif_suggest</str>
    </lst>
  </searchComponent>\n
  <requestHandler name=\"/iiif_suggest\" class=\"solr.SearchHandler\" startup=\"lazy\">
    <lst name=\"defaults\">
      <str name=\"suggest\">true</str>
      <str name=\"suggest.count\">5</str>
      <str name=\"suggest.dictionary\">iiifSuggester</str>
    </lst>
    <arr name=\"components\">
      <str>iiif_suggest</str>
    </arr>
  </requestHandler>
  <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end
      end
    end

    # TODO some injection into Solr schema.xml for:
    #  - iiif_suggest fieldType
    #  - iiif_suggest field
    #  - copyField text -> iiif_suggest

  end
end