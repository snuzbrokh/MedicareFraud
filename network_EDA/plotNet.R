
plotProPat = function(bnet, state, county, layout = 'stress', save = FALSE){
  
  #palette <- c('?'="#1A5878",'Patient'= "#C44237", 'No' = "#AD8941", 'Yes' = "green")
  
  #id_palette <- c("#1A5878","#C44237","#AD8941","green")
  ggraph(bnet, layout = layout)+
    geom_edge_link0(alpha=0.5, edge_colour = "grey66", aes(width = weights)) + 
    #geom_node_point(aes(color = fraud, size = size), shape = V(bnet)$shape) +
    geom_node_point(aes(
      #fitler = size >= 10,
      color = fraud,
      size = size), shape = V(bnet)$shape) +
    geom_node_text(aes(filter = size >= 50, label = name, size=3),family="serif", repel=TRUE)+
    scale_color_brewer(palette = "Set1",
                       name = "Fraud", labels=c('Yes','?','No','Patient'))+
    scale_edge_width_continuous(range = c(0.2,3), guide=FALSE)+
    #scale_fill_manual(values = palette, name = "Fraud", labels = c("A","D", "B", "C"))) +
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph() +
    theme(legend.position = "left")
    #scale_fill_discrete(guide = guide_legend(reverse=TRUE))
  
    #ggsave(filename=paste0('./visualizations/networks/pb_5_200_sugiyama.png'),plot=last_plot())
}

plotProDoc = function(bnet, state, county, layout = 'stress', save = FALSE){
  
  #palette <- c('?'="#1A5878",'Patient'= "#C44237", 'No' = "#AD8941", 'Yes' = "green")
  
  #id_palette <- c("#1A5878","#C44237","#AD8941","green")
  ggraph(bnet, layout = layout)+
    geom_edge_link0(alpha=0.5, edge_colour = "grey66", aes(width = weights)) + 
    #geom_node_point(aes(color = fraud, size = size), shape = V(bnet)$shape) +
    geom_node_point(aes(
      #fitler = size >= 10,
      color = fraud,
      size = size), shape = V(bnet)$shape) +
    geom_node_text(aes(filter = size >= 50, label = name, size=3),family="serif", repel=TRUE)+
    scale_color_brewer(palette = "Set1",
                       name = "Fraud", labels=c('Yes','?','No','Doctor'))+
    scale_edge_width_continuous(range = c(0.2,3), guide=FALSE)+
    scale_fill_manual(values = palette) +
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph() +
    theme(legend.position = "left")
  
  #ggsave(filename=paste0('./visualizations/networks/pb_5_200_sugiyama.png'),plot=last_plot())
}

plotPatDoc = function(bnet, state, county, layout = 'stress', save = FALSE){
  
  #palette <- c('?'="#1A5878",'Patient'= "#C44237", 'No' = "#AD8941", 'Yes' = "green")
  
  #id_palette <- c("#1A5878","#C44237","#AD8941","green")
  ggraph(bnet, layout = layout)+
    geom_edge_link0(alpha=0.5, edge_colour = "grey66", aes(width = weights)) + 
    #geom_node_point(aes(color = fraud, size = size), shape = V(bnet)$shape) +
    geom_node_point(aes(
      #fitler = size >= 10,
      #color = fraud,
      size = size), shape = V(bnet)$shape) +
    geom_node_text(aes(filter = size >= 50, label = name, size=3),family="serif", repel=TRUE)+
    #scale_color_brewer(palette = "Dark2")+
    scale_edge_width_continuous(range = c(0.2,3), guide=FALSE)+
    scale_fill_manual(values = palette) +
    scale_size_continuous(range = c(2,6), guide=FALSE)+
    theme_graph() +
    theme(legend.position = "right")
  
  #ggsave(filename=paste0('./visualizations/networks/pb_5_200_sugiyama.png'),plot=last_plot())
}