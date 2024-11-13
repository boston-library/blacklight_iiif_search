# Blacklight IIIF Search

![CI Workflow](https://github.com/boston-library/blacklight_iiif_search/actions/workflows/ruby.yml/badge.svg)

A plugin that provides IIIF Content Search functionality for [Blacklight](https://github.com/projectblacklight/blacklight)-based applications.

[IIIF Content Search](http://iiif.io/api/search/1.0) is an API specification for searching the full text of a resource that is described by a [IIIF Presentation API](https://iiif.io/api/presentation/2.1) manifest.

When installed, this plugin provides an endpoint in your Blacklight app that will return a JSON response conforming to IIIF Content Search API v. 1.0.

By integrating the URL for this service into your IIIF Presentation manifests, clients/viewers that support the IIIF Content Search API (such as the [Universal Viewer](https://universalviewer.io/)) will be able to provide functionality for searching within a resource and displaying results.

## Prerequisites

This plugin assumes:
1. You have a working Blacklight application, with Solr as the search index
2. You have items with full text (e.g. scanned books, newspapers, etc.) in your Solr index
3. The text for these items is indexed in Solr
4. Each page has its own Solr record, with the corresponding text in a discrete field 
    * the text field must be indexed
    * if search term highlighting is desired, the text field must be indexed and stored
5. The relationship between page records and their parent book/volume/issue/etc records is indexed in Solr

Blacklight/Solr Version Compatibility:

| blacklight_iiif_search version | works with Blacklight | tested with Solr |
|--------------------------------|-----------------------|------------------|
| 3.0                            | ~> 8.0                | >= 7.0 to < 9.*  |
| 2.0                            | ~> 7.0                | 7.*              |
| 1.0                            | >= 6.3.0 to < 7.*     | 7.*              |


## Installation

Add Blacklight IIIF Search to your `Gemfile`:

```ruby
gem 'blacklight_iiif_search'
```

Run the install generator, which will copy over some initial templates, routes, and configuration:

```bash
$ rails generate blacklight_iiif_search:install
```

The generator:
* Adds some configuration settings to `app/controller/catalog_controller.rb`
* Adds the `IiifSearchBuilder` class to `app/models`
* Adds routing to `config/routes.rb`
* Injects some configuration into `solr/conf/schema.xml` and `solr/conf/solrconfig.xml` to support contextual autocomplete
  (To skip the Solr changes, run the install command with `skip-solr` flag.)

After install, you'll probably need to adjust the `iiif_search` settings in `CatalogController`:

Config option | Description 
------------------------ | -------------------------------------------------------------
`full_text_field`        | The Solr field where the OCR text is indexed/stored.
`object_relation_field`  | The Solr field where the parent/child relationship is stored.
`supported_params`       | An array of IIIF Content Search [query parameters](http://iiif.io/api/search/1.0/#query-parameters) supported by the search service. (Note: `motivation`, `date`, and `user` are not currently supported.)
`autocomplete_handler`   | The value of the @name attribute for the Solr `<requestHandler name="/#{autocomplete_handler}">` in solrconfig.xml that handles autocomplete suggestions.  
`suggester_name`         | The value of the `<str name="name">#{suggester_name}</str>` element for the Solr <searchComponent> in solrconfig.xml that handles autocomplete suggestions.

See below for additional customization options.

## Basic Usage

The search service will be available at:
```
http://host:port/catalog/:id/iiif_search
```
There is a `solr_document_iiif_search` route helper that can be called to construct a path or URL to the search service in your app. For example:
```ruby
solr_document_iiif_search_url('abcd1234', {q: 'blacklight'})
```
Would return:
```
http://host:port/catalog/abcd1234/iiif_search?q=blacklight
```
The autocomplete service will be available at:
```
http://host:port/catalog/:id/iiif_suggest
```
There is a `solr_document_iiif_suggest` route helper that can be called to construct a path or URL to the autocomplete service in your app. For example:
```ruby
solr_document_iiif_suggest_url('abcd1234', {q: 'blacklight'})
```
Would return:
```
http://host:port/catalog/abcd1234/iiif_suggest?q=blacklight
```

## Implementation
In order to successfully deploy this plugin, you'll most likely need to customize a few things to match how your Solr index and/or repository are set up.

**Parent/child relationship**

The plugin needs to construct Solr query parameters such that only records that represent children/members (e.g. pages) of the parent work are returned. The out-of-the-box default is:
```ruby
{is_page_of_ssi: 'parent_id'}
```
Where `parent_id` is the identifier of the parent object. The above assumes that each page record has an indexed `is_page_of_ssi` field that indicates its parent.
 
To customize the construction of the parent/child object relationship Solr parameters (beyond the name of the field, which can be set in the `CatalogController` config), create a local copy of the `BlacklightIiifSearch::IiifSearchBehavior` module in `app/models/concerns/blacklight_iiif_search/iiif_search_behavior.rb` and override the `#object_relation_solr_params` method.

**Default search settings**

A `IiifSearchBuilder` class will be available in your app's `app/models` directory, and can be customized as needed, especially with regards to Solr's highlighting settings.

**URI constructors**

As part of the JSON response, the plugin needs to construct URIs for IIIF Annotation objects representing the search hits, and IIIF Canvas objects corresponding to the pages of the item. 

To customize these URIs (including the addition of word/image coordinates to facilitate hit highlighting in a viewer), create a local copy of the `BlacklightIiifSearch::IiifSearchAnnotationBehavior` module in `app/models/concerns/blacklight_iiif_search/iiif_search_annotation_behavior.rb` and override the appropriate methods.

_Important notes_: 
* The base URI returned by `#canvas_uri_for_annotation` must match the `@id` value of the corresponding Canvas in your IIIF manifest.
* The URI returned by `#canvas_uri_for_annotation` must additionally end with the `#xywh=Integer,Integer,Integer,Integer` syntax in order to work with the Universal Viewer.

**Linking to the Search service from your IIIF manifest**

In order for a viewer application to be aware of the search service, you need to include the following in your IIIF manifest:
```json
"service": {
  "@context": "http://iiif.io/api/search/0/context.json",
  "@id": "http://host:port/catalog/:id/iiif_search",
  "profile": "http://iiif.io/api/search/0/search",
  "label": "Search within this item"
}
```
The value of `@id` should be replaced with the link to the search service for the item. The text of `label` can be whatever you want.

To make a viewer aware of the autocomplete service, include the following in your IIIF manifest:
```json
"service": {
  "@context": "http://iiif.io/api/search/0/context.json",
  "@id": "http://host:port/catalog/:id/iiif_search",
  "profile": "http://iiif.io/api/search/0/search",
  "label": "Search within this item",
  "service": {
    "@id": "http://example.org/services/identifier/autocomplete",
    "profile": "http://iiif.io/api/search/0/autocomplete"
  }
}
```
_Important note_: Although the current version (as of June 2018) of the Content Search API is `http://iiif.io/api/search/1.0`, the Universal Viewer will NOT automatically recognize the search service unless the `@context` and `profile` URIs use `http://iiif.io/api/search/0/` as the base.

**Configuring Solr for contextual autocomplete**

Solr >=5.4 provides the ability to do _contextual_ autocomplete queries that can be filtered/limited by a `contextField` configured in the autocomplete `<searchComponent>` in solrconfig.xml.

For IIIF Content Search autocomplete behavior, we want to limit the suggestions to terms that appear in pages that are children of the parent object. The `contextField` should be the same as the `object_relation_field` defined in the `CatalogController` configuration.

This is best set up as a separate `<searchComponent>` from any existing autocomplete/suggest functionality that may already be defined in your Solr configuration. The install generator will create a new `<searchComponent>` in solrconfig.xml and several field definitions in the schema.xml file to support the autocomplete behavior. You may need to customize these settings for your implementation.

In Solr 8., the autocomplete suggester service currently returns the entire field value, not a single term. Single-term autocomplete suggestions are possible with Solr 7.

To enable single-term autocomplete in Solr 7, you also need to add the `tokenizing-suggest-v1.0.1.jar` library to your Solr install's `contrib` directory (see steps in Test Drive below). 
This library is needed so that Solr will return single terms for autocomplete queries, rather than the entire full text field.

(The `tokenizing-suggest-v1.0.1.jar` library is not currently compatible with Solr > 7. Further development needed, pull requests welcome!)

It's often helpful to test Solr directly to make sure autocomplete is working properly, this can be done like so:
```
http://host:port/solr/[core_name]/iiif_suggest?wt=json&suggest.cfq=[parent_identifier]&q=[query_term]
```

## Test Drive

After cloning the repository, and running `bundle install`:
1. Generate the test application at `.internal_test_app`:
```
$ rake engine_cart:generate
```
2. Start up Solr (run from a new terminal window):
```
$ solr_wrapper
```

3. If running Solr 7.*, copy the `tokenizing-suggest-v1.0.1.jar` library to Solr's `contrib` directory:
```
# first, stop solr_wrapper (Ctrl-C)
$ cp ./lib/generators/blacklight_iiif_search/templates/solr/lib/tokenizing-suggest-v1.0.1.jar /path/to/solr/contrib
# then uncomment the 'tokenizing-suggest' lines in .internal_test_app/solr/conf/solrconfig.xml
# restart solr_wrapper
$ solr_wrapper
```

4. Index sample documents into Solr (run from `./.internal_test_app`):
```
$ RAILS_ENV=test rake blacklight_iiif_search:index:seed
```
5. Start up the Rails server (run from `./.internal_test_app`):
```
$ rails s
```
6. In a browser, go to: `http://127.0.0.1:3000`. You should see the default Blacklight home page.
7. Test a sample search: `http://127.0.0.1:3000/catalog/7s75dn48d/iiif_search?q=sugar`
8. Test a sample autocomplete request: `http://127.0.0.1:3000/catalog/7s75dn48d/iiif_suggest?q=be`

To see how search snippets work, change the value of the `full_text_field` config to `alternative_title_tsim` in `./.internal_test_app/app/controllers/catalog_controller.rb`, and restart the Rails server.

## Development

After cloning the repository, and running `bundle install`, run `rake ci` from the project's root directory, which will:
1. Generate the test application at `.internal_test_app`
2. Run `Blacklight` and `BlacklightIiifSearch` generators
3. Start Solr and index the sample Solr docs from `spec/fixtures`
    * (Note: The Solr config is created by Blackight's installer, and is generated into `.internal_test_app/solr/conf`.)
4. Run all specs

## Credits

This project was originally developed as part of the [Newspapers in Samvera](https://www.imls.gov/grants/awarded/lg-70-17-0043-17) grant. Thanks to the Institute of Museum and Library Services for their support.

Inspiration for this code was drawn from Stanford University Digital Library's [content_search](https://github.com/sul-dlss/content_search) and NCSU Libraries' [ocracoke](https://github.com/NCSU-Libraries/ocracoke).

Special thanks to [Chris Beer](https://github.com/cbeer) and [Stanford University Digital Library](https://github.com/sul-dlss) for the use of the `tokenizing-suggest-v1.0.1.jar` library.
