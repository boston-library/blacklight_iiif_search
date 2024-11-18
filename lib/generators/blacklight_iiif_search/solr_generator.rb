# frozen_string_literal: true

# adds iiif_suggest configuration to Solr solrconfig.xml and schema.xml
# to allow for suggestions limited by a contextField
require 'rails/generators'

module BlacklightIiifSearch
  class SolrGenerator < Rails::Generators::Base
    source_root ::File.expand_path('../templates', __FILE__)

    desc 'Adds iiif_suggest configuration to Solr solrconfig.xml and schema.xml'

    def inject_iiif_suggest_solrconfig
      return if IO.read('solr/conf/solrconfig.xml').include?('iiif_suggest')

      marker = '</config>'
      inject_into_file 'solr/conf/solrconfig.xml', before: marker do
        "  <!-- BEGIN Blacklight IIIF Search autocomplete config -->
  <!-- tokenizing-suggest is necessary to return only single terms from the suggester -->
  <!-- to use this, copy the blacklight_iiif_search/lib/generators/blacklight_iiif_search/templates/solr/lib/tokenizing-suggest-v1.0.1.jar -->
  <!-- to your Solr install's contrib directory, and uncomment the lines below. -->
  <!-- HOWEVER, this only works in Solr 7.*, see blacklight_iiif_search README for more info. -->
  <!-- <lib dir=\"${solr.install.dir:../../../..}/contrib\" regex=\"tokenizing-suggest-v1.0.1.jar\" /> -->
  <searchComponent name=\"iiif_suggest\" class=\"solr.SuggestComponent\">
    <lst name=\"suggester\">
      <str name=\"name\">iiifSuggester</str>
      <str name=\"lookupImpl\">AnalyzingInfixLookupFactory</str>
      <str name=\"dictionaryImpl\">DocumentDictionaryFactory</str>
      <str name=\"suggestAnalyzerFieldType\">textSuggest</str>
      <str name=\"contextField\">is_page_of_ssi</str>
      <str name=\"buildOnCommit\">true</str>
      <str name=\"field\">iiif_suggest</str>
      <!-- <str name=\"lookupImpl\">edu.stanford.dlss.search.suggest.analyzing.TokenizingLookupFactory</str> -->
      <!-- <str name=\"suggestTokenizingAnalyzerFieldType\">textSuggestTokenizer</str> -->
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

    def inject_iiif_suggest_schema
      filepath = 'solr/conf/schema.xml'
      return if IO.read(filepath).include?('iiif_suggest')

      field_type_marker = '</types>'
      inject_into_file filepath, before: field_type_marker do
        "\n    <!-- BEGIN Blacklight IIIF Search autocomplete config -->
    <!-- textSuggestTokenizer is only used by edu.stanford.dlss.search.suggest.analyzing.TokenizingLookupFactory -->
    <!-- this fieldType can be ignored if using Solr > 7, see blacklight_iiif_search README for more info. -->
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
  <copyField source=\"all_text_timv\" dest=\"iiif_suggest\"/>
  <!-- END Blacklight IIIF Search autocomplete config -->\n\n"
      end

      textsuggest_marker = /<fieldType[\s]*name="textSuggest"[^>]*>[\s]*<analyzer>[\s]*<tokenizer class="solr.KeywordTokenizerFactory"\/>/
      gsub_file(filepath, textsuggest_marker) do
        "<fieldType name=\"textSuggest\" class=\"solr.TextField\" positionIncrementGap=\"100\">
      <analyzer>
        <!-- Blacklight IIIF Search autocomplete suggester config requires StandardTokenizerFactory -->
        <!-- <tokenizer class=\"solr.KeywordTokenizerFactory\"/> -->
        <tokenizer class=\"solr.StandardTokenizerFactory\"/>"
      end
    end

    def copy_suggester_library
      copy_file 'solr/lib/tokenizing-suggest-v1.0.1.jar',
                'solr/lib/tokenizing-suggest-v1.0.1.jar'
    end
  end
end
