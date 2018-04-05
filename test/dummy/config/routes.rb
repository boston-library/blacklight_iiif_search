Rails.application.routes.draw do

  mount BlacklightIiifSearch::Engine => "/blacklight_iiif_search"
end
