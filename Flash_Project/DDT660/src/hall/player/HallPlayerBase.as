package hall.player
{
   import com.greensock.TweenLite;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   
   public class HallPlayerBase extends SceneCharacterPlayerBase
   {
      
      private static var MountsWidth:int = 500;
      
      private static var MountsHeight:int = 400;
      
      public var playerWidth:Number = 170;
      
      public var playerHeight:Number = 175;
      
      public var resourceWidth:int = 120;
      
      public var resourceHeight:int = 175;
      
      private var _loadComplete:Boolean = false;
      
      private var _playerInfo:PlayerInfo;
      
      private var _callBack:Function;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _defaultSceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _defaultSceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _defaultSceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;
      
      private var _sceneCharacterLoaderBody:HallSceneCharacterLoaderLayer;
      
      private var _headBitmapData:BitmapData;
      
      private var _bodyBitmapData:BitmapData;
      
      private var _personPos:Point;
      
      private var _mountsPos:Point;
      
      private var _upDownPoints:Vector.<Point>;
      
      protected var playerHitArea:Sprite;
      
      protected var _petsSprite:Sprite;
      
      protected var _petsMovie:MovieClip;
      
      protected var _petsName:String;
      
      protected var _petsDis:int;
      
      public function HallPlayerBase(playerInfo:PlayerInfo, callBack:Function = null)
      {
         super(callBack);
         this._playerInfo = playerInfo;
         this._callBack = callBack;
         this.initialize();
         this.character.mouseEnabled = false;
         this.character.mouseChildren = false;
      }
      
      private function initialize() : void
      {
         this._sceneCharacterStateSet = new SceneCharacterStateSet();
         this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this._defaultSceneCharacterStateSet = new SceneCharacterStateSet();
         this._defaultSceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this.playerHitArea = new Sprite();
         this._petsSprite = new Sprite();
         addChildAt(this._petsSprite,0);
         this.initData();
         this.sceneCharacterLoadHead();
      }
      
      private function initData() : void
      {
         this._personPos = PositionUtils.creatPoint("hall.playerView.headPos");
         if(this._playerInfo.MountsType > 100)
         {
            this.copyVector(HallPlayerView.horsePicCherishPointsArray[this._playerInfo.MountsType - 101]);
         }
         else
         {
            this.copyVector(HallPlayerView.pointsArray[this._playerInfo.MountsType]);
         }
         if(this._playerInfo.IsMounts)
         {
            this.playerWidth = 500;
            this.playerHeight = 225;
         }
         else
         {
            this.playerWidth = 120;
            this._personPos = new Point(0,0);
         }
      }
      
      public function showPets(flag:Boolean, path:String = "") : void
      {
         if(Boolean(this._petsMovie))
         {
            if(this._petsSprite.contains(this._petsMovie))
            {
               this._petsSprite.removeChild(this._petsMovie);
            }
            ObjectUtils.disposeObject(this._petsMovie);
            this._petsMovie = null;
         }
         if(flag)
         {
            if(path == "")
            {
               path = PetsAdvancedManager.Instance.formDataList[PetsAdvancedManager.Instance.getFormDataIndexByTempId(this._playerInfo.PetsID)].Resource;
            }
            this.loadPets(path);
         }
         else
         {
            this._petsName = "";
         }
      }
      
      private function loadPets(path:String) : void
      {
         this._petsName = path;
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.petsAnimationPath(path),BaseLoader.MODULE_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadPetsComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function __onLoadPetsComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadPetsComplete);
         this._petsMovie = ComponentFactory.Instance.creat("game.living.L" + this._petsName.slice(1,this._petsName.length));
         PositionUtils.setPos(this._petsSprite,"hall.pets.Pos" + this._playerInfo.getPetsPosIndex());
         this._petsSprite.addChild(this._petsMovie);
         this.updatePetsPos();
      }
      
      private function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this._playerInfo);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
         if(!this._loadComplete)
         {
            this._headBitmapData = ComponentFactory.Instance.creatBitmapData("game.player.defaultPlayerCharacter");
            this.showDefaultCharacter();
         }
      }
      
      private function showDefaultCharacter() : void
      {
         var actionBmp:BitmapData = null;
         this._defaultSceneCharacterSetNatural = new SceneCharacterSet();
         var rectangle:Rectangle = new Rectangle(0,0,this.resourceWidth,this.resourceHeight);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._headBitmapData,rectangle,new Point(25,20));
         this._defaultSceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,1));
         var sceneCharacterActionItem1:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(sceneCharacterActionItem1);
         var sceneCharacterActionItem2:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(sceneCharacterActionItem2);
         var sceneCharacterActionItem3:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(sceneCharacterActionItem3);
         var sceneCharacterActionItem4:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(sceneCharacterActionItem4);
         var _sceneCharacterStateItemNatural:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._defaultSceneCharacterSetNatural,this._defaultSceneCharacterActionSetNatural);
         this._defaultSceneCharacterStateSet.push(_sceneCharacterStateItemNatural);
         super.loadComplete = false;
         super.isDefaultCharacter = true;
         super.sceneCharacterStateSet = this._defaultSceneCharacterStateSet;
      }
      
      private function sceneCharacterLoaderHeadCallBack(sceneCharacterLoaderHead:SceneCharacterLoaderHead, isAllLoadSucceed:Boolean = true) : void
      {
         this._headBitmapData = sceneCharacterLoaderHead.getContent()[0] as BitmapData;
         if(Boolean(sceneCharacterLoaderHead))
         {
            sceneCharacterLoaderHead.dispose();
         }
         if(!isAllLoadSucceed || !this._headBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false,-1);
            }
            return;
         }
         if(Boolean(this._playerInfo))
         {
            this.sceneCharacterStateNatural();
         }
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var actionBmp:BitmapData = null;
         this._sceneCharacterSetNatural = new SceneCharacterSet();
         var rectangle:Rectangle = new Rectangle(0,0,this.resourceWidth,this.resourceHeight);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._headBitmapData,rectangle,this._personPos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,1,this._upDownPoints,true,7));
         rectangle.x = this.resourceWidth;
         rectangle.y = 0;
         rectangle.width = this.resourceWidth;
         rectangle.height = this.resourceHeight;
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._headBitmapData,rectangle,this._personPos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,2));
         if(Boolean(this._playerInfo) && !this._playerInfo.IsMounts)
         {
            rectangle.x = this.resourceWidth * 2;
            rectangle.y = 0;
            rectangle.width = this.resourceWidth;
            rectangle.height = this.resourceHeight;
            actionBmp = new BitmapData(this.resourceWidth,this.resourceHeight * 2,true,0);
            actionBmp.copyPixels(this._headBitmapData,rectangle,this._personPos);
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead","NaturalBackAction",actionBmp,1,1,this.playerWidth,this.playerHeight,6,this._upDownPoints,true,7));
         }
         this.sceneCharacterLoadBodyNatural();
      }
      
      private function sceneCharacterLoadBodyNatural() : void
      {
         this._sceneCharacterLoaderBody = new HallSceneCharacterLoaderLayer(this._playerInfo);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      private function sceneCharacterLoaderBodyNaturalCallBack(sceneCharacterLoaderBody:HallSceneCharacterLoaderLayer, isAllLoadSucceed:Boolean) : void
      {
         if(!this.callBackSetInfo(sceneCharacterLoaderBody,isAllLoadSucceed))
         {
            return;
         }
         if(this._playerInfo.IsMounts)
         {
            this.mountsWalkAnimation();
         }
         else
         {
            this.peopleWalkAnimation();
            this.setSceneState();
         }
      }
      
      private function mountsWalkAnimation() : void
      {
         if(this._playerInfo.getIsRide())
         {
            this._mountsPos = PositionUtils.creatPoint("hall.playerView.mounts2Pos");
            this.loadRideCloths();
         }
         else
         {
            this._mountsPos = PositionUtils.creatPoint("hall.playerView.mountsPos");
            this.loadRugCloths();
         }
      }
      
      private function loadRideCloths() : void
      {
         var actionBmp:BitmapData = null;
         var point:Point = PositionUtils.creatPoint("hall.playerView.bodyPos");
         var rectangle1:Rectangle = new Rectangle(this._bodyBitmapData.width / 3 * 2,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle1,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,3,this._upDownPoints,true,7));
         var rectangle2:Rectangle = new Rectangle(this._bodyBitmapData.width / 3 * 2,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle2,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,4));
         var rectangle3:Rectangle = new Rectangle(this._bodyBitmapData.width / 3,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle3,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,9,this._upDownPoints,true,7));
         var rectangle4:Rectangle = new Rectangle(this._bodyBitmapData.width / 3,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle4,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,10));
         this.loadMounts();
      }
      
      private function loadRugCloths() : void
      {
         var actionBmp:BitmapData = null;
         var point:Point = PositionUtils.creatPoint("hall.playerView.bodyPos");
         var rectangle1:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle1,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,9,this._upDownPoints,true,7));
         var rectangle2:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width / 3,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle2,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,10));
         this.loadMountsSaddle();
      }
      
      private function loadMountsSaddle() : void
      {
         var saddleLoader:HallSceneCharacterLoaderLayer = new HallSceneCharacterLoaderLayer(this._playerInfo,1);
         saddleLoader.load(this.saddleLoaderCompleteCallBack);
      }
      
      private function saddleLoaderCompleteCallBack(saddleLoader:HallSceneCharacterLoaderLayer, isAllLoadSucceed:Boolean) : void
      {
         var actionBmp:BitmapData = null;
         if(!this.callBackSetInfo(saddleLoader,isAllLoadSucceed))
         {
            return;
         }
         var point:Point = PositionUtils.creatPoint("hall.playerView.saddlePos");
         var rectangle1:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle1,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontSaddle","NaturalFrontAction",actionBmp,1,1,this.playerWidth,this.playerHeight,7,this._upDownPoints,true,7));
         var rectangle2:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle2,point);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseSaddle","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,8));
         this.loadMounts();
      }
      
      private function loadMounts() : void
      {
         var mountsLoader:HallSceneCharacterLoaderLayer = new HallSceneCharacterLoaderLayer(this._playerInfo,2);
         mountsLoader.load(this.mountsLoaderCompleteCallBack);
      }
      
      private function mountsLoaderCompleteCallBack(mountsLoader:HallSceneCharacterLoaderLayer, isAllLoadSucceed:Boolean) : void
      {
         var actionBmp:BitmapData = null;
         var pos:Point = null;
         if(!this.callBackSetInfo(mountsLoader,isAllLoadSucceed))
         {
            return;
         }
         var rectangle1:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width,this._bodyBitmapData.height);
         actionBmp = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         if(this._playerInfo.MountsType == 106)
         {
            pos = new Point(this._mountsPos.x,this._mountsPos.y - 5);
         }
         else
         {
            pos = this._mountsPos;
         }
         actionBmp.copyPixels(this._bodyBitmapData,rectangle1,pos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontMounts","NaturalFrontAction",actionBmp,1,7,this.playerWidth,this.playerHeight,5));
         var rectangle2:Rectangle = new Rectangle(0,0,MountsWidth,MountsHeight);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle2,pos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseMounts","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,6));
         this.setPlayerAndMountsAction();
      }
      
      private function setPlayerAndMountsAction() : void
      {
         var sceneCharacterActionItem1:SceneCharacterActionItem = null;
         if(this._playerInfo.getIsSpecialRide())
         {
            sceneCharacterActionItem1 = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6],true);
         }
         else
         {
            sceneCharacterActionItem1 = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         }
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem1);
         var sceneCharacterActionItem2:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem2);
         this.setSceneState();
      }
      
      private function callBackSetInfo(loader:HallSceneCharacterLoaderLayer, isAllLoadSucceed:Boolean) : Boolean
      {
         if(!this._sceneCharacterSetNatural)
         {
            return false;
         }
         this._bodyBitmapData = loader.getContent()[0] as BitmapData;
         if(Boolean(loader))
         {
            loader.dispose();
         }
         if(!isAllLoadSucceed || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false,-1);
            }
            return false;
         }
         return true;
      }
      
      private function peopleWalkAnimation() : void
      {
         var actionBmp:BitmapData = null;
         var rectangle1:Rectangle = new Rectangle(0,0,this._bodyBitmapData.width,this.resourceHeight);
         actionBmp = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle1,this._personPos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",actionBmp,1,7,this.playerWidth,this.playerHeight,3));
         var rectangle2:Rectangle = new Rectangle(0,0,this.resourceWidth,this.resourceHeight);
         actionBmp = new BitmapData(this.playerWidth,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle2,this._personPos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",actionBmp,1,1,this.playerWidth,this.playerHeight,4));
         var rectangle3:Rectangle = new Rectangle(0,this.resourceHeight,this._bodyBitmapData.width,this.resourceHeight);
         actionBmp = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,rectangle3,this._personPos);
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody","NaturalBackAction",actionBmp,1,7,this.playerWidth,this.playerHeight,5));
         var sceneCharacterActionItem1:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem1);
         var sceneCharacterActionItem2:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[8],false);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem2);
         var sceneCharacterActionItem3:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem3);
         var sceneCharacterActionItem4:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem4);
      }
      
      private function setSceneState() : void
      {
         this._loadComplete = true;
         var sceneCharacterStateItemNatural:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._sceneCharacterSetNatural,this._sceneCharacterActionSetNatural);
         this._sceneCharacterStateSet.push(sceneCharacterStateItemNatural);
         super.loadComplete = true;
         super.isDefaultCharacter = false;
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
         this.disposeDefaultSource();
         this.createHitArea();
         if(this._playerInfo.PetsID > 0)
         {
            this.showPets(true);
         }
      }
      
      private function copyVector(vector:Vector.<Point>) : void
      {
         this._upDownPoints = new Vector.<Point>();
         for(var i:int = 0; i < vector.length; i++)
         {
            this._upDownPoints.push(vector[i]);
         }
      }
      
      private function createHitArea() : void
      {
         if(!this._playerInfo.isSelf && this._sceneCharacterStateSet.dataSet[0].frameBitmap.length > 0)
         {
            this.playerHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._sceneCharacterStateSet.dataSet[0].frameBitmap[0]));
            this.playerHitArea.alpha = 0;
            PositionUtils.setPos(this.playerHitArea,character);
            this.playerHitArea.buttonMode = true;
            addChild(this.playerHitArea);
            this.playerHitArea.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
            this.playerHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
            this.playerHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         }
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
      }
      
      protected function __onMouseOver(event:MouseEvent) : void
      {
         setCharacterFilter(true);
      }
      
      protected function __onMouseOut(event:MouseEvent) : void
      {
         setCharacterFilter(false);
      }
      
      private function disposeDefaultSource() : void
      {
         if(Boolean(this._defaultSceneCharacterStateSet))
         {
            this._defaultSceneCharacterStateSet.dispose();
         }
         this._defaultSceneCharacterStateSet = null;
         if(Boolean(this._defaultSceneCharacterSetNatural))
         {
            this._defaultSceneCharacterSetNatural.dispose();
         }
         this._defaultSceneCharacterSetNatural = null;
         if(Boolean(this._defaultSceneCharacterActionSetNatural))
         {
            this._defaultSceneCharacterActionSetNatural.dispose();
         }
         this._defaultSceneCharacterActionSetNatural = null;
      }
      
      protected function updatePetsPos() : void
      {
         var desX:int = 0;
         if(Boolean(this._petsMovie))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.LB)
            {
               this._petsSprite.scaleX = 1;
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.RT || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               this._petsSprite.scaleX = -1;
            }
            desX = -this._petsSprite.scaleX * this.playerWidth / 2 + this._petsSprite.scaleX * this._petsDis;
            TweenLite.to(this._petsSprite,1.2,{"x":desX});
            if(!this._playerInfo.IsMounts && (sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT))
            {
               this._petsMovie.gotoAndPlay("standB");
            }
            else
            {
               this._petsMovie.gotoAndPlay("standA");
            }
         }
      }
      
      protected function setPetsVisible(flag:Boolean) : void
      {
         if(Boolean(this._petsSprite))
         {
            this._petsSprite.visible = flag;
         }
      }
      
      override public function dispose() : void
      {
         this.disposeDefaultSource();
         this._playerInfo = null;
         this._callBack = null;
         if(Boolean(this._sceneCharacterSetNatural))
         {
            this._sceneCharacterSetNatural.dispose();
         }
         this._sceneCharacterSetNatural = null;
         if(Boolean(this._sceneCharacterActionSetNatural))
         {
            this._sceneCharacterActionSetNatural.dispose();
         }
         this._sceneCharacterActionSetNatural = null;
         if(Boolean(this._sceneCharacterStateSet))
         {
            this._sceneCharacterStateSet.dispose();
         }
         this._sceneCharacterStateSet = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderBody);
         this._sceneCharacterLoaderBody = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderHead);
         this._sceneCharacterLoaderHead = null;
         ObjectUtils.disposeObject(this.playerHitArea);
         this.playerHitArea = null;
         if(Boolean(this._petsMovie))
         {
            ObjectUtils.disposeObject(this._petsMovie);
            this._petsMovie = null;
         }
         this._petsSprite = null;
         if(Boolean(this._headBitmapData))
         {
            this._headBitmapData.dispose();
         }
         this._headBitmapData = null;
         if(Boolean(this._bodyBitmapData))
         {
            this._bodyBitmapData.dispose();
         }
         this._bodyBitmapData = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

