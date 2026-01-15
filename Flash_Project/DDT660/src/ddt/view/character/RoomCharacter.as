package ddt.view.character
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class RoomCharacter extends BaseCharacter
   {
      
      private static var _keyWords:Dictionary;
      
      public static const STANDBY:String = "standBy";
      
      public static const CLOSE_EYES:String = "close_Eyes";
      
      public static const WANDERING:String = "wandering";
      
      public static const DAZED:String = "dazed";
      
      public static const SMILE:String = "smile";
      
      public static const SELF_SATISFIED:String = "selfSatisfied";
      
      public static const RUT:String = "rut";
      
      public static const WHISTLE:String = "whistle";
      
      public static const MUG:String = "mug";
      
      private static const RANDOM_EXPRESSION:Array = [CLOSE_EYES,WANDERING,DAZED,SMILE,WHISTLE];
      
      public static const HAPPY:String = "happy";
      
      public static const LUAGH:String = "luagh";
      
      public static const NAUGHTY:String = "naughty";
      
      public static const SAD:String = "sad";
      
      public static const SARROWFUL:String = "sarrowful";
      
      public static const LOOK_AWRY:String = "look_awry";
      
      public static const ANGRY:String = "angry";
      
      public static const SULK:String = "sulk";
      
      public static const COLD:String = "cold";
      
      public static const DIZZY:String = "dizzy";
      
      public static const SUPRISE:String = "suprise";
      
      public static const SICK:String = "sick";
      
      public static const SLEEPING:String = "sleeping";
      
      public static const OH_MY_GOD:String = "oh_My_God";
      
      public static const LOVE:String = "love";
      
      private var _faceUpBmd:BitmapData;
      
      private var _faceBmd:BitmapData;
      
      private var _suitBmd:BitmapData;
      
      private var _light1:MovieClip;
      
      private var _light2:MovieClip;
      
      private var _light01:BaseLightLayer;
      
      private var _light02:SinpleLightLayer;
      
      private var _wing:MovieClip;
      
      private var _currentAction:RoomPlayerAction;
      
      private var _showGun:Boolean;
      
      private var _recordNimbus:int;
      
      private var _playAnimation:Boolean = true;
      
      private var _faceFrames:Array;
      
      private var _rect:Rectangle;
      
      private var _faceRect:Rectangle = new Rectangle(40,0,250,232);
      
      private var _test:int = 0;
      
      public function RoomCharacter(info:PlayerInfo, showGun:Boolean = false)
      {
         this._currentAction = RoomPlayerAction.creatAction(STANDBY,info.getShowSuits());
         this._showGun = showGun;
         super(info,true);
      }
      
      public static function getActionByWord(word:String) : String
      {
         var key:String = null;
         for(key in KEY_WORDS)
         {
            if(_keyWords[key].indexOf(word) > -1)
            {
               return key;
            }
         }
         return STANDBY;
      }
      
      private static function get KEY_WORDS() : Dictionary
      {
         if(_keyWords == null)
         {
            _keyWords = new Dictionary();
            _keyWords[HAPPY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.HAPPY").split("|");
            _keyWords[LUAGH] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LUAGH").split("|");
            _keyWords[NAUGHTY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.NAUGHTY").split("|");
            _keyWords[SAD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SAD").split("|");
            _keyWords[SARROWFUL] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SARROWFUL").split("|");
            _keyWords[LOOK_AWRY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LOOK_AWRY").split("|");
            _keyWords[ANGRY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.ANGRY").split("|");
            _keyWords[SULK] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SULK").split("|");
            _keyWords[COLD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.COLD").split("|");
            _keyWords[DIZZY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.DIZZY").split("|");
            _keyWords[SUPRISE] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SUPRISE").split("|");
            _keyWords[SICK] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SICK").split("|");
            _keyWords[SLEEPING] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SLEEPING").split("|");
            _keyWords[OH_MY_GOD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.OH_MY_GOD").split("|");
            _keyWords[LOVE] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LOVE").split("|");
         }
         return _keyWords;
      }
      
      override public function set showGun(value:Boolean) : void
      {
         this._showGun = value;
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.ROOM);
         RoomCharaterLoader(_loader).showWeapon = this._showGun;
      }
      
      override protected function setContent() : void
      {
         var _recordStyle:Array = null;
         if(_loader != null)
         {
            if(Boolean(this._suitBmd) && this._suitBmd != _loader.getContent()[0])
            {
               this._suitBmd.dispose();
            }
            this._suitBmd = _loader.getContent()[0];
            if(Boolean(this._faceBmd) && this._faceBmd != _loader.getContent()[2])
            {
               this._faceBmd.dispose();
            }
            this._faceBmd = _loader.getContent()[2];
            if(Boolean(this._faceUpBmd) && this._faceUpBmd != _loader.getContent()[1])
            {
               this._faceUpBmd.dispose();
            }
            this._faceUpBmd = _loader.getContent()[1];
            if(Boolean(this._wing) && Boolean(this._wing.parent))
            {
               this._wing.parent.removeChild(this._wing);
            }
            this._wing = _loader.getContent()[3];
            if(Boolean(this._wing) && !this._playAnimation)
            {
               this.stopMovieClip(this._wing);
            }
         }
         _body.width = BASE_WIDTH;
         _body.height = BASE_HEIGHT;
         _body.cacheAsBitmap = true;
         if(_info.getSuitsType() == 1)
         {
            _body.y = -13;
            _recordStyle = _info.Style.split(",");
            if(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])).Property1 != "1")
            {
               if(Boolean(this._wing))
               {
                  this._wing.y = -40;
               }
            }
         }
         else
         {
            _body.y = 0;
            if(Boolean(this._wing))
            {
               this._wing.y = 0;
            }
         }
         this.sortIndex();
      }
      
      private function sortIndex() : void
      {
         if(this._light1 != null)
         {
            _container.addChild(this._light1);
         }
         if(this._wing != null && !_info.wingHide)
         {
            _container.addChild(this._wing);
         }
         if(_body != null)
         {
            _container.addChild(_body);
         }
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
         }
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(ShowCharacter.BIG_WIDTH,ShowCharacter.BIG_HEIGHT);
         setPicNum(1,4);
         this._rect = new Rectangle(0,0,_characterWidth,_characterHeight);
      }
      
      override public function update() : void
      {
         if(!this._currentAction.repeat && this._currentAction.isEnd)
         {
            this.randomAction();
         }
         this.drawFrame(this._currentAction.next());
      }
      
      private function randomAction() : void
      {
         var seed:Number = Math.random();
         if(seed < 0.5)
         {
            this._currentAction = RoomPlayerAction.creatAction(CLOSE_EYES,_info.getShowSuits());
         }
         else
         {
            this._currentAction = RoomPlayerAction.creatAction(WANDERING,_info.getShowSuits());
         }
      }
      
      override protected function __loadComplete(loader:ICharacterLoader) : void
      {
         super.__loadComplete(loader);
         this.updateLight();
      }
      
      private function updateLight() : void
      {
         if(_info == null)
         {
            return;
         }
         if(this._recordNimbus != _info.Nimbus)
         {
            this._recordNimbus = _info.Nimbus;
            if(_info.getHaveLight())
            {
               if(Boolean(this._light02))
               {
                  this._light02.dispose();
               }
               this._light02 = new SinpleLightLayer(_info.Nimbus);
               this._light02.load(this.callBack02);
            }
            else
            {
               if(Boolean(this._light02))
               {
                  this._light02.dispose();
               }
               if(Boolean(this._light2) && Boolean(this._light2.parent))
               {
                  this._light2.parent.removeChild(this._light2);
               }
               this._light2 = null;
            }
            if(_info.getHaveCircle())
            {
               if(Boolean(this._light01))
               {
                  this._light01.dispose();
               }
               if(Boolean(this._light1) && Boolean(this._light1.parent))
               {
                  this._light1.parent.removeChild(this._light1);
               }
               this._light1 = null;
               this._light01 = new BaseLightLayer(_info.Nimbus);
               this._light01.load(this.callBack01);
            }
            else
            {
               if(Boolean(this._light01))
               {
                  this._light01.dispose();
               }
               if(Boolean(this._light1) && Boolean(this._light1.parent))
               {
                  this._light1.parent.removeChild(this._light1);
               }
               this._light1 = null;
            }
         }
      }
      
      private function callBack01($load:BaseLightLayer) : void
      {
         if(Boolean(this._light1) && Boolean(this._light1.parent))
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = $load.getContent() as MovieClip;
         if(this._light1 != null)
         {
            _container.addChildAt(this._light1,0);
            this._light1.x = 47;
            this._light1.y = 65;
         }
         this.restoreAnimationState();
         this.sortIndex();
      }
      
      private function callBack02($load:SinpleLightLayer) : void
      {
         if(Boolean(this._light2) && Boolean(this._light2.parent))
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = $load.getContent() as MovieClip;
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
            this._light2.x = 45;
            this._light2.y = 126;
         }
         this.restoreAnimationState();
         this.sortIndex();
      }
      
      public function stopAnimation() : void
      {
         this._playAnimation = false;
         this.stopAllMoiveClip();
      }
      
      public function playAnimation() : void
      {
         this._playAnimation = true;
         this.playAllMoiveClip();
      }
      
      private function stopAllMoiveClip() : void
      {
         this.stopMovieClip(this._light1);
         this.stopMovieClip(this._light2);
         this.stopMovieClip(this._wing);
      }
      
      private function playAllMoiveClip() : void
      {
         this.playMovieClip(this._light1);
         this.playMovieClip(this._light2);
         this.playMovieClip(this._wing);
      }
      
      private function restoreAnimationState() : void
      {
         if(this._playAnimation)
         {
            this.playAllMoiveClip();
         }
         else
         {
            this.stopAllMoiveClip();
         }
      }
      
      private function stopMovieClip(mc:MovieClip) : void
      {
         var i:int = 0;
         if(Boolean(mc))
         {
            mc.gotoAndStop(1);
            if(mc.numChildren > 0)
            {
               for(i = 0; i < mc.numChildren; i++)
               {
                  this.stopMovieClip(mc.getChildAt(i) as MovieClip);
               }
            }
         }
      }
      
      private function playMovieClip(mc:MovieClip) : void
      {
         var i:int = 0;
         if(Boolean(mc))
         {
            mc.gotoAndPlay(1);
            if(mc.numChildren > 0)
            {
               for(i = 0; i < mc.numChildren; i++)
               {
                  this.playMovieClip(mc.getChildAt(i) as MovieClip);
               }
            }
         }
      }
      
      override public function doAction(actionType:*) : void
      {
         if(actionType == "")
         {
            return;
         }
         this._currentAction = RoomPlayerAction.creatAction(actionType,_info.getShowSuits());
      }
      
      override protected function createFrames() : void
      {
         var i:int = 0;
         var m:Rectangle = null;
         super.createFrames();
         this._faceFrames = [];
         for(var j:int = 0; j < _picLines; j++)
         {
            for(i = 0; i < _picsPerLine; i++)
            {
               m = new Rectangle(i * 250,j * 232,250,232);
               this._faceFrames.push(m);
            }
         }
      }
      
      override public function drawFrame(frame:int, type:int = 0, clearOld:Boolean = true) : void
      {
         _body.bitmapData.fillRect(this._rect,0);
         if(_info.getShowSuits() && Boolean(this._suitBmd))
         {
            _body.bitmapData.copyPixels(this._suitBmd,_frames[frame],new Point(0,0),null,null,true);
         }
         else if(this._faceBmd != null && this._faceUpBmd != null)
         {
            _body.bitmapData.copyPixels(this._faceBmd,_frames[frame],new Point(0,0),null,null,true);
            _body.bitmapData.copyPixels(this._faceUpBmd,_frames[0],new Point(0,0),null,null,true);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._faceUpBmd))
         {
            this._faceUpBmd.dispose();
         }
         this._faceUpBmd = null;
         if(Boolean(this._faceBmd))
         {
            this._faceBmd.dispose();
         }
         this._faceBmd = null;
         if(Boolean(this._suitBmd))
         {
            this._suitBmd.dispose();
         }
         this._suitBmd = null;
         if(Boolean(this._light1))
         {
            ObjectUtils.disposeObject(this._light1);
         }
         this._light1 = null;
         if(Boolean(this._light2))
         {
            ObjectUtils.disposeObject(this._light2);
         }
         this._light2 = null;
         if(Boolean(this._light01))
         {
            ObjectUtils.disposeObject(this._light01);
         }
         this._light01 = null;
         if(Boolean(this._light02))
         {
            ObjectUtils.disposeObject(this._light02);
         }
         this._light02 = null;
         if(Boolean(this._wing))
         {
            ObjectUtils.disposeObject(this._wing);
         }
         this._wing = null;
         this._currentAction = null;
         _keyWords = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

