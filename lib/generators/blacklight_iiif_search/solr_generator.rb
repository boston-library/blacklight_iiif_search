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
        inject_into_file 'solr/conf/solrconfig.xml', before: marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
  <!-- solr-tokenizing_suggester is necessary to return single terms from the suggester -->
  <lib dir=\"${solr.install.dir:../../../..}/contrib\" regex=\"tokenizing-suggest-v1.0.1.jar\" />\n
  <searchComponent name=\"iiif_suggest\" class=\"solr.SuggestComponent\">
    <lst name=\"suggester\">
      <str name=\"name\">iiifSuggester</str>
      <str name=\"lookupImpl\">edu.stanford.dlss.search.suggest.analyzing.TokenizingLookupFactory</str>
      <str name=\"dictionaryImpl\">DocumentDictionaryFactory</str>
      <str name=\"suggestAnalyzerFieldType\">textSuggest</str>
      <str name=\"suggestTokenizingAnalyzerFieldType\">textSuggestTokenizer</str>
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
        inject_into_file filepath, before: field_type_marker do
          "\n    <!-- BEGIN Blacklight IIIF Search autocomplete config -->
    <fieldType name=\"textSuggestTokenizer\" class=\"solr.TextField\" positionIncrementGap=\"100\">
      <analyzer>
        <tokenizer class=\"solr.WhitespaceTokenizerFactory\"/>
        <filter class=\"solr.StopFilterFactory\" ignoreCase=\"true\" words=\"stopwords_en.txt\"/>
        <filter class=\"solr.WordDelimiterGraphFilterFactory\"/>
        <filter class=\"solr.LowerCaseFilterFactory\"/>
        <filter class=\"solr.HyphenatedWordsFilterFactory\"/>
        <filter class=\"solr.RemoveDuplicatesTokenFilterFactory\"/>
        <!-- uncomment below to enable multi-word matches -->
        <!-- <filter class=\"solr.ShingleFilterFactory\" outputUnigrams=\"true\" outputUnigramsIfNoShingles=\"true\" maxShingleSize=\"3\" /> -->
      </analyzer>
    </fieldType>
    <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end

        fields_marker = '</fields>'
        inject_into_file filepath, before: fields_marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
   <field name=\"iiif_suggest\" type=\"textSuggest\" indexed=\"true\" stored=\"true\" multiValued=\"true\" />
   <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end

        copy_marker = '</schema>'
        inject_into_file filepath, before: copy_marker do
          "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
  <copyField source=\"text\" dest=\"iiif_suggest\"/>
  <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
        end
      end
    end

    def copy_suggester_library
      copy_file 'solr/lib/solr-tokenizing_suggester-7.x.jar',
                'solr/lib/solr-tokenizing_suggester-7.x.jar'
    end
  end
end
