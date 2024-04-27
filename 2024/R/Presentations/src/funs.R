
# Sum Stats fun -----------------------------------------------------------

sum_fun <- function(data, vars){
  data %>% 
    summarise(
      across(
        {{vars}},
        list(
          n    = ~sum(!is.na(.x)),
          mean = ~mean(.x), 
          sd   = ~sd(.x), 
          min  = ~min(.x),
          max  = ~max(.x)
        )
      )
    ) %>%  
    pivot_longer(everything()) %>% 
    separate(name, sep = "_", into = c("var", "stat")) %>% 
    pivot_wider(names_from = "stat", values_from = "value")
}


# Balance Table -----------------------------------------------------------

bal_tab <-
  function(
    data,            # Data frame
    vars,            # Vector of variables,
    by,              # By variable
    ouput   = NULL,  # Output type
    format  = NULL,  # Format of decimals
    cluster = NULL,  # Cluster Var
    obs     = FALSE, # Obs
    dict    = NULL,  # Dictionary
    gt      = FALSE  # GT Option
  ){
    # Ungroup data
    data <- data %>% 
      ungroup() %>% 
      mutate(
        across(
          where(haven::is.labelled),
          ~ haven::as_factor(.x)
        )
      )
    
    # Add observations
    counts <- data %>%  
      dplyr::filter(!is.na(.data[[by]])) %>% 
      dplyr::count(.data[[by]]) %>% 
      dplyr::pull(2)
    
    n.opt  <- counts[2]
    n.ctr  <- counts[1]
    n.tot  <- counts[2] + counts[1]
    
    # Select variables
    vardat <- data[vars]
    bydat  <- data[by]
    dat    <- cbind(vardat, bydat)
    
    # Cluster
    if(!is.null(cluster)){
      clus <- data[cluster]
      dat  <- cbind(dat, clus)
    }
    
    # Regressions to get the values
    .y = vars
    .x = by
    .d = mlr::createDummyFeatures(data, cols = by)
    .d = .d %>%  dplyr::select(dplyr::last_col()-(2-1):0)
    dnames <- names(.d)
    data  <- cbind(dat, .d)
    
    # Cluster
    if(!is.null(cluster)) {
      res = fixest:::feols(.[.y] ~ .[dnames] - 1, data = data, cluster = cluster)
    } else {
      res = fixest:::feols(.[.y] ~ .[dnames] - 1, data = data)
    }
    
    # Get all
    means <- map_dfr(
      res, 
      ~ broom::tidy(.) %>% 
        dplyr::select(term, estimate, std.error) %>%  
        pivot_longer(c(2:3)) %>% 
        pivot_wider(
          names_from = term,
          values_from = value
        ),
      .id = "variables"
    )
    
    # Changes the order from 0 - 1 to 1 - 0
    revnames <- rev(dnames)
    revnames <- paste0(revnames, collapse = "-")
    
    # Differences
    diffs <- map_dfr(
      res,
      ~ multcomp::glht(., paste0(revnames, "=0")) %>% 
        broom::tidy() %>% 
        dplyr::select(estimate, std.error) %>% 
        pivot_longer(everything()) %>% 
        dplyr::select(diff = value)
    )
    
    tab <- cbind(means, diffs)
    
    # Format 
    if(!is.null(format)){
      fmt = as.numeric(format)
      tab <- tab %>% 
        mutate(
          # two decimals
          across(
            c(dnames, diff),
            ~ format(round(.x, fmt), big.mark = ",")
          )
        )
    } 
    else {
      tab <- tab
    }
    
    # Add parentheses
    tab <- tab %>% 
      mutate(
        # Parenthesis for your se
        across(
          c(dnames, diff),
          ~ ifelse((row_number() %% 2) == 0, paste0("(", str_trim(.x), ")"), .x)
        ),
        # One variable name
        variables = ifelse((row_number() %% 2) == 0, "", variables),
        across(
          everything(),
          ~ str_trim(.x)
        )
      ) %>% 
      select(-name) %>% 
      tibble()
    
    if(!is.null(cluster)){
      message(glue::glue("SEs Clustered by: ", cluster))
    }
    
    # Add labels
    if(!is.null(dict)) {
      labs <- dict %>% 
        as.list() %>%  
        as.data.frame() %>%  
        pivot_longer(everything()) %>% 
        rename(variables = name)
      
      tab <- left_join(
        tab, labs, by = "variables"
      ) %>%  
        mutate(value = ifelse(is.na(value) & !is.na(variables), variables, value)) %>%  
        mutate(value = ifelse(is.na(value), "", value)) %>%  
        select(-variables) %>%  
        select(variables = value, everything())
    }
    
    # Add obs.
    if(obs==TRUE){
      tab <- tab %>%  
        rbind(c("Observations", n.ctr, n.opt, n.tot))
    }
    
    # Outputs ----		
    # GT
    if(gt==TRUE){
      tab <- tab %>%  
        gt::gt()
    }
    
    return(tab)
  }

# Example -----------------------------------------------------------------

dict <- c(
  "bill_length_mm" = "bill length (millimeters)", 
  "body_mass_g" = "body mass (grams)", 
  "flipper_length_mm" = "flipper length (millimeters)",
  "year" = "Year"
)

bal_tab(
  data = penguins, 
  vars = c("bill_length_mm", "body_mass_g", "flipper_length_mm"), 
  by = "sex",
  format = 2,
  dict = dict,
  obs = TRUE,
  cluster = "island",
  # gt = TRUE
) 

# Example of source -------------------------------------------------------

source("https://han.gl/NSvXM")
