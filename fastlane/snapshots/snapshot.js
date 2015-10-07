#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

target.delay(3)
captureLocalizedScreenshot("0-App Launch")

target.frontMostApp().mainWindow().collectionViews()[0].cells()[0].tap();
target.delay(2);

target.frontMostApp().mainWindow().collectionViews()[0].cells()[0].tap();
target.delay(2);
captureLocalizedScreenshot("1-Artwork Screen")

target.frontMostApp().mainWindow().buttons()["Artwork Metadata"].tap();

target.delay(2);
captureLocalizedScreenshot("2-Artwork Details")

target.frontMostApp().mainWindow().buttons()["Artwork Metadata"].tap();
target.delay(2);

target.frontMostApp().navigationBar().buttons()["View In Room"].tap();
target.delay(2);
captureLocalizedScreenshot("3-View In Room")

target.frontMostApp().mainWindow().buttons()["DONE"].tap();
target.delay(2);

target.frontMostApp().navigationBar().buttons()["Back"].tap();
target.delay(2);

target.frontMostApp().navigationBar().buttons()["Back"].tap();
target.delay(2);

target.frontMostApp().navigationBar().buttons()["(null) Shows Button"].tap();
target.delay(2);
captureLocalizedScreenshot("4-View In Room")
