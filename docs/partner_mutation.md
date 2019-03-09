
# Editing Partners on Folio

There are two main ways in which Folio makes changes to a Partner in gravity.

### Album Sync

Albums support in Gravity was added back [in 2015](https://github.com/artsy/gravity/pull/7462) with revised access
rights happening [in 2016](https://github.com/artsy/gravity/pull/10308). Basicallly an album is per-partner and generally per-user.
The data-model allows for many users, so in theory people could share albums.

When you create / rename / edit an Album's artworks, this creates  `AlbumEdit` objects inside the Core Data db. Then on 
the next time somone hits sync, these are iterated through and changes are made gravity side. 


### Availability Editing

The availability editing settings use the gravity REST API directly to make changes to the availability for an Artwork, and directly
mutates the Core Data db. The next sync would then bring down the same availability options.  
