//
//  libKumulos.h
//  Kumulos
//
//  Created by Kumulos on 13/05/2011
//  Copyright 2010 Kumulos All rights reserved.
//
//	version 0.6.2

#import <Foundation/Foundation.h>



#define PROD_API_SERVER_LEGACY 101
#define PROD_API_SERVER_BETA2  102
#define STAGING_API_SERVER 103
#define PROD_API_SERVER_BETA2_1 104
#define PROD_API_SERVER_2_2 105





//
//  KSOperation
//

@class KSAPIOperation;
@protocol KSAPIOperationDelegate <NSObject>
@required
- (void) apiOperation:(KSAPIOperation*)operation didCompleteWithResult:(NSArray*)theResult;
@optional
- (void) apiOperation:(KSAPIOperation*)operation didFailWithError:(NSString*)theError;
@end


@interface KSAPIOperation : NSOperation{
	
    
	NSArray* theResults;
	
	NSString* method;
	
	float connectionTimeout;
	
	//Connection vars
	NSString* theError;
	BOOL connFinished;
    
}

@property (strong) id<KSAPIOperationDelegate,NSObject> delegate;

//the selector that kumulosProxy subclass calls on success
@property (nonatomic) SEL callbackSelector;

//the main thread method signature of the kumulosProxy callback
@property (nonatomic, strong) NSMethodSignature* successCallbackMethodSignature;
@property (nonatomic, strong) NSMethodSignature* errorCallbackMethodSignature;
@property (nonatomic, strong) NSMethodSignature* delegateCallbackMethodSignature;

@property (nonatomic) float requestProcessingTime;
@property (nonatomic) float requestReceivedTime;
@property (nonatomic) double requestRoundTripTime;
@property (nonatomic) double requestStartMicroTime;
@property (nonatomic, strong) NSNumber* responseCode;
@property (nonatomic, strong) NSString* responseMessage;
@property (nonatomic, strong) NSNumber* timestamp;


@property (nonatomic, strong) NSString* APIKey;
@property (nonatomic, strong) NSString* secretKey;
@property (nonatomic) BOOL debugMode;
@property (nonatomic) BOOL useSSL;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSInteger APIServer;
@property (strong, nonatomic, readonly)NSDictionary* params;

- (KSAPIOperation*) initWithAPIKey:(NSString*)theAPIKey andSecretKey:(NSString*)theSecretKey andMethodName:(NSString*)methodName andParams:(NSDictionary*)theParams;
- (NSString*) md5:(NSString*) inString;
- (NSString *)encodeUTF8String:(NSString *)string;
- (NSString *) getDeviceID;
- (NSString *) encodeBase64WithString:(NSString *)strData;
- (NSString *) encodeBase64WithData:(NSData *)objData;
- (NSData *) decodeBase64WithString:(NSString *)strBase64;

@end


@class kumulosProxy;
@protocol kumulosProxyDelegate <NSObject>
@optional
- (void) kumulosAPI:(kumulosProxy*)kumulos apiOperation:(KSAPIOperation*)operation didFailWithError:(NSString*)theError;
@end

@interface kumulosProxy : NSObject <KSAPIOperationDelegate> {

	BOOL isLoading;
    NSOperationQueue* opQueue;
    BOOL useSSL;
}

@property (nonatomic) SEL callbackSelector;
@property (nonatomic, weak) id<kumulosProxyDelegate> delegate;
@property (nonatomic,strong) NSOperationQueue* opQueue;
@property (nonatomic) BOOL useSSL;

-(void)cancelAllOperations;
-(NSString*) md5:(NSString*) inString;
-(kumulosProxy*)init;

@end

@interface KSessionTokenManager : NSObject {
    NSString *sessionToken;
}

@property (nonatomic, retain) NSString *sessionToken;

+ (id)sharedManager;

@end
