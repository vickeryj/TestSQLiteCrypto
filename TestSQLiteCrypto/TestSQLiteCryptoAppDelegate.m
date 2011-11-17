//
//  TestSQLiteCryptoAppDelegate.m
//  TestSQLiteCrypto
//
//  Created by Joshua Vickery on 4/5/11.
//  Copyright 2011 PatientKeeper Inc. All rights reserved.
//

#import "TestSQLiteCryptoAppDelegate.h"
#import <sqlite3.h>

@implementation TestSQLiteCryptoAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sqlite3 *db;
    
//    const char *dbFile = [@"/Users/jvickery/temp/test_crypto_db" UTF8String];
//    if (sqlite3_open(dbFile, &db) == SQLITE_OK) {
//        const char* key = [@"BIGSecret" UTF8String];
//        sqlite3_key(db, key, strlen(key));
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    const char *dbFile = [[NSString stringWithFormat:@"%@/test_crypto_db",[paths objectAtIndex:0]] UTF8String];
    if (sqlite3_open(dbFile, &db) == SQLITE_OK) {
        sqlite3_exec(db, "PRAGMA key = 'BIGsecret'", NULL, NULL, NULL);
                     
                     
         if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
             NSLog(@"Yay sqlite ok");
         // password is correct, or, database has been initialized
             
             int rc = sqlite3_exec(db, "create table foo(bar text);", NULL, NULL, NULL);
             if (SQLITE_OK != rc) {
                 NSLog(@"DB Error: %d '%s'", sqlite3_errcode(db), sqlite3_errmsg(db));
             }

             rc = sqlite3_exec(db, "insert into foo(bar) values('a');", NULL, NULL, NULL);
             const char *zErrMsg = 0;
             
             if (SQLITE_OK != rc) {
                 NSLog(@"DB Error: %d '%s'", sqlite3_errcode(db), sqlite3_errmsg(db));
             }
             
             sqlite3_stmt *stmt = NULL;
             rc = sqlite3_prepare(db, "select * from foo;", -1, &stmt, &zErrMsg);
             
             if (SQLITE_OK != rc) {
                 NSLog(@"DB Error: %d '%s', %s", sqlite3_errcode(db), sqlite3_errmsg(db), zErrMsg);
             }

             do  {
                 rc = sqlite3_step(stmt);
                 if (SQLITE_ROW != rc && SQLITE_DONE != rc) {
                     NSLog(@"DB Error: %d '%s'", sqlite3_errcode(db), sqlite3_errmsg(db));
                 }
                 else {
                     NSLog(@"column value: %s",sqlite3_column_text(stmt, 0));
                 }
             } while (rc == SQLITE_ROW);

             
             sqlite3_close(db);
         } else {
         // incorrect password!
              NSLog(@"Boo sqlite not ok");
         }
     
     }
    
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
