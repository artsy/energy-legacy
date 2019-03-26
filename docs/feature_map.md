# Folio Feature Map

While it's safe to assume this document is out of date. we should also strive to try document most of Folio's 
features somehow. 

## Booting up

- Check if you're locked out (show a message)
- Check if you're logged in (go straight to main grid)
- Otherwise show login screen

## Logging in

When logging in you can end up in three states:

- You're a user attached to one partner (show sync)
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

Initially highlights Artists. Can jump to all Shows or all Albums for quick launch.

Typing in the search will search for:

- Artist, searches name, orders by orderingKey
- Album, searches name, orders by name
- Artwork, searches title, orders by title
- Show, searches name, orders by name
- Location, searches name, orders by name (collector folio only)

Then for artworks it verifies the works have images.

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

### Selecting on the Grid

You can long-press on an item in a grid, it will bring up a set of options:

- If you can see artwork availability, then you can change it here
- For albums you can set a cover (this isn't sync'd - boo)
- For editable albums, you can remove the artwork from there

## Selecting for Email

Tapping the email button turns into email selection mode, this lets you pick:

- Artworks
- Documents
- Install Shots

To add to the email when you hit compose. Hitting compose checks if there are email options:

- If any Artworks contain supplementary information e.g.: info, exhibitionHistory, provenance, literature, signature, series & imageRights. Show an option to toggle all of them.
- If any Artworks have prices:
 - If there's a different back-end vs front-end price offer showing none/backend/public
 - Otherwise show no price/front
- If there's an inventory ID on any Artworks offer to show/hide those

- If there is one artwork, and it has additional images, let the user select any of those
- If all the artworks are in one show, and it has install shows, let the user select any of those
- For all artwork artists, offer to attach all potential documents
- For all artwork shows, offer to attach all potential documents

All of these selection states are stored, so that next time you email they would be selected still.

Emailing will use Apple's email system on the iDevice to send off their emails. You can store drafts etc using that, and see all sent email inside the apple Mail.app.

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
