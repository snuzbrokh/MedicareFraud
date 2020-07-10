source("getNet.R")
source("plotNet.R")
require(tidyverse)
require(network)
require(ggraph)
require(igraph)
require(graphlayouts)

netAnal = function(data, state, county, 
                   type = 'propat', layout = 'stress', 
                   saveFile = FALSE){
  
  if (type == 'propat'){
    bnet = propat(data, state, county)
    plotProPat(bnet, state, county, layout = layout, save = saveFile)
  } else if (type == 'prodoc') {
    bnet = prodoc(data, state, county)
    plotProDoc(bnet, state, county, layout = layout, save = saveFile)
  } else if (type == 'patdoc') {
    bnet = patdoc(data, state, county)
    plotPatDoc(bnet, state, county, layout = layout, save = saveFile)
  } 
}