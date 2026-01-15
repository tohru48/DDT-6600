package Dice.VO
{
   import Dice.Controller.DiceController;
   import ddt.data.player.PlayerInfo;
   import ddt.events.SceneCharacterEvent;
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
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DicePlayerBase extends SceneCharacterPlayerBase
   {
      
      private var _playerInfo:PlayerInfo;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _headBitmapData:BitmapData;
      
      private var _bodyBitmapData:BitmapData;
      
      private var _rectangle:Rectangle = new Rectangle();
      
      private var _sceneCharacterLoaderBody:DiceSceneCharacterLoaderBody;
      
      private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;
      
      private var _callBack:Function;
      
      private var _SynchronousPosition:Function;
      
      private var _isWalk:Boolean = false;
      
      public var _playerWidth:Number = 120;
      
      public var _playerHeight:Number = 175;
      
      public function DicePlayerBase(playerInfo:PlayerInfo, SynchronousPosition:Function = null, callBack:Function = null)
      {
         super(callBack);
         this._playerInfo = playerInfo;
         this._callBack = callBack;
         this._SynchronousPosition = SynchronousPosition;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._sceneCharacterStateSet = new SceneCharacterStateSet();
         this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterLoadHead();
      }
      
      private function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this._playerInfo);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
      }
      
      private function sceneCharacterLoaderHeadCallBack(sceneCharacterLoaderHead:SceneCharacterLoaderHead, isAllLoadSuccess:Boolean = true) : void
      {
         this._headBitmapData = sceneCharacterLoaderHead.getContent()[0] as BitmapData;
         if(Boolean(sceneCharacterLoaderHead))
         {
            sceneCharacterLoaderHead.dispose();
         }
         if(!isAllLoadSuccess || !this._headBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         this.sceneCharacterStateNatural();
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var actionBmp:BitmapData = null;
         this._sceneCharacterSetNatural = new SceneCharacterSet();
         var points:Vector.<Point> = new Vector.<Point>();
         points.push(new Point(0,0));
         points.push(new Point(0,0));
         points.push(new Point(0,-1));
         points.push(new Point(0,2));
         points.push(new Point(0,0));
         points.push(new Point(0,-1));
         points.push(new Point(0,2));
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._playerWidth;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._playerWidth,this._playerHeight,true,0);
         actionBmp.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",actionBmp,1,1,this._playerWidth,this._playerHeight,1,points,true,7));
         this._rectangle.x = this._playerWidth;
         this._rectangle.y = 0;
         this._rectangle.width = this._playerWidth;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._playerWidth,this._playerHeight,true,0);
         actionBmp.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead","NaturalFrontEyesCloseAction",actionBmp,1,1,this._playerWidth,this._playerHeight,2));
         this._rectangle.x = this._playerWidth * 2;
         this._rectangle.y = 0;
         this._rectangle.width = this._playerWidth;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._playerWidth,this._playerHeight * 2,true,0);
         actionBmp.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead","NaturalBackAction",actionBmp,1,1,this._playerWidth,this._playerHeight,6,points,true,7));
         this.sceneCharacterLoadBodyNatural();
      }
      
      private function sceneCharacterLoadBodyNatural() : void
      {
         this._sceneCharacterLoaderBody = new DiceSceneCharacterLoaderBody(this._playerInfo);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      private function sceneCharacterLoaderBodyNaturalCallBack(sceneCharacterLoaderBody:DiceSceneCharacterLoaderBody, isAllLoadSuccess:Boolean = true) : void
      {
         var actionBmp:BitmapData = null;
         if(!this._sceneCharacterSetNatural)
         {
            return;
         }
         this._bodyBitmapData = sceneCharacterLoaderBody.getContent()[0] as BitmapData;
         if(Boolean(sceneCharacterLoaderBody))
         {
            sceneCharacterLoaderBody.dispose();
         }
         if(!isAllLoadSuccess || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._bodyBitmapData.width,this._playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",actionBmp,1,7,this._playerWidth,this._playerHeight,3));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._playerWidth;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._playerWidth,this._playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",actionBmp,1,1,this._playerWidth,this._playerHeight,4));
         this._rectangle.x = 0;
         this._rectangle.y = this._playerHeight;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this._playerHeight;
         actionBmp = new BitmapData(this._bodyBitmapData.width,this._playerHeight,true,0);
         actionBmp.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalbackBody","NaturalBackAction",actionBmp,1,7,this._playerWidth,this._playerHeight,5));
         var sceneCharacterActionItem1:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem1);
         var sceneCharacterActionItem2:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[8],false);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem2);
         var sceneCharacterActionItem3:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem3);
         var sceneCharacterActionItem4:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14],true);
         this._sceneCharacterActionSetNatural.push(sceneCharacterActionItem4);
         var _sceneCharacterStateItemNatural:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._sceneCharacterSetNatural,this._sceneCharacterActionSetNatural);
         this._sceneCharacterStateSet.push(_sceneCharacterStateItemNatural);
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
      }
      
      override public function playerWalk(walkPath:Array) : void
      {
         var _walkPath0:Point = null;
         var po1:Point = null;
         var _walkDistance:Number = NaN;
         _walkPath = walkPath;
         if(Boolean(_walkPath) && _walkPath.length > 0)
         {
            sceneCharacterDirection = SceneCharacterDirection.getDirection(new Point(this.x,this.y),_walkPath[0]);
            _walkPath0 = _walkPath[0] as Point;
            po1 = new Point(this.x,this.y);
            _walkDistance = Point.distance(_walkPath0,new Point(this.x,this.y));
            if(_walkDistance > 0 || DiceController.Instance.CurrentPosition == 0)
            {
               if(sceneCharacterDirection.type == "RT" && this.y - _walkPath[0].y <= 1)
               {
                  sceneCharacterDirection = new SceneCharacterDirection("LB",true);
               }
               dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
            }
            _tween.start(_walkDistance / _moveSpeed,"x",_walkPath[0].x,"y",_walkPath[0].y);
            if(this._SynchronousPosition != null)
            {
               this._SynchronousPosition(_walkPath[0]);
            }
            _walkPath.shift();
         }
         else
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
      }
      
      override public function dispose() : void
      {
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
         if(Boolean(this._sceneCharacterLoaderBody))
         {
            this._sceneCharacterLoaderBody.dispose();
         }
         this._sceneCharacterLoaderBody = null;
         if(Boolean(this._sceneCharacterLoaderHead))
         {
            this._sceneCharacterLoaderHead.dispose();
         }
         this._sceneCharacterLoaderHead = null;
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
         this._rectangle = null;
         super.dispose();
      }
   }
}

