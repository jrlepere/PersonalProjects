//
//  Kumulos.h
//  Kumulos
//
//  Created by Kumulos Bindings Compiler on Aug 24, 2016
//

#import <Foundation/Foundation.h>
#import "libKumulos.h"


@class Kumulos;
@protocol KumulosDelegate <kumulosProxyDelegate>
@optional

 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation acceptFriendRequestDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation checkIfFriendsDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createFriendRequestDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation deleteFriendOfDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getFriendsByUserDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getFriendsOfByRequestDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createPredictionDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsAllDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByMaybeCountAscendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByMaybeCountDescendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByNoWayCountAscendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByNoWayCountDescendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByObviouslyCountAscendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByObviouslyCountDescendingDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPredictionsByUserDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation removePredictionDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateMaybeCountDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateNoWayCountDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateObviouslyCountDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPasswordDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserByUsernameDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation increaseMaybeTotalRecievedDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation increaseNoWayTotalRecievedDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation increaseObviouslyTotalRecievedDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation increaseTotalVotesMadeDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation newUserDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation searchUsernameDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation uniqueUsernameDidCompleteWithResult:(NSArray*)theResults;

@end

@interface Kumulos : kumulosProxy {
    NSString* theAPIKey;
    NSString* theSecretKey;
}

-(Kumulos*)init;
-(Kumulos*)initWithAPIKey:(NSString*)APIKey andSecretKey:(NSString*)secretKey;

   
-(KSAPIOperation*) acceptFriendRequestWithUsername:(NSString*)username andFriend:(NSUInteger)friend andSetTrue:(BOOL)setTrue;
    
   
-(KSAPIOperation*) checkIfFriendsWithUsername:(NSString*)username andFriend:(NSUInteger)friend;
    
   
-(KSAPIOperation*) createFriendRequestWithUsername:(NSString*)username andFriend:(NSUInteger)friend andRequestedFalse:(BOOL)requestedFalse;
    
   
-(KSAPIOperation*) deleteFriendOfWithUsername:(NSString*)username andFriend:(NSUInteger)friend;
    
   
-(KSAPIOperation*) getFriendsByUserWithFriend:(NSUInteger)friend andRequestAccepted:(BOOL)requestAccepted;
    
   
-(KSAPIOperation*) getFriendsOfByRequestWithUsername:(NSString*)username andRequestAccepted:(BOOL)requestAccepted;
    
   
-(KSAPIOperation*) createPredictionWithPrediction:(NSString*)prediction andSport:(NSString*)sport andUsername:(NSString*)username andCount:(NSInteger)count andUserPollID:(NSUInteger)userPollID;
    
   
-(KSAPIOperation*) getPredictionsAllWithNumberOfRecords:(NSNumber*)numberOfRecords;
    
   
-(KSAPIOperation*) getPredictionsByMaybeCountAscendingWithNumberOfRecords:(NSNumber*)numberOfRecords andSport:(NSString*)sport;
    
   
-(KSAPIOperation*) getPredictionsByMaybeCountDescendingWithNumberOfRecords:(NSNumber*)numberOfRecords andSport:(NSString*)sport;
    
   
-(KSAPIOperation*) getPredictionsByNoWayCountAscendingWithSport:(NSString*)sport andNumberOfRecords:(NSNumber*)numberOfRecords;
    
   
-(KSAPIOperation*) getPredictionsByNoWayCountDescendingWithSport:(NSString*)sport andNumberOfRecords:(NSNumber*)numberOfRecords;
    
   
-(KSAPIOperation*) getPredictionsByObviouslyCountAscendingWithSport:(NSString*)sport andNumberOfRecords:(NSNumber*)numberOfRecords;
    
   
-(KSAPIOperation*) getPredictionsByObviouslyCountDescendingWithSport:(NSString*)sport andNumberOfRecords:(NSNumber*)numberOfRecords;
    
   
-(KSAPIOperation*) getPredictionsByUserWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) removePredictionWithPollID:(NSUInteger)pollID;
    
   
-(KSAPIOperation*) updateMaybeCountWithPollID:(NSUInteger)pollID;
    
   
-(KSAPIOperation*) updateNoWayCountWithPollID:(NSUInteger)pollID;
    
   
-(KSAPIOperation*) updateObviouslyCountWithPollID:(NSUInteger)pollID;
    
   
-(KSAPIOperation*) getPasswordWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) getUserWithUsername:(NSString*)username andPassword:(NSString*)password;
    
   
-(KSAPIOperation*) getUserByUsernameWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) increaseMaybeTotalRecievedWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) increaseNoWayTotalRecievedWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) increaseObviouslyTotalRecievedWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) increaseTotalVotesMadeWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) newUserWithUsername:(NSString*)username andPassword:(NSString*)password andCount:(NSNumber*)count;
    
   
-(KSAPIOperation*) searchUsernameWithUsername:(NSString*)username;
    
   
-(KSAPIOperation*) uniqueUsernameWithUsername:(NSString*)username;
    
            
@end