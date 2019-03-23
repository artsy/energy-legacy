# Folio Feature Map

While it's safe to assume this document is out of date. we should also strive to try document most of Folio's 
features somehow. 

## Booting up

- Check if you're locked out (show a message)
- Check if you're logged in (go straight to main grid)
- Otherwise show login screen

## Logging in

When logging in you can end up in three states:

- You're a user attached to one parter (show sync)
- You're a user attached to many partners (show a list, then show sync)
- You're an admin (show a way to log in as any partner)

## Sync

There is a technical overview of sync in the docs here. However, sync currently:

- Gets an updated version of the partner
- Downloads every Artwork, Show, Location, 

## Syncing Screen

The initial sync screen will:

- Guess at how long it might take to sync, this is mainly some assumptions on file sizes and a clever FILO queue in ARSyncProgress
- If you're an admin, you can hold your finger on the for a second screen and it will bring up a page showing the raw sync details

## The Main Grid

The default screen of Folio. The canonical grid.

- For a gallery, it shows: "Artists", "Shows" and "Albums"
- For a collector partner type, it shows: "Artists", "Locations" and "Albums"

When in "Albums" you can edit your albums:

- In edit mode you can make a new album by hitting the big plus
- In edit mode you can re-name an album by tapping on the album name
- In edit mode you can delete an album

## Search

- todo

## Artwork Container (Show/Location/Artist/Album)

These show a set of tabs, which depend on the following:

- Does the container have artworks?
- Does the container have install shots?
- Does the container have related albums?
- Does the container have related shows?
- Does the container have related documents?

### Selecting Artworks

An Artwork Container has a global selection mode for either adding artworks to an album, or for preparing an email.

When selecting for email:

- You can select Artworks, Documents and Install shots
- The order you select doesn't matter, it always orders by Artist sort ID, and then Artwork Display Title

### Sorting in the Grid

When there are artworks with more than one Artist, and there are:

- "Artist, Title" - Artist, Title, Year
- "Artist, Date" - Artist, Year, Title
- "Artist, Medium" - Artist, Medium, Year, Title

Otherwise it's just:

- "Title" - Title, Artist, Year
- "Date" - Year, Artist, Title
- "Medium" - Medium, Artist, Year, Title

Artsy.net sort order isn't supported, you can kinda blame this on laziness by Orta, but I've not found an elegant 
way to do it in my head all these years yet.

### Filtering in the Grid

For anything which contains artworks, like Shows/Albums etc, then it will be hidden in Folio if there are no artworks

For any artwork, it won't show if it has no attached images

## User Settings

- You can start a sync
- Folio supports running in a dark mode
- You can also log out (wipe all local settings)
- You can access intercom, we think, not certain that works

### Presentation Mode

Folio has two kinds of view modes:

- Everything
- Filtered for public viewing, presentation mode

Filtered for public viewing means that you could change:

- Showing Artworks which are unpublished
- Showing Artworks which are sold already
- Hide prices everywhere
- Hide prices for sold works
- Hide whether a work is available of not
- Hide the Artwork edit button
- Hide the confidential notes section on an Artwork overview

### Email Settings

- You can add a `cc:` email address for every email
- You can change the default before (greeting), and after (signature)
- You can customize the default email titles, depending on what set of Artworks you're emailing

