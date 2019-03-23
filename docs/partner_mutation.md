
# Editing Partners on Folio

There are two main ways in which Folio makes changes to a Partner in gravity.

### Album Sync

Albums support in Gravity was added back [in 2015](https://github.com/artsy/gravity/pull/7462) with revised access
rights happening [in 2016](https://github.com/artsy/gravity/pull/10308). Basically an album is per-partner and generally per-user.

The Album data-model allows for many users, so in theory people could share albums with other staff, but it took 
5 years to get Album Sync into Folio. I wouldn't expect to see that anytime feature soon.

When you create / rename / edit an Album's artworks, this creates `AlbumEdit` objects inside the Core Data db. Hitting
save in the Foolio UI will trigger a sync, which is just the Albums view.


### Availability Editing

The availability editing settings use the gravity REST API directly to make changes to the availability for an Artwork, and directly
mutates the Core Data db. The next sync would then bring down the same availability options.  
