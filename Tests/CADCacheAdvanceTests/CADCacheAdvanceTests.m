//
//  Created by Dan Federman on 4/24/20.
//  Copyright © 2020 Dan Federman.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS"BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if GENERATED_XCODE_PROJECT
// This import works when working within the generated CacheAdvance.xcodeproj used in CI.
#import <CADCacheAdvance/CADCacheAdvance-Swift.h>
#else
// This import works when working within Package.swift.
@import CADCacheAdvance;
#endif
@import XCTest;

/// Tests that exercise the API of CADCacheAdvance.
/// - Note: Since CADCacheAdvance is a thin wrapper on CacheAdvance<Data>, these tests are intended to do nothing more than exercise the API.
@interface CADCacheAdvanceTests : XCTestCase
@end

@implementation CADCacheAdvanceTests

// MARK: Behavior Tests

- (void)test_fileURL_returnsUnderlyingFileURL;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:YES];
    XCTAssertEqualObjects(cache.fileURL, [self testFileLocation]);
}

- (void)test_isWritable_returnsTrueForAWritableCache;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:YES];
    XCTAssertTrue(cache.isWritable);
}

- (void)test_isEmpty_returnsTrueForAnEmptyCache;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:YES];
    XCTAssertTrue(cache.isEmpty);
}

- (void)test_isEmpty_returnsFalseForANonEmptyCache;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:YES];
    NSError *error = nil;
    [cache appendMessage:[@"Test" dataUsingEncoding:NSUTF8StringEncoding]
                error:&error];
    XCTAssertNil(error);
    XCTAssertFalse(cache.isEmpty);
}

- (void)test_messagesAndReturnError_returnsAppendedMessage;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:YES];
    NSData *const message = [@"Test" dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [cache appendMessage:message
                   error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects([cache messagesAndReturnError:nil], @[message]);
}

// MARK: Performance Tests

- (void)test_performance_append_fillableCache;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:NO];
    // Fill the cache before the test starts.
    for (NSString *const message in [self lorumIpsumMessages]) {
        [cache appendMessage:[message dataUsingEncoding:NSUTF8StringEncoding]
                       error:nil];
    }

    [self measureBlock:^{
        for (NSString *const message in [self lorumIpsumMessages]) {
            [cache appendMessage:[message dataUsingEncoding:NSUTF8StringEncoding]
                           error:nil];
        }
    }];
}

- (void)test_performance_messages_fillableCache;
{
    CADCacheAdvance *const cache = [self createCacheThatOverwitesOldMessages:NO];
    // Fill the cache before the test starts.
    for (NSString *const message in [self lorumIpsumMessages]) {
        [cache appendMessage:[message dataUsingEncoding:NSUTF8StringEncoding]
                       error:nil];
    }

    [self measureBlock:^{
        (void)[cache messagesAndReturnError:nil];
    }];
}

// MARK: Private

- (CADCacheAdvance *)createCacheThatOverwitesOldMessages:(BOOL)overwritesOldMessages;
{
    [NSFileManager.defaultManager createFileAtPath:[self testFileLocation].path
                                          contents:nil
                                        attributes:nil];
    NSError *error = nil;
    CADCacheAdvance *const cache = [[CADCacheAdvance alloc]
                                    initWithFileURL:self.testFileLocation
                                    maximumBytes:1000000
                                    shouldOverwriteOldMessages:overwritesOldMessages
                                    error:&error];
    XCTAssertNil(error, "Failed to create cache due to %@", error);
    return cache;
}

- (NSURL *)testFileLocation;
{
    return [NSFileManager.defaultManager.temporaryDirectory URLByAppendingPathComponent:@"CADCacheAdvanceTests"];
}

- (NSArray<NSString *> *)lorumIpsumMessages;
{
    return @[
        @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        @"Arcu cursus euismod quis viverra nibh cras pulvinar.",
        @"Et malesuada fames ac turpis.",
        @"Maecenas accumsan lacus vel facilisis volutpat est velit egestas.",
        @"Amet massa vitae tortor condimentum lacinia quis.",
        @"At volutpat diam ut venenatis tellus in.",
        @"Cras ornare arcu dui vivamus arcu felis bibendum ut.",
        @"In arcu cursus euismod quis viverra nibh.",
        @"Sodales neque sodales ut etiam sit.",
        @"Risus commodo viverra maecenas accumsan lacus vel facilisis volutpat.",
        @"Scelerisque varius morbi enim nunc faucibus a pellentesque sit amet.",
        @"Condimentum vitae sapien pellentesque habitant morbi.",
        @"Adipiscing enim eu turpis egestas pretium aenean pharetra magna.",
        @"Eu turpis egestas pretium aenean pharetra magna ac.",
        @"Eros in cursus turpis massa tincidunt dui ut ornare.",
        @"Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet risus.",
        @"Dui id ornare arcu odio ut.",
        @"Aliquet bibendum enim facilisis gravida neque convallis a cras.",
        @"Blandit libero volutpat sed cras.",
        @"Purus faucibus ornare suspendisse sed nisi lacus sed viverra tellus.",
        @"Cursus turpis massa tincidunt dui.",
        @"At tellus at urna condimentum mattis pellentesque id nibh tortor.",
        @"Urna id volutpat lacus laoreet.",
        @"Nunc scelerisque viverra mauris in aliquam sem.",
        @"In cursus turpis massa tincidunt dui ut ornare lectus sit.",
        @"Amet facilisis magna etiam tempor orci eu.",
        @"Urna nec tincidunt praesent semper feugiat nibh sed pulvinar proin.",
        @"Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt tortor.",
        @"Nulla pharetra diam sit amet nisl.",
        @"Rhoncus mattis rhoncus urna neque viverra justo.",
        @"Duis convallis convallis tellus id interdum velit laoreet id donec.",
        @"Sagittis vitae et leo duis ut diam quam nulla.",
        @"Sem viverra aliquet eget sit amet.",
        @"At in tellus integer feugiat scelerisque varius morbi enim nunc.",
        @"Mollis nunc sed id semper risus in.",
        @"Elementum nibh tellus molestie nunc non.",
        @"Auctor neque vitae tempus quam.",
        @"Magna fermentum iaculis eu non diam phasellus vestibulum lorem sed.",
        @"Justo eget magna fermentum iaculis eu.",
        @"Sit amet nulla facilisi morbi tempus iaculis urna id.",
        @"Convallis posuere morbi leo urna molestie at elementum eu facilisis.",
        @"Ac tortor dignissim convallis aenean et tortor at.",
        @"Arcu non sodales neque sodales ut etiam.",
        @"Cras semper auctor neque vitae tempus.",
        @"Est velit egestas dui id ornare arcu odio ut.",
        @"Libero enim sed faucibus turpis in eu mi bibendum neque.",
        @"Mauris sit amet massa vitae tortor condimentum lacinia quis vel.",
        @"Justo donec enim diam vulputate ut.",
        @"Convallis convallis tellus id interdum velit.",
        @"Donec enim diam vulputate ut pharetra sit.",
        @"Sed velit dignissim sodales ut eu sem.",
        @"Libero enim sed faucibus turpis in eu.",
        @"Senectus et netus et malesuada fames ac turpis egestas sed.",
        @"Aliquet porttitor lacus luctus accumsan tortor.",
        @"Aenean et tortor at risus.",
        @"Convallis a cras semper auctor neque vitae.",
        @"Ac orci phasellus egestas tellus.",
        @"Iaculis urna id volutpat lacus laoreet non curabitur gravida.",
        @"Nascetur ridiculus mus mauris vitae ultricies leo.",
        @"Sed faucibus turpis in eu mi bibendum.",
        @"Sollicitudin ac orci phasellus egestas tellus rutrum tellus pellentesque.",
        @"In dictum non consectetur a.",
        @"Id diam maecenas ultricies mi.",
        @"Venenatis lectus magna fringilla urna porttitor rhoncus dolor.",
        @"Id ornare arcu odio ut sem.",
        @"Arcu cursus euismod quis viverra.",
        @"Pulvinar pellentesque habitant morbi tristique senectus.",
        @"Blandit massa enim nec dui nunc mattis.",
        @"Iaculis at erat pellentesque adipiscing commodo elit at imperdiet dui.",
        @"Sit amet dictum sit amet justo donec enim diam vulputate.",
        @"Id diam maecenas ultricies mi eget mauris.",
        @"Faucibus pulvinar elementum integer enim neque volutpat.",
        @"Rhoncus dolor purus non enim praesent elementum.",
        @"Sollicitudin aliquam ultrices sagittis orci a scelerisque purus semper.",
        @"Ipsum dolor sit amet consectetur.",
        @"Diam quis enim lobortis scelerisque fermentum dui faucibus in.",
        @"Fermentum iaculis eu non diam phasellus.",
        @"Elit sed vulputate mi sit amet mauris commodo.",
        @"Commodo elit at imperdiet dui accumsan sit amet nulla.",
        @"Etiam dignissim diam quis enim lobortis.",
        @"In iaculis nunc sed augue lacus viverra.",
        @"Tempus imperdiet nulla malesuada pellentesque elit eget.",
        @"Quis lectus nulla at volutpat.",
        @"Tellus rutrum tellus pellentesque eu tincidunt tortor.",
        @"Tristique senectus et netus et.",
        @"Quis lectus nulla at volutpat diam ut venenatis tellus in.",
        @"Nisi lacus sed viverra tellus in hac habitasse platea dictumst.",
        @"Justo eget magna fermentum iaculis eu non diam phasellus.",
        @"Vehicula ipsum a arcu cursus vitae congue mauris.",
        @"Enim nulla aliquet porttitor lacus luctus accumsan tortor posuere ac.",
        @"Purus faucibus ornare suspendisse sed nisi lacus sed viverra.",
        @"At risus viverra adipiscing at in tellus integer feugiat scelerisque.",
        @"Suspendisse interdum consectetur libero id faucibus nisl.",
        @"Sit amet venenatis urna cursus eget nunc scelerisque viverra mauris.",
        @"Dui nunc mattis enim ut tellus elementum sagittis vitae et.",
        @"Sed id semper risus in hendrerit.",
        @"Dignissim cras tincidunt lobortis feugiat vivamus at augue eget arcu.",
        @"Amet nisl suscipit adipiscing bibendum est ultricies integer.",
        @"Mi in nulla posuere sollicitudin aliquam.",
        @"Tempus imperdiet nulla malesuada pellentesque elit eget gravida cum.",
        @"Quisque non tellus orci ac auctor augue mauris augue neque.",
        @"Sapien nec sagittis aliquam malesuada.",
        @"Tristique risus nec feugiat in fermentum posuere.",
        @"Bibendum est ultricies integer quis.",
        @"Non odio euismod lacinia at quis risus.",
        @"Tortor dignissim convallis aenean et tortor at risus viverra.",
        @"Vitae et leo duis ut diam quam nulla.",
        @"Sit amet nisl suscipit adipiscing.",
        @"Interdum varius sit amet mattis vulputate enim nulla aliquet.",
        @"Placerat vestibulum lectus mauris ultrices eros in.",
        @"Mattis pellentesque id nibh tortor id.",
        @"At lectus urna duis convallis convallis tellus.",
        @"Malesuada fames ac turpis egestas sed.",
        @"Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar sapien.",
        @"At augue eget arcu dictum varius duis at.",
        @"Non enim praesent elementum facilisis.",
        @"Et sollicitudin ac orci phasellus egestas tellus.",
        @"Tortor vitae purus faucibus ornare.",
        @"A cras semper auctor neque vitae.",
        @"Egestas purus viverra accumsan in nisl nisi.",
        @"Etiam tempor orci eu lobortis elementum nibh tellus molestie.",
        @"Ac turpis egestas sed tempus urna et pharetra pharetra massa.",
        @"Vitae semper quis lectus nulla at.",
        @"Varius quam quisque id diam vel.",
        @"Mattis enim ut tellus elementum sagittis.",
        @"Vel orci porta non pulvinar.",
        @"Eget aliquet nibh praesent tristique magna sit amet purus gravida.",
        @"Suscipit tellus mauris a diam maecenas.",
        @"Elementum curabitur vitae nunc sed.",
        @"Lacinia at quis risus sed vulputate odio ut enim.",
        @"Faucibus nisl tincidunt eget nullam.",
        @"Sed felis eget velit aliquet.",
        @"Mauris nunc congue nisi vitae suscipit tellus mauris a diam.",
        @"Sit amet nisl suscipit adipiscing bibendum.",
        @"Ut faucibus pulvinar elementum integer enim.",
        @"Id diam vel quam elementum pulvinar etiam non quam.",
        @"Massa vitae tortor condimentum lacinia.",
        @"Vulputate sapien nec sagittis aliquam malesuada.",
        @"Urna porttitor rhoncus dolor purus non.",
        @"Nec nam aliquam sem et tortor consequat.",
        @"Senectus et netus et malesuada fames ac turpis egestas integer.",
        @"Eu volutpat odio facilisis mauris sit amet massa vitae tortor.",
        @"Magna ac placerat vestibulum lectus mauris ultrices eros in cursus.",
        @"Nec feugiat in fermentum posuere urna.",
        @"Risus commodo viverra maecenas accumsan lacus vel facilisis volutpat.",
        @"Justo donec enim diam vulputate ut pharetra.",
        @"Amet justo donec enim diam vulputate ut pharetra.",
        @"Ipsum a arcu cursus vitae congue.",
        @"Convallis convallis tellus id interdum velit laoreet.",
        @"Vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet.",
        @"Non consectetur a erat nam.",
        @"Proin sed libero enim sed faucibus turpis in.",
        @"Sed nisi lacus sed viverra tellus.",
        @"Suscipit adipiscing bibendum est ultricies integer quis.",
        @"Tincidunt praesent semper feugiat nibh sed pulvinar proin.",
        @"Tristique nulla aliquet enim tortor at auctor urna nunc id.",
        @"Lacus vel facilisis volutpat est velit egestas dui.",
        @"Sit amet cursus sit amet.",
        @"Vestibulum lorem sed risus ultricies tristique nulla aliquet.",
        @"Nec ullamcorper sit amet risus nullam eget felis eget nunc.",
        @"Justo eget magna fermentum iaculis eu non diam phasellus vestibulum.",
        @"Placerat duis ultricies lacus sed turpis tincidunt.",
        @"Duis tristique sollicitudin nibh sit amet commodo nulla facilisi nullam.",
        @"Id eu nisl nunc mi ipsum faucibus vitae aliquet nec.",
        @"At quis risus sed vulputate odio ut enim.",
        @"Consectetur lorem donec massa sapien faucibus.",
        @"Vitae purus faucibus ornare suspendisse sed nisi lacus.",
        @"Pellentesque sit amet porttitor eget dolor morbi non arcu risus.",
        @"Neque gravida in fermentum et sollicitudin ac orci.",
        @"Lobortis feugiat vivamus at augue eget arcu dictum varius.",
        @"Felis bibendum ut tristique et egestas quis ipsum.",
        @"Tortor aliquam nulla facilisi cras fermentum odio eu feugiat.",
        @"Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar.",
        @"Egestas pretium aenean pharetra magna ac placerat.",
        @"Massa vitae tortor condimentum lacinia quis vel eros donec.",
        @"Sed odio morbi quis commodo odio aenean.",
        @"Suspendisse sed nisi lacus sed viverra tellus in.",
        @"Nam aliquam sem et tortor consequat id porta nibh venenatis.",
        @"Congue nisi vitae suscipit tellus.",
        @"Vitae ultricies leo integer malesuada nunc vel risus commodo.",
        @"At tempor commodo ullamcorper a lacus vestibulum sed.",
        @"Pellentesque habitant morbi tristique senectus et netus et malesuada fames.",
        @"Id velit ut tortor pretium viverra suspendisse potenti nullam.",
        @"Euismod lacinia at quis risus sed vulputate odio ut enim.",
        @"Nibh ipsum consequat nisl vel pretium lectus.",
        @"Pretium lectus quam id leo in.",
        @"Nullam vehicula ipsum a arcu cursus vitae congue.",
        @"Habitasse platea dictumst vestibulum rhoncus.",
        @"Morbi tempus iaculis urna id volutpat lacus laoreet non.",
        @"Elit pellentesque habitant morbi tristique senectus et netus et malesuada.",
        @"Vitae suscipit tellus mauris a diam maecenas.",
        @"Morbi tristique senectus et netus et.",
        @"Pulvinar pellentesque habitant morbi tristique senectus et.",
        @"Bibendum neque egestas congue quisque egestas diam in.",
        @"Id aliquet risus feugiat in ante.",
        @"Magna fringilla urna porttitor rhoncus dolor purus non.",
        @"Volutpat lacus laoreet non curabitur gravida arcu ac tortor.",
        @"Sit amet consectetur adipiscing elit pellentesque habitant morbi tristique.",
        @"Laoreet suspendisse interdum consectetur libero id faucibus.",
        @"Bibendum at varius vel pharetra vel turpis.",
        @"Magna etiam tempor orci eu lobortis elementum.",
        @"Leo urna molestie at elementum eu facilisis sed odio morbi.",
        @"Nibh venenatis cras sed felis.",
        @"Hac habitasse platea dictumst quisque sagittis purus sit amet.",
        @"Tellus rutrum tellus pellentesque eu tincidunt.",
        @"Sapien et ligula ullamcorper malesuada proin libero nunc consequat.",
        @"Cursus in hac habitasse platea dictumst.",
        @"Egestas sed sed risus pretium quam vulputate.",
        @"Ullamcorper a lacus vestibulum sed arcu non odio.",
        @"Ultrices in iaculis nunc sed augue lacus viverra.",
        @"Amet nulla facilisi morbi tempus iaculis urna id.",
        @"Nulla facilisi cras fermentum odio eu feugiat pretium.",
        @"Elementum nisi quis eleifend quam adipiscing.",
        @"Aliquet eget sit amet tellus cras.",
        @"In massa tempor nec feugiat nisl pretium.",
        @"Tristique risus nec feugiat in fermentum posuere urna nec tincidunt.",
        @"Integer vitae justo eget magna fermentum iaculis.",
        @"Dignissim diam quis enim lobortis scelerisque fermentum.",
        @"Id nibh tortor id aliquet lectus proin.",
        @"Lacus sed turpis tincidunt id aliquet.",
        @"Vitae justo eget magna fermentum iaculis eu non diam phasellus.",
        @"Orci porta non pulvinar neque.",
        @"Et molestie ac feugiat sed lectus vestibulum mattis ullamcorper.",
        @"Posuere urna nec tincidunt praesent semper feugiat nibh.",
        @"Tristique magna sit amet purus gravida quis blandit turpis cursus.",
        @"Mattis molestie a iaculis at erat.",
        @"Eget nunc lobortis mattis aliquam faucibus purus.",
        @"Nunc aliquet bibendum enim facilisis gravida.",
        @"Nunc sed augue lacus viverra vitae congue.",
        @"Arcu dui vivamus arcu felis bibendum ut tristique et egestas.",
        @"Facilisi morbi tempus iaculis urna id volutpat lacus laoreet non.",
        @"Commodo odio aenean sed adipiscing diam donec adipiscing.",
        @"Nunc scelerisque viverra mauris in aliquam sem fringilla ut morbi.",
        @"Non diam phasellus vestibulum lorem sed risus ultricies tristique.",
        @"Urna et pharetra pharetra massa massa ultricies mi quis hendrerit.",
        @"Diam ut venenatis tellus in metus vulputate eu scelerisque.",
        @"Tempus urna et pharetra pharetra massa massa ultricies mi.",
        @"Urna nunc id cursus metus.",
        @"Gravida neque convallis a cras.",
        @"Vitae turpis massa sed elementum tempus egestas sed sed.",
        @"Facilisi cras fermentum odio eu.",
        @"Consequat nisl vel pretium lectus quam id leo in vitae.",
        @"Mi quis hendrerit dolor magna.",
        @"Sed risus ultricies tristique nulla aliquet enim tortor at.",
        @"Praesent semper feugiat nibh sed pulvinar proin.",
        @"Enim sed faucibus turpis in.",
        @"Bibendum est ultricies integer quis auctor elit sed vulputate.",
        @"Orci sagittis eu volutpat odio facilisis mauris sit.",
        @"Mi quis hendrerit dolor magna eget.",
        @"Eu scelerisque felis imperdiet proin fermentum leo.",
        @"Integer eget aliquet nibh praesent tristique magna sit amet.",
        @"Arcu dictum varius duis at consectetur lorem.",
        @"Sed felis eget velit aliquet.",
        @"Ullamcorper velit sed ullamcorper morbi tincidunt ornare.",
        @"Dui accumsan sit amet nulla facilisi morbi tempus iaculis.",
        @"Senectus et netus et malesuada fames ac turpis.",
        @"Pulvinar etiam non quam lacus.",
        @"Sollicitudin ac orci phasellus egestas.",
        @"Eu facilisis sed odio morbi quis commodo odio aenean sed.",
        @"Maecenas ultricies mi eget mauris.",
        @"Sed adipiscing diam donec adipiscing tristique risus nec feugiat.",
        @"Orci eu lobortis elementum nibh.",
        @"Libero id faucibus nisl tincidunt eget nullam non nisi est.",
        @"Dictum at tempor commodo ullamcorper a lacus.",
        @"Pretium lectus quam id leo in vitae turpis massa.",
        @"Quisque egestas diam in arcu cursus.",
        @"Lectus arcu bibendum at varius vel pharetra vel turpis.",
        @"Posuere lorem ipsum dolor sit amet.",
        @"Nunc sed augue lacus viverra vitae congue.",
        @"Vel quam elementum pulvinar etiam non quam.",
        @"Leo vel orci porta non.",
        @"Porttitor leo a diam sollicitudin.",
        @"Molestie nunc non blandit massa enim nec dui nunc.",
        @"Aliquet nec ullamcorper sit amet risus nullam eget felis.",
        @"Feugiat nisl pretium fusce id velit ut tortor.",
        @"Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur.",
        @"Parturient montes nascetur ridiculus mus mauris vitae ultricies.",
        @"Congue mauris rhoncus aenean vel elit scelerisque mauris pellentesque pulvinar.",
        @"Donec massa sapien faucibus et molestie.",
        @"At auctor urna nunc id.",
        @"Fermentum iaculis eu non diam phasellus.",
        @"Imperdiet proin fermentum leo vel orci.",
        @"Non consectetur a erat nam.",
        @"Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at.",
        @"Nibh praesent tristique magna sit amet purus gravida quis.",
        @"Lacus sed turpis tincidunt id aliquet risus feugiat in ante.",
        @"Urna id volutpat lacus laoreet.",
        @"Amet massa vitae tortor condimentum lacinia quis vel.",
        @"Eget nullam non nisi est sit amet facilisis magna etiam.",
        @"Quam elementum pulvinar etiam non quam lacus suspendisse faucibus.",
        @"Nisi quis eleifend quam adipiscing.",
        @"Ac turpis egestas maecenas pharetra convallis posuere morbi leo.",
        @"Convallis a cras semper auctor neque vitae tempus.",
        @"Tincidunt augue interdum velit euismod in pellentesque massa.",
        @"Purus gravida quis blandit turpis cursus in hac habitasse.",
        @"Sed egestas egestas fringilla phasellus faucibus scelerisque.",
        @"Scelerisque in dictum non consectetur a erat nam at lectus.",
        @"Nunc sed blandit libero volutpat sed cras.",
        @"Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque.",
        @"Egestas erat imperdiet sed euismod nisi.",
        @"Euismod quis viverra nibh cras pulvinar mattis nunc.",
        @"Sapien et ligula ullamcorper malesuada proin libero nunc consequat interdum.",
        @"Quis hendrerit dolor magna eget est lorem ipsum dolor.",
        @"Aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque habitant morbi.",
        @"Enim lobortis scelerisque fermentum dui.",
        @"Vulputate sapien nec sagittis aliquam malesuada bibendum arcu.",
        @"Mattis ullamcorper velit sed ullamcorper morbi tincidunt.",
        @"Donec pretium vulputate sapien nec sagittis aliquam malesuada.",
        @"Eget egestas purus viverra accumsan in nisl nisi scelerisque eu.",
        @"Massa tempor nec feugiat nisl pretium.",
        @"Turpis cursus in hac habitasse.",
        @"Morbi tristique senectus et netus et malesuada.",
        @"Consequat semper viverra nam libero justo laoreet sit amet cursus.",
        @"Velit egestas dui id ornare.",
        @"Mi quis hendrerit dolor magna eget est.",
        @"Ac turpis egestas sed tempus urna et pharetra.",
        @"Vitae nunc sed velit dignissim sodales ut eu sem integer.",
        @"Tincidunt ornare massa eget egestas purus viverra accumsan.",
        @"Faucibus a pellentesque sit amet porttitor eget.",
        @"In ante metus dictum at tempor commodo.",
        @"Elementum curabitur vitae nunc sed velit dignissim.",
        @"Dignissim diam quis enim lobortis scelerisque fermentum dui faucibus in.",
        @"Nulla at volutpat diam ut venenatis tellus in.",
        @"Amet dictum sit amet justo donec enim.",
        @"Massa id neque aliquam vestibulum.",
        @"Facilisi nullam vehicula ipsum a.",
        @"Neque volutpat ac tincidunt vitae semper quis.",
        @"Dictum sit amet justo donec enim diam vulputate ut.",
        @"Est velit egestas dui id ornare arcu.",
        @"Ultricies mi quis hendrerit dolor magna.",
        @"Maecenas volutpat blandit aliquam etiam erat velit scelerisque in dictum.",
        @"Ut lectus arcu bibendum at.",
        @"Enim ut tellus elementum sagittis.",
        @"Cras adipiscing enim eu turpis egestas pretium aenean pharetra magna.",
        @"A arcu cursus vitae congue mauris rhoncus aenean vel elit.",
        @"Bibendum neque egestas congue quisque egestas diam in arcu cursus.",
        @"Nulla facilisi cras fermentum odio eu feugiat.",
        @"Porttitor leo a diam sollicitudin tempor id eu nisl nunc.",
        @"Ac placerat vestibulum lectus mauris ultrices eros in.",
        @"Vulputate eu scelerisque felis imperdiet proin fermentum leo vel.",
        @"Urna porttitor rhoncus dolor purus non enim praesent elementum.",
        @"At imperdiet dui accumsan sit.",
        @"Condimentum mattis pellentesque id nibh tortor id aliquet lectus.",
        @"Augue interdum velit euismod in pellentesque massa placerat.",
        @"Mauris pellentesque pulvinar pellentesque habitant morbi tristique.",
        @"Platea dictumst quisque sagittis purus sit amet volutpat.",
        @"Volutpat lacus laoreet non curabitur gravida.",
        @"Fringilla ut morbi tincidunt augue interdum velit.",
        @"Arcu felis bibendum ut tristique et egestas.",
        @"Quis viverra nibh cras pulvinar mattis nunc.",
        @"Vel quam elementum pulvinar etiam non.",
        @"A scelerisque purus semper eget duis at tellus at urna.",
        @"Lectus magna fringilla urna porttitor rhoncus dolor purus.",
        @"Consequat id porta nibh venenatis.",
        @"Sed faucibus turpis in eu mi bibendum neque egestas congue.",
        @"Enim ut sem viverra aliquet eget sit amet tellus cras.",
        @"Viverra nibh cras pulvinar mattis nunc sed blandit libero.",
        @"Duis at tellus at urna condimentum mattis pellentesque id nibh.",
        @"Sed vulputate mi sit amet mauris commodo.",
        @"Turpis cursus in hac habitasse platea dictumst.",
        @"Id interdum velit laoreet id donec ultrices tincidunt.",
        @"Nunc consequat interdum varius sit.",
        @"Ut aliquam purus sit amet luctus venenatis lectus.",
        @"Ultrices eros in cursus turpis.",
        @"Mattis vulputate enim nulla aliquet.",
        @"Amet porttitor eget dolor morbi non arcu risus quis varius.",
        @"Urna et pharetra pharetra massa massa.",
        @"Posuere ac ut consequat semper viverra nam.",
        @"Hac habitasse platea dictumst vestibulum rhoncus est pellentesque.",
        @"Faucibus nisl tincidunt eget nullam non.",
        @"Blandit massa enim nec dui.",
        @"Sed adipiscing diam donec adipiscing.",
        @"Mauris rhoncus aenean vel elit scelerisque.",
        @"Enim ut sem viverra aliquet eget sit amet.",
        @"Fermentum iaculis eu non diam phasellus vestibulum.",
        @"Lacus sed turpis tincidunt id aliquet.",
        @"Cras ornare arcu dui vivamus arcu.",
        @"Mi bibendum neque egestas congue quisque egestas diam in.",
        @"Elementum pulvinar etiam non quam lacus suspendisse.",
        @"Eget mauris pharetra et ultrices neque ornare aenean.",
        @"In fermentum posuere urna nec tincidunt praesent semper feugiat nibh.",
        @"Phasellus egestas tellus rutrum tellus pellentesque eu.",
        @"Ipsum dolor sit amet consectetur adipiscing elit ut.",
        @"Tristique senectus et netus et malesuada fames ac.",
        @"Lacus vestibulum sed arcu non odio euismod lacinia.",
        @"Orci sagittis eu volutpat odio facilisis.",
        @"Et tortor consequat id porta nibh venenatis cras sed felis.",
        @"Lorem ipsum dolor sit amet consectetur adipiscing.",
        @"Odio tempor orci dapibus ultrices in iaculis nunc sed augue.",
        @"Interdum consectetur libero id faucibus.",
        @"Nunc sed id semper risus.",
        @"Varius duis at consectetur lorem donec massa sapien faucibus.",
        @"Nisl rhoncus mattis rhoncus urna.",
        @"Aliquam id diam maecenas ultricies mi eget mauris pharetra.",
        @"Ut placerat orci nulla pellentesque dignissim enim sit amet.",
        @"Aenean et tortor at risus.",
        @"Tempor orci dapibus ultrices in iaculis nunc sed.",
        @"Non tellus orci ac auctor augue mauris augue neque gravida.",
        @"Porttitor eget dolor morbi non arcu risus quis varius.",
        @"Dictum non consectetur a erat nam at lectus urna.",
        @"Pellentesque elit eget gravida cum sociis natoque.",
        @"Pretium nibh ipsum consequat nisl vel pretium lectus quam.",
        @"Mi bibendum neque egestas congue quisque egestas diam in.",
        @"A cras semper auctor neque vitae tempus.",
        @"Sollicitudin tempor id eu nisl nunc mi ipsum.",
        @"Elementum tempus egestas sed sed risus pretium quam vulputate.",
        @"Pharetra massa massa ultricies mi quis.",
        @"Diam ut venenatis tellus in metus vulputate eu scelerisque felis.",
        @"Eget aliquet nibh praesent tristique magna sit amet purus.",
        @"Amet volutpat consequat mauris nunc congue nisi.",
        @"Venenatis lectus magna fringilla urna porttitor.",
        @"Vitae proin sagittis nisl rhoncus.",
        @"Turpis egestas integer eget aliquet nibh.",
        @"Nisl suscipit adipiscing bibendum est ultricies integer quis auctor.",
        @"Massa sed elementum tempus egestas sed sed risus.",
        @"Odio pellentesque diam volutpat commodo sed egestas egestas.",
        @"Id cursus metus aliquam eleifend mi in nulla posuere sollicitudin.",
        @"Massa tincidunt nunc pulvinar sapien.",
        @"Sit amet justo donec enim diam vulputate ut.",
        @"Aliquam ultrices sagittis orci a scelerisque purus.",
        @"Eget nunc scelerisque viverra mauris in aliquam.",
        @"Amet est placerat in egestas erat.",
        @"Platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim cras.",
        @"Integer malesuada nunc vel risus commodo viverra maecenas accumsan lacus.",
        @"Integer quis auctor elit sed.",
        @"Sit amet facilisis magna etiam tempor.",
        @"Pellentesque habitant morbi tristique senectus et netus.",
        @"Facilisis gravida neque convallis a cras semper.",
        @"Et netus et malesuada fames ac.",
        @"Enim lobortis scelerisque fermentum dui.",
        @"Vivamus arcu felis bibendum ut tristique et egestas quis.",
        @"Nunc mi ipsum faucibus vitae.",
        @"Volutpat sed cras ornare arcu dui vivamus arcu felis.",
        @"Morbi tristique senectus et netus et malesuada fames ac.",
        @"Elit scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique.",
        @"Tincidunt id aliquet risus feugiat in ante metus dictum at.",
        @"Enim nulla aliquet porttitor lacus luctus accumsan tortor posuere ac.",
        @"Imperdiet dui accumsan sit amet nulla facilisi morbi tempus.",
        @"Vulputate odio ut enim blandit volutpat maecenas volutpat blandit aliquam.",
        @"Semper risus in hendrerit gravida.",
        @"Sit amet nulla facilisi morbi tempus iaculis.",
        @"Gravida in fermentum et sollicitudin ac orci phasellus.",
        @"Viverra tellus in hac habitasse platea.",
        @"Viverra orci sagittis eu volutpat odio facilisis mauris.",
        @"Risus feugiat in ante metus dictum at tempor commodo ullamcorper.",
        @"Non odio euismod lacinia at quis risus.",
        @"Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam.",
        @"Sed sed risus pretium quam vulputate dignissim suspendisse.",
        @"Odio eu feugiat pretium nibh ipsum consequat nisl vel pretium.",
        @"Et netus et malesuada fames.",
        @"Facilisis volutpat est velit egestas dui id ornare.",
        @"Nec ullamcorper sit amet risus nullam eget.",
        @"Pellentesque habitant morbi tristique senectus et netus et.",
        @"Sit amet nulla facilisi morbi tempus iaculis.",
        @"Et egestas quis ipsum suspendisse ultrices.",
        @"Faucibus turpis in eu mi.",
        @"Eu consequat ac felis donec.",
        @"Id consectetur purus ut faucibus pulvinar elementum integer enim.",
        @"Scelerisque viverra mauris in aliquam sem fringilla ut.",
        @"Viverra maecenas accumsan lacus vel facilisis.",
        @"Sit amet luctus venenatis lectus magna fringilla.",
        @"Purus ut faucibus pulvinar elementum integer.",
        @"Risus nec feugiat in fermentum posuere urna nec.",
        @"Vitae elementum curabitur vitae nunc.",
        @"Dictum fusce ut placerat orci nulla pellentesque dignissim.",
        @"Et tortor at risus viverra adipiscing.",
        @"Ut ornare lectus sit amet est.",
        @"Quisque id diam vel quam elementum pulvinar.",
        @"Sed odio morbi quis commodo odio aenean sed.",
        @"Convallis aenean et tortor at risus viverra adipiscing.",
        @"Libero volutpat sed cras ornare arcu dui vivamus.",
        @"Nulla malesuada pellentesque elit eget.",
        @"Id porta nibh venenatis cras sed felis eget.",
        @"Semper auctor neque vitae tempus quam pellentesque.",
        @"Auctor neque vitae tempus quam pellentesque.",
        @"Maecenas ultricies mi eget mauris pharetra et ultrices neque ornare.",
        @"In nulla posuere sollicitudin aliquam ultrices sagittis.",
        @"Urna nunc id cursus metus aliquam eleifend mi.",
        @"Vitae congue eu consequat ac felis donec et.",
        @"Eu turpis egestas pretium aenean pharetra magna.",
    ];
}

@end
