# adds iiif_suggest configuration to Solr solrconfig.xml and schema.xml
# to allow for suggestions limited by a contextField
require 'rails/generators'

module BlacklightIiifSearch
  class SolrGenerator < Rails::Generators::Base
    source_root ::File.expand_path('../templates', __FILE__)

    desc 'Adds iiif_suggest configuration to Solr solrconfig.xml and schema.xml'

    def inject_iiif_suggest_solrconfig
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

    def inject_iiif_suggest_schema
      filepath = 'solr/conf/schema.xml'
      unless IO.read(filepath).include?('iiif_suggest')
        field_type_marker = '</types>'
        insert_into_file filepath, before: field_type_marker do
          "\n    <!-- BEGIN Blacklight IIIF Search autocomplete config -->
    <fieldType name=\"iiif_suggest\" class=\"solr.TextField\" positionIncrementGap=\"100\">
      <analyzer>
        <tokenizer class=\"solr.WhitespaceTokenizerFactory\"/>
        <filter class=\"solr.ICUFoldingFilterFactory\"/>
        <filter class=\"solr.WordDelimiterGraphFilterFactory\"/>
        <filter class=\"solr.LowerCaseFilterFactory\"/>
        <filter class=\"solr.HyphenatedWordsFilterFactory\"/>
        <filter class=\"solr.RemoveDuplicatesTokenFilterFactory\"/>
      </analyzer>
    </fieldType>
    <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end

        fields_marker = '</fields>'
        insert_into_file filepath, before: fields_marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
   <field name=\"iiif_suggest\" type=\"iiif_suggest\" indexed=\"true\" stored=\"true\" multiValued=\"true\" />
   <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end

        copy_marker = '</schema>'
        insert_into_file filepath, before: copy_marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
  <copyField source=\"text\" dest=\"iiif_suggest\"/>
  <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end
      end
    end
  end
end
