#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"



using namespace cocos2d;
using namespace CocosDenshion;

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition( CCPointZero );
    this->addChild(pMenu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
  
    
    CCMenuItemFont *item1 = CCMenuItemFont::create("start", this, menu_selector(HelloWorld::onStart));
    CCMenuItemFont *item2 = CCMenuItemFont::create("stop", this, menu_selector(HelloWorld::onStop));
    CCMenu *menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    //camera = new CameraFile();
    
    video = VideoController::create();
    addChild(video);
    
    //video->setCamera(camera);
    
    item1->setScale(2);
    item2->setScale(2);
    item1->setPosition(ccp(0, 200));
    item2->setPosition(ccp(0, -200));
    
    Background *bk = Background::create();
    addChild(bk);
    Cannon *cannon = Cannon::create();
    addChild(cannon);
    cannon->setPosition(ccp(480, 320));
    
    //SimpleAudioEngine::sharedEngine()->playBackgroundMusic("love.mp3", true);
    //SimpleAudioEngine::sharedEngine()->playEffect("out.caf", true);
    
    
    item1 = CCMenuItemFont::create("startAudio", this, menu_selector(HelloWorld::onRecord));
    item2 = CCMenuItemFont::create("stopAudio", this, menu_selector(HelloWorld::stopRecord));
    menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    item1->setPosition(ccp(200, 200));
    item2->setPosition(ccp(200, -200));
    
    openAL = [[TestOpenAL alloc] init];
    item1 = CCMenuItemFont::create("startOpenAL", this, menu_selector(HelloWorld::onOpenAL));
    item2 = CCMenuItemFont::create("stopOpenAL", this, menu_selector(HelloWorld::stopOpenAL));
    menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    item1->setPosition(ccp(400, 200));
    item2->setPosition(ccp(400, -200));
    
    return true;
    
    
}
void HelloWorld::onOpenAL() {
    [openAL playSound];
}
void HelloWorld::stopOpenAL() {
    [openAL stopSound];
}

void HelloWorld::onRecord() {
    myAudio = [MyAudio myAudio];
    [myAudio startRecord];
}
void HelloWorld::stopRecord() {
    [myAudio stopRecord];
    [myAudio release];
}
void HelloWorld::onStart(CCObject *send){
    //const char *fileName = camera->getFileName();
    //CCLOG("fileName %s", fileName);
    //savedFile = string(fileName);
    
    
    show = ShowScene::create();
    CCLog("video is %x", video);
    show->setRenderLayer(this);
    show->setVideoController(video);
    
    //本场景只用于 update 和 draw 不用touch 处理
    
    CCDirector::sharedDirector()->setRenderLayer(this);
    CCDirector::sharedDirector()->setShowLayer(show);
    
    CCScene *scene = CCScene::create();
    removeFromParent();
    scene->addChild(this);
    scene->addChild(show);

    CCDirector::sharedDirector()->replaceScene(scene);
    
    
    video->startWork(960, 640, 960, 640, "", 1./30);
    
}
HelloWorld::~HelloWorld() {
    delete camera;
}
void HelloWorld::onStop(CCObject *send) {
    video->stopWork();
}
void HelloWorld::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}
