propat = function(data, state, county){
  if(county == 'all'){
    county = data %>%
      filter(State %in% state) %>%
      distinct(County) %>% pull
  }
  
  data.filt = 
    data %>% filter(State %in% state, County %in% county) %>% 
    dplyr::select(Provider, PotentialFraud, BeneID, InscClaimAmtReimbursed) %>%
    group_by(Provider, PotentialFraud, BeneID) %>% 
    summarise(weights = sum(InscClaimAmtReimbursed)) %>% data.frame()
  
  ## Get Provider | Beneficiary
  connections = data.filt %>% dplyr::select(Provider,BeneID,weights)
  ## Create bipartite graph
  Bnet <- graph.data.frame(connections,directed=FALSE)
  ## Add attribues
  shapes <- c(21,15)
  fraud = data.filt %>% select(Provider,PotentialFraud)
  V(Bnet)$type <- V(Bnet)$name %in% connections[,1]
  V(Bnet)$actor <- ifelse(V(Bnet)$name %in% connections[,1],'Provider','Patient')
  V(Bnet)$fraud <- ifelse(V(Bnet)$name %in% fraud[,1],fraud[,2],'Patient')
  #V(Bnet)$fraud <- factor(V(Bnet)$fraud, levels = c('Yes','?','No','Patient'))
  V(Bnet)$size <- 4*sqrt(strength(Bnet))
  V(Bnet)$shape <- shapes[V(Bnet)$type+1]
  
  FraudYes = V(Bnet)[fraud=='Yes']
  FraudNo = V(Bnet)[fraud=='No']
  FraudTest = V(Bnet)[fraud=='?']
  Patients = V(Bnet)[fraud=='Patient']
  
  V(Bnet)[fraud=='Yes']$color = "#e65247" # red
  V(Bnet)[fraud=='No']$color = "#57bf37" #green
  V(Bnet)[fraud=='?']$color = "#b24ed4" #purple
  V(Bnet)[fraud=='Patient']$color = "#3b68ff" #blue
  
  E(Bnet)[FraudYes %--% Patients]$color = "#e65247" # red
  E(Bnet)[FraudNo %--% Patients]$color = "#57bf37" #green
  E(Bnet)[FraudTest %--% Patients]$color = "#b24ed4" #purple
  return(Bnet)
}

################################################################################################
prodoc = function(data, state, county){
  if(county == 'all'){
    county = data %>% 
      filter(State %in% state) %>% 
      distinct(County) %>% pull
  }
  data.filt = 
    data %>% filter(State %in% state, County %in% county) %>% 
    dplyr::select(Provider, PotentialFraud,InscClaimAmtReimbursed,
                  AttendingPhysician, OperatingPhysician, OtherPhysician) %>% 
    pivot_longer(cols=c(AttendingPhysician,OperatingPhysician,OtherPhysician), 
                 names_to = "Type", values_to = "Doctor") %>%
    filter(complete.cases(.)) %>% 
    group_by(Provider, PotentialFraud, Doctor) %>% 
    summarise(weights = sum(InscClaimAmtReimbursed)) %>% data.frame()
  
  ## Get Provider | Beneficiary
  connections = data.filt %>% dplyr::select(Provider,Doctor,weights)
  ## Create bipartite graph
  Bnet <- graph.data.frame(connections,directed=FALSE)
  ## Add attributes
  shapes <- c(25,15)
  fraud = data.filt %>% select(Provider,PotentialFraud)
  V(Bnet)$type <- V(Bnet)$name %in% connections[,1]
  V(Bnet)$actor <- ifelse(V(Bnet)$name %in% connections[,1],'Provider','Doctor')
  V(Bnet)$fraud <- ifelse(V(Bnet)$name %in% fraud[,1],fraud[,2],'Doctor')
  #V(Bnet)$fraud <- factor(V(Bnet)$fraud, levels =c('Yes','?','No','Doctor'))
  V(Bnet)$size <- 4*sqrt(strength(Bnet))
  V(Bnet)$shape <- shapes[V(Bnet)$type+1]
  
  FraudYes = V(Bnet)[fraud=='Yes']
  FraudNo = V(Bnet)[fraud=='No']
  FraudTest = V(Bnet)[fraud=='?']
  Doctors = V(Bnet)[fraud=='Doctor']
  
  V(Bnet)[fraud=='Yes']$color = "#e65247" # red
  V(Bnet)[fraud=='No']$color = "#57bf37" #green
  V(Bnet)[fraud=='?']$color = "#b24ed4" #purple
  V(Bnet)[fraud=='Doctor']$color = "#3b68ff" #blue
  
  E(Bnet)[FraudYes %--% Doctors]$color = "#e65247" # red
  E(Bnet)[FraudNo %--% Doctors]$color = "#57bf37" #green
  E(Bnet)[FraudTest %--% Doctors]$color = "#b24ed4" #purple
  return(Bnet)
}

################################################################################################
patdoc = function(data, state, county){
  if(county == 'all'){
    county = data %>% 
      filter(State %in% state) %>% 
      distinct(County) %>% pull
  }
  
  data.filt = 
    data %>% filter(State %in% state, County %in% county) %>% 
    dplyr::select(BeneID, InscClaimAmtReimbursed,
                  AttendingPhysician, OperatingPhysician, OtherPhysician) %>% 
    pivot_longer(cols=c(AttendingPhysician,OperatingPhysician,OtherPhysician), 
                 names_to = "Type", values_to = "Doctor") %>%
    filter(complete.cases(.)) %>% 
    group_by(BeneID, Doctor) %>% 
    summarise(weights = sum(InscClaimAmtReimbursed)) %>% data.frame()
  
  ## Get Provider | Beneficiary
  connections = data.filt %>% dplyr::select(BeneID,Doctor,weights)
  ## Create bipartite graph
  Bnet <- graph.data.frame(connections,directed=FALSE)
  ## Add attributes
  shapes <- c(25,21)
  V(Bnet)$type <- V(Bnet)$name %in% connections[,1]
  V(Bnet)$actor <- ifelse(V(Bnet)$name %in% connections[,1],'Patient','Doctor')
  V(Bnet)$size <- 4*sqrt(strength(Bnet))
  V(Bnet)$shape <- shapes[V(Bnet)$type+1]
  
  
  V(Bnet)[actor=='Patient']$color = "#57bf37" #green
  V(Bnet)[actor=='Doctor']$color = "#3b68ff" #blue
  
  return(Bnet)
}

################################################################################################
################################################################################################

plotProPat = function(bnet, layout='stress'){
  
  ggraph(bnet, layout = layout)+
    geom_edge_link0(
      edge_alpha=0.3, 
      edge_color = E(bnet)$color, 
      aes(edge_width = weights)) + 
    geom_node_point(
      aes(size = size), 
      shape = V(bnet)$shape, 
      color = V(bnet)$color) +
    geom_node_text(aes(filter = size >= 100, label = name, size=3),family="serif", repel=TRUE)+
    scale_edge_width_continuous(range = c(0.2,4), guide=FALSE)+
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph()
}

################################################################################################
plotProDoc = function(bnet, layout='stress'){
  
  ggraph(bnet, layout = layout)+
    geom_edge_link0(
      edge_alpha=0.3, 
      edge_color = E(bnet)$color, 
      aes(edge_width = weights)) + 
    geom_node_point(
      aes(size = size), 
      shape = V(bnet)$shape, 
      color = V(bnet)$color) +
    geom_node_text(aes(filter = size >= 100, label = name, size=3),family="serif", repel=TRUE)+
    scale_edge_width_continuous(range = c(0.2,4), guide=FALSE)+
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph()
}

################################################################################################
plotPatDoc = function(bnet, layout='stress'){
  
  ggraph(bnet, layout = layout)+
    geom_edge_link0(
      edge_alpha=0.3, 
      #edge_color = E(bnet)$color, 
      aes(edge_width = weights)) + 
    geom_node_point(
      aes(size = size), 
      shape = V(bnet)$shape, 
      color = V(bnet)$color) +
    geom_node_text(aes(filter = size >= 100, label = name, size=3),family="serif", repel=TRUE)+
    scale_edge_width_continuous(range = c(0.2,4), guide=FALSE)+
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph()}

################################################################################################
plotActor = function(net, layout = 'tree', actor = 'provider'){
  
  if (actor=='provider') {
    shape = 15
  } else if (actor == 'patient') {
    shape = 21
  } else if (actor == 'doctor') {
    shape = 17
  }
  ggraph(net, layout = layout)+
    geom_edge_link0(edge_alpha=0.5, edge_colour = "grey66") + 
    geom_node_point(
      aes(size = size),
      color = V(net)$color,
      shape = shape) + 
    scale_edge_width_continuous(range = c(0.2,3), guide=FALSE)+
    scale_size_continuous(range = c(2,6), guide=FALSE) +
    theme_graph() 
}