deglist = list()
annlist = list()
btwnlist = list()
eigenlist = list()

for (state in data$State %>% unique()) {
  # Get Provider-Patient Network for all counties in the state
  bnet = propat(data, state, 'all')
  # Project bipartite network into two one mode networks
  bn.pr <- bipartite.projection(bnet)
  # Get Provider network - affiliated through shared patients
  bn.provider <- bn.pr$proj2
  
  # Calculate Degrees
  deg = degree(bn.provider)
  deg = tibble(names(deg), deg)
  colnames(deg) = c('Provider','Degree')
  
  # Calculate Betweeenness
  btwn = betweenness(bn.provider)
  btwn = tibble(names(btwn), btwn)
  colnames(btwn) = c('Provider','Betweenness')
  
  # Calculate Values of the First Eigenvector of the Graph Matrix
  eign = eigen_centrality(bn.provider)$vector
  eign = tibble(names(eign), eign)
  colnames(eign) = c('Provider','Eigenvector')
  
  # Calculate Average Nearest Neighbors
  ann = knn(bn.provider)
  ann = ann$knn
  ann = tibble(names(ann), ann)
  colnames(ann) = c('Provider','Avg.NN')
  
  # Add to list by state
  deglist[[state]] = deg
  btwnlist[[state]] = btwn 
  eigenlist[[state]] = eign 
  annlist[[state]] = ann 
}

propatDeg <- dplyr::bind_rows(deglist)
propatBtwn <- dplyr::bind_rows(btwnlist)
propatEign <- dplyr::bind_rows(eigenlist)
propatANN <- dplyr::bind_rows(annlist)

#############################################################################

deglist = list()
annlist = list()
btwnlist = list()
eigenlist = list()

for (state in data$State %>% unique()) {
  # Get Provider-Doctor Network for all counties in the state
  bnet = prodoc(data, state, 'all')
  # Project bipartite network into two one mode networks
  bn.pr <- bipartite.projection(bnet)
  # Get Provider network - affiliated through shared doctors
  bn.provider <- bn.pr$proj2
  
  # Calculate Degrees
  deg = degree(bn.provider)
  deg = tibble(names(deg), deg)
  colnames(deg) = c('Provider','Degree')
  
  # Calculate Betweeenness
  btwn = betweenness(bn.provider)
  btwn = tibble(names(btwn), btwn)
  colnames(btwn) = c('Provider','Betweenness')
  
  # Calculate Values of the First Eigenvector of the Graph Matrix
  eign = eigen_centrality(bn.provider)$vector
  eign = tibble(names(eign), eign)
  colnames(eign) = c('Provider','Eigenvector')
  
  # Calculate Average Nearest Neighbors
  ann = knn(bn.provider)
  ann = ann$knn
  ann = tibble(names(ann), ann)
  colnames(ann) = c('Provider','Avg.NN')
  
  # Add to list by state
  deglist[[state]] = deg
  btwnlist[[state]] = btwn 
  eigenlist[[state]] = eign 
  annlist[[state]] = ann 
}
#############################################################################

prodocDeg <- dplyr::bind_rows(deglist)
prodocBtwn <- dplyr::bind_rows(btwnlist)
prodocEign <- dplyr::bind_rows(eigenlist)
prodocANN <- dplyr::bind_rows(annlist)