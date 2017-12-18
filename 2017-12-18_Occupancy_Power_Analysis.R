# simulate dataset to compare between two or more treatments

n_site <- 10 # number of sites
n_obs <- 5 # number of observations at each site
occ1 <- 0.30 # true occupancy at treatment 1
occ2 <- 0.90 # true occupancy at treatment 2
# can add more treatments
det_prob <- 0.30

# create true occupancy states for sites within each treatment
# here we only have 2 treatments
occ_sim <- rbind(
  matrix(rbinom(n_site, 1, occ1), ncol=1, nrow=n_site),
  matrix(rbinom(n_site, 1, occ2), ncol=1, nrow=n_site)
)

# simulate data set based on true occupancy state and detection probability
obs_sim <- matrix(rbinom(nrow(occ_sim)*n_obs, 1, det_prob*rep(as.numeric(occ_sim), n_obs)), ncol=n_obs, nrow=nrow(occ_sim))


# here I have set up categorical variable to indicate the two treatments
sites <- data.frame(site=c(rep(0, 10), rep(1, 10)))

# set up data for unmarked
library(unmarked)

# build unmarkedFrameOccu
umf <- unmarkedFrameOccu(y = obs_sim, siteCovs = sites)
summary(umf) # look at object

null_mod <- occu(~1 ~1, umf) # null model

test_mod <- occu(~1 ~site, umf) # comparison between sites

# a lower AIC value for test_mod indicates that you can detect the difference (indicated above) between treatments
# this simulation is currently set up to detect a large difference
