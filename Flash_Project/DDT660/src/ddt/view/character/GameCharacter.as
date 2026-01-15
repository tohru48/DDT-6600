package ddt.view.character
{
   import com.greensock.TweenMax;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.PlayerAction;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.BitmapUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import game.model.Player;
   import road7th.utils.StringHelper;
   
   public class GameCharacter extends BaseCharacter
   {
      
      private static const STAND_FRAME_1:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10];
      
      private static const STAND_FRAME_2:Array = [7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7];
      
      public static const STAND:PlayerAction = new PlayerAction("stand",[STAND_FRAME_1,STAND_FRAME_2],false,true,false);
      
      private static const LACK_FACE_DOWN:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      private static const LACK_FACE_UP:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      private static const STAND_LACK_HP_FRAME:Array = [0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0,0,1,1,2,2,3,3,3,3,3,2,2,1,1,0,0,0,0];
      
      private static const STAND_LACK_HP_FRAME_1:Array = [0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2];
      
      public static const STAND_LACK_HP:PlayerAction = new PlayerAction("standLackHP",[STAND_LACK_HP_FRAME,STAND_LACK_HP_FRAME_1],false,false,false);
      
      public static const WALK_LACK_HP:PlayerAction = new PlayerAction("walkLackHP",[[1,1,2,2,3,3,4,4,5,5]],false,true,false);
      
      public static const WALK:PlayerAction = new PlayerAction("walk",[[1,1,2,2,3,3,4,4,5,5]],false,true,false);
      
      public static const SHOT:PlayerAction = new PlayerAction("shot",[[22,23,26,27]],true,false,true);
      
      public static const STOPSHOT:PlayerAction = new PlayerAction("stopshot",[[23]],true,false,false);
      
      public static const SHOWGUN:PlayerAction = new PlayerAction("showgun",[[19,20,21,21,21]],true,false,true);
      
      public static const HIDEGUN:PlayerAction = new PlayerAction("hidegun",[[27]],true,false,false);
      
      public static const THROWS:PlayerAction = new PlayerAction("throws",[[31,32,33,34,35]],true,false,true);
      
      public static const STOPTHROWS:PlayerAction = new PlayerAction("stopthrows",[[34]],true,false,false);
      
      public static const SHOWTHROWS:PlayerAction = new PlayerAction("showthrows",[[28,29,30,30,30]],true,false,true);
      
      public static const HIDETHROWS:PlayerAction = new PlayerAction("hidethrows",[[35]],true,false,false);
      
      public static const SHAKE:PlayerAction = new PlayerAction("shake",[[6,6,7,7,8,8,9,9,8,8,7,7,6,6]],false,false,false);
      
      public static const HANDCLIP:PlayerAction = new PlayerAction("handclip",[[13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13]],true,false,false);
      
      public static const HANDCLIP_LACK_HP:PlayerAction = new PlayerAction("handclip",[[13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13,14,14,15,15,14,14,13,13]],true,false,false);
      
      public static const SOUL:PlayerAction = new PlayerAction("soul",[[0]],false,true,false);
      
      public static const SOUL_MOVE:PlayerAction = new PlayerAction("soulMove",[[1]],false,true,false);
      
      public static const SOUL_SMILE:PlayerAction = new PlayerAction("soulSmile",[[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]],false,false,false);
      
      public static const SOUL_CRY:PlayerAction = new PlayerAction("soulCry",[[3]],false,true,false);
      
      public static const CRY:PlayerAction = new PlayerAction("cry",[[16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18,16,16,17,17,18,18]],false,false,false);
      
      public static const HIT:PlayerAction = new PlayerAction("hit",[[12,12,24,24,24,24,24,24,24,24,25,25,38,38,38,38,11,11,11,11]],false,false,false);
      
      public static const SPECIAL_EFFECT_FRAMES:Array = [0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2,2,3,3,0,0,1,1,2];
      
      private static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public static const PET_CALL:PlayerAction = new PlayerAction("petCall",[[28,29,29,30,30,31,31,32,32,33,33,34,34,35,35,35,35,35,35,35,35,35,35,35,35,35,35]],false,false,false);
      
      public static const GAME_WING_WAIT:int = 1;
      
      public static const GAME_WING_MOVE:int = 2;
      
      public static const GAME_WING_CRY:int = 3;
      
      public static const GAME_WING_CLIP:int = 4;
      
      public static const GAME_WING_SHOOT:int = 5;
      
      private var _currentAction:PlayerAction;
      
      private var _defaultAction:PlayerAction;
      
      private var _wing:MovieClip;
      
      private var _ghostMovie:MovieClip;
      
      private var _ghostShine:MovieClip;
      
      private var _frameStartPoint:Point = new Point(0,0);
      
      private var _defaultStartPoint:Point;
      
      private var _spBitmapData:Vector.<BitmapData>;
      
      private var _faceupBitmapData:BitmapData;
      
      private var _faceBitmapData:BitmapData;
      
      private var _lackHpFaceBitmapdata:Vector.<BitmapData>;
      
      private var _faceDownBitmapdata:BitmapData;
      
      private var _normalSuit:BitmapData;
      
      private var _lackHpSuit:BitmapData;
      
      private var _soulFace:BitmapData;
      
      private var _defaultFace:BitmapData;
      
      private var _tempCryFace:BitmapData;
      
      private var _cryTypes:Array = [0,16,13,10];
      
      private var _cryType:int;
      
      private var _specialType:int = 0;
      
      private var _state:int = Player.FULL_HP;
      
      private var _rect:Rectangle;
      
      private var _hasSuitSoul:Boolean = true;
      
      private var _cryFrace:Sprite;
      
      private var _cryBmps:Vector.<Bitmap>;
      
      protected var _colors:Array;
      
      private var _isLackHp:Boolean;
      
      private var _hasChangeToLackHp:Boolean;
      
      private var _index:int = 90 * Math.random();
      
      private var _isPlaying:Boolean = false;
      
      private var black:Boolean;
      
      private var blackBm:Bitmap;
      
      private var blackEyes:MovieClip;
      
      private var _wingState:int = 0;
      
      private var closeEys:int;
      
      public function GameCharacter(info:PlayerInfo)
      {
         super(info,true);
         this._currentAction = this._defaultAction = STAND;
         _body.x -= 62;
         _body.y -= 83;
         this._defaultFace = ComponentFactory.Instance.creatBitmapData("game.player.gameCharacter");
      }
      
      protected function CreateCryFrace(color:String) : void
      {
         var j:int = 0;
         var i:int = 0;
         var lightTransfrom:ColorTransform = null;
         var lightBitmap:Bitmap = null;
         ObjectUtils.disposeObject(this._tempCryFace);
         this._tempCryFace = null;
         if(Boolean(this._cryBmps))
         {
            for(j = 0; j < this._cryBmps.length; j++)
            {
               ObjectUtils.disposeObject(this._cryBmps[j]);
               this._cryBmps[j] = null;
            }
            this._cryBmps = null;
         }
         ObjectUtils.disposeAllChildren(this._cryFrace);
         this._cryFrace = null;
         this._colors = color.split("|");
         this._cryFrace = new Sprite();
         this._cryBmps = new Vector.<Bitmap>(3);
         this._cryBmps[0] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryFaceAsset");
         this._cryFrace.addChild(this._cryBmps[0]);
         this._cryBmps[1] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryChangeColorAsset");
         this._cryFrace.addChild(this._cryBmps[1]);
         this._cryBmps[1].visible = false;
         if(this._colors.length == this._cryBmps.length)
         {
            for(i = 0; i < this._colors.length; i++)
            {
               if(!StringHelper.isNullOrEmpty(this._colors[i]) && this._colors[i].toString() != "undefined" && this._colors[i].toString() != "null" && Boolean(this._cryBmps[i]))
               {
                  this._cryBmps[i].visible = true;
                  this._cryBmps[i].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[i]);
                  lightTransfrom = BitmapUtils.getHightlightColorTransfrom(this._colors[i]);
                  lightBitmap = new Bitmap(this._cryBmps[i].bitmapData,"auto",true);
                  if(Boolean(lightTransfrom))
                  {
                     lightBitmap.transform.colorTransform = lightTransfrom;
                  }
                  lightBitmap.blendMode = BlendMode.HARDLIGHT;
                  this._cryFrace.addChild(lightBitmap);
               }
               else if(Boolean(this._cryBmps[i]))
               {
                  this._cryBmps[i].transform.colorTransform = new ColorTransform();
               }
            }
         }
         this._tempCryFace = new BitmapData(this._cryFrace.width,this._cryFrace.height,true,0);
         this._tempCryFace.draw(this._cryFrace,null,null,BlendMode.NORMAL);
      }
      
      private function onClick(evt:MouseEvent) : void
      {
         if(evt.altKey)
         {
            this._currentAction = SOUL_SMILE;
         }
         else if(evt.ctrlKey)
         {
            this._currentAction = SOUL_MOVE;
         }
         else
         {
            this._currentAction = SOUL;
         }
      }
      
      public function set isLackHp(value:Boolean) : void
      {
         this._isLackHp = value;
      }
      
      public function get State() : int
      {
         return this._state;
      }
      
      public function set State(value:int) : void
      {
         if(this._state == value)
         {
            return;
         }
         this._state = value;
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(114,95);
         setPicNum(3,13);
         this._rect = new Rectangle(0,0,_characterWidth,_characterHeight);
         this._defaultStartPoint = new Point(_characterWidth / 3,_characterHeight / 3);
      }
      
      public function get weaponX() : int
      {
         return -_characterWidth / 2 - 5;
      }
      
      public function get weaponY() : int
      {
         return -_characterHeight + 12;
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.GAME);
      }
      
      override public function update() : void
      {
         if(this._isPlaying)
         {
            if(this._index < this._currentAction.frames[0].length)
            {
               if(this.isDead)
               {
                  this.drawFrame(this._currentAction.frames[0][this._index++],8,true);
               }
               else if(_info.getShowSuits())
               {
                  this.drawFrame(this._currentAction.frames[0][this._index++],6,true);
               }
               else if(this._currentAction == STAND_LACK_HP)
               {
                  this.drawFrame(LACK_FACE_DOWN[this._index],1,true);
                  this.drawFrame(this._currentAction.frames[this.STATES_ENUM[this._specialType][0] % 2][this._index],2,false);
                  this.drawFrame(LACK_FACE_UP[this._index],4,false);
                  this.drawFrame(SPECIAL_EFFECT_FRAMES[this._index++],5,false);
               }
               else if(this._currentAction == STAND)
               {
                  this.drawFrame(STAND.frames[0][this._index],1,true);
                  this.drawFrame(STAND.frames[0][this._index],3,false);
                  this.drawFrame(STAND.frames[1][this._index++],4,false);
               }
               else
               {
                  this.drawFrame(this._currentAction.frames[0][this._index],1,true);
                  this.drawFrame(this._currentAction.frames[0][this._index],3,false);
                  this.drawFrame(this._currentAction.frames[0][this._index++],4,false);
               }
            }
            else if(this._currentAction.repeat)
            {
               this._index = 0;
               if(this._currentAction == STAND && this._isLackHp)
               {
                  if(Math.random() < 0.33)
                  {
                     this.doAction(STAND_LACK_HP);
                  }
               }
            }
            else if(this._currentAction.stopAtEnd)
            {
               this._isPlaying = false;
            }
            else if(this.isDead)
            {
               this.doAction(SOUL);
            }
            else if(this._currentAction == CRY)
            {
               if(Math.random() < 0.33)
               {
                  this.doAction(STAND_LACK_HP);
               }
               else
               {
                  this.doAction(STAND);
               }
            }
            else if(this._isLackHp && this._currentAction == STAND)
            {
               if(Math.random() < 0.33)
               {
                  this.doAction(STAND_LACK_HP);
               }
            }
            else
            {
               this.doAction(STAND);
            }
         }
      }
      
      private function get STATES_ENUM() : Array
      {
         if(_info.Sex)
         {
            return GameCharacterLoader.MALE_STATES;
         }
         return GameCharacterLoader.FEMALE_STATES;
      }
      
      public function bombed() : void
      {
         if(!info.getShowSuits())
         {
            if(this.black)
            {
               return;
            }
            this.black = true;
            this.blackBm.alpha = 1;
            addChild(this.blackBm);
            setTimeout(this.blackEyes.gotoAndPlay,300,1);
            addChild(this.blackEyes);
            if(contains(_body))
            {
               removeChild(_body);
            }
            this.switchWingVisible(false);
            setTimeout(this.changeToNormal,2000);
         }
      }
      
      override protected function init() : void
      {
         _currentframe = -1;
         this.initSizeAndPics();
         createFrames();
         _body = new Bitmap(new BitmapData(_characterWidth,_characterHeight,true,0),"auto",true);
         addChild(_body);
         mouseEnabled = false;
         mouseChildren = false;
         _loadCompleted = false;
      }
      
      private function drawBlack(bmd:BitmapData) : void
      {
         var rect:Rectangle = new Rectangle(0,0,bmd.width,bmd.height);
         var pixels:Vector.<uint> = bmd.getVector(rect);
         var len:uint = pixels.length;
         for(var i:int = 0; i < len; i++)
         {
            pixels[i] = pixels[i] >> 24 << 24 | 0 << 16 | 0 << 8 | 0;
         }
         bmd.setVector(rect,pixels);
      }
      
      public function changeToNormal() : void
      {
         var t:TweenMax = TweenMax.to(this.blackBm,0.25,{"alpha":0});
         t.addEventListener(TweenEvent.COMPLETE,this.setBlack);
         if(Boolean(this.blackEyes.parent))
         {
            removeChild(this.blackEyes);
         }
         addChild(_body);
         if(!this.isDead)
         {
            this.switchWingVisible(true);
         }
      }
      
      private function get isDead() : Boolean
      {
         return this._currentAction == SOUL || this._currentAction == SOUL_CRY || this._currentAction == SOUL_MOVE || this._currentAction == SOUL_SMILE;
      }
      
      private function setBlack(event:TweenEvent) : void
      {
         TweenMax(event.target).removeEventListener(TweenEvent.COMPLETE,this.setBlack);
         if(Boolean(this.blackBm) && Boolean(this.blackBm.parent))
         {
            removeChild(this.blackBm);
         }
         this.black = false;
      }
      
      private function clearBomded() : void
      {
         this.black = false;
         if(Boolean(this.blackEyes) && Boolean(this.blackEyes.parent))
         {
            removeChild(this.blackEyes);
         }
         if(Boolean(this.blackBm) && Boolean(this.blackBm.parent))
         {
            removeChild(this.blackBm);
         }
         addChild(_body);
      }
      
      public function get standAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return STAND;
         }
         return STAND_LACK_HP;
      }
      
      public function get walkAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return WALK;
         }
         return WALK_LACK_HP;
      }
      
      public function get handClipAction() : PlayerAction
      {
         if(this.State == Player.FULL_HP || _info.getShowSuits())
         {
            return HANDCLIP;
         }
         return HANDCLIP_LACK_HP;
      }
      
      public function randomCryType() : void
      {
         this._cryType = int(Math.random() * 4);
         if(!_info.getShowSuits())
         {
            if(Boolean(this._lackHpFaceBitmapdata))
            {
               this._specialType = int(Math.random() * this._lackHpFaceBitmapdata.length);
            }
            else
            {
               this._specialType = 0;
            }
         }
      }
      
      override public function doAction(actionType:*) : void
      {
         var cStr:String = null;
         if(this._currentAction.canReplace(actionType))
         {
            this._currentAction = actionType;
            this._index = 0;
         }
         if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
         {
            if(Boolean(this._ghostMovie) && Boolean(this._ghostMovie.parent))
            {
               this._ghostMovie.parent.removeChild(this._ghostMovie);
            }
            filters = null;
            if(Boolean(this._ghostShine) && Boolean(this._ghostShine.parent))
            {
               this._ghostShine.parent.removeChild(this._ghostShine);
            }
         }
         else if(this.isDead)
         {
            this.switchWingVisible(false);
            this.clearBomded();
            if(this._ghostShine == null)
            {
               this._ghostShine = ClassUtils.CreatInstance("asset.game.ghostShineAsset") as MovieClip;
            }
            this._ghostShine.x = -28;
            this._ghostShine.y = -50;
            if(_info.getShowSuits())
            {
               if(this._hasSuitSoul)
               {
                  cStr = _info.Sex ? "asset.game.ghostManMovieAsset1" : "asset.game.ghostGirlMovieAsset1";
                  if(this._ghostMovie == null)
                  {
                     this._ghostMovie = ClassUtils.CreatInstance(cStr) as MovieClip;
                  }
                  addChildAt(this._ghostMovie,0);
                  this._ghostMovie.x = -26;
                  this._ghostMovie.y = -50;
               }
               else
               {
                  if(this._ghostMovie == null)
                  {
                     this._ghostMovie = ClassUtils.CreatInstance("asset.game.ghostMovieAsset") as MovieClip;
                  }
                  addChildAt(this._ghostMovie,0);
               }
            }
            else
            {
               cStr = _info.Sex ? "asset.game.ghostManMovieAsset" : "asset.game.ghostGirlMovieAsset";
               if(Boolean(this._ghostMovie) && Boolean(this._ghostMovie.parent))
               {
                  this._ghostMovie.parent.removeChild(this._ghostMovie);
                  this._ghostMovie = null;
               }
               this._ghostMovie = ClassUtils.CreatInstance(cStr) as MovieClip;
               addChild(this._ghostMovie);
               this._ghostMovie.x = -26;
               this._ghostMovie.y = -50;
            }
            filters = [new GlowFilter(7564475,1,6,6,2)];
            addChild(this._ghostShine);
         }
         else
         {
            if(Boolean(this._ghostMovie) && Boolean(this._ghostMovie.parent))
            {
               this._ghostMovie.parent.removeChild(this._ghostMovie);
            }
            filters = null;
            if(Boolean(this._ghostShine) && Boolean(this._ghostShine.parent))
            {
               this._ghostShine.parent.removeChild(this._ghostShine);
            }
         }
         if(this.leftWing && this.leftWing.totalFrames == 2 && this.rightWing && this.rightWing.totalFrames == 2)
         {
            if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
            {
               this.WingState = GAME_WING_WAIT;
               if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
               {
                  this.leftWing["movie"].gotoAndStop(1);
                  this.rightWing["movie"].gotoAndStop(1);
               }
            }
            else if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == STAND || this._currentAction == STAND_LACK_HP)
         {
            this.WingState = GAME_WING_WAIT;
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].gotoAndStop(1);
               this.rightWing["movie"].gotoAndStop(1);
            }
         }
         else if(this._currentAction == WALK || this._currentAction == WALK_LACK_HP)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == CRY)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == HANDCLIP || this._currentAction == HANDCLIP_LACK_HP)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this._currentAction == SHOWGUN || this._currentAction == SHOWTHROWS)
         {
            if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
            {
               this.leftWing["movie"].play();
               this.rightWing["movie"].play();
            }
         }
         else if(this.leftWing && this.leftWing["movie"] && this.rightWing && Boolean(this.rightWing["movie"]))
         {
            this.leftWing["movie"].play();
            this.rightWing["movie"].play();
         }
         this._isPlaying = true;
      }
      
      override public function actionPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      override public function get currentAction() : *
      {
         return this._currentAction;
      }
      
      override public function setDefaultAction(actionType:*) : void
      {
         if(actionType is PlayerAction)
         {
            this._currentAction = actionType;
         }
      }
      
      override protected function setContent() : void
      {
         var t:Array = null;
         var bmd:BitmapData = null;
         var bmd1:BitmapData = null;
         if(_loader != null)
         {
            this.scaleX = -1;
            if(!this.isDead)
            {
               if(Boolean(this._ghostMovie))
               {
                  ObjectUtils.disposeObject(this._ghostMovie);
               }
               this._ghostMovie = null;
            }
            t = _loader.getContent();
            if(_info.getShowSuits())
            {
               if(Boolean(this._normalSuit) && this._normalSuit != t[6])
               {
                  this._normalSuit.dispose();
               }
               this._normalSuit = t[6];
               if(Boolean(this._lackHpSuit) && this._lackHpSuit != t[7])
               {
                  this._lackHpSuit.dispose();
               }
               this._lackHpSuit = t[7];
               this._hasSuitSoul = this.checkHasSuitsSoul(this._lackHpSuit);
               if(Boolean(this._ghostMovie))
               {
                  ObjectUtils.disposeObject(this._ghostMovie);
                  this._ghostMovie = null;
               }
            }
            else
            {
               if(Boolean(this._spBitmapData) && this._spBitmapData != t[1])
               {
                  for each(bmd in this._spBitmapData)
                  {
                     bmd.dispose();
                  }
               }
               this._spBitmapData = t[1];
               if(Boolean(this._faceupBitmapData) && this._faceupBitmapData != t[2])
               {
                  this._faceupBitmapData.dispose();
               }
               this._faceupBitmapData = t[2];
               if(Boolean(this._faceBitmapData) && this._faceBitmapData != t[3])
               {
                  this._faceBitmapData.dispose();
               }
               this._faceBitmapData = t[3];
               if(Boolean(this._lackHpFaceBitmapdata) && this._lackHpFaceBitmapdata != t[4])
               {
                  for each(bmd1 in this._lackHpFaceBitmapdata)
                  {
                     bmd1.dispose();
                  }
               }
               this._lackHpFaceBitmapdata = t[4];
               if(Boolean(this._faceDownBitmapdata) && this._faceDownBitmapdata != t[5])
               {
                  this._faceDownBitmapdata.dispose();
               }
               this._faceDownBitmapdata = t[5];
            }
            if(getQualifiedClassName(this._wing) != getQualifiedClassName(t[0]))
            {
               this.removeWing();
               this._wing = t[0];
               this.WingState = GAME_WING_WAIT;
            }
            this.drawBomd();
            this.drawSoul();
            this.CreateCryFrace(_info.Colors.split(",")[5]);
            this._isPlaying = true;
            this.update();
         }
      }
      
      private function checkHasSuitsSoul(suit:BitmapData) : Boolean
      {
         var n:int = 0;
         if(!suit)
         {
            return false;
         }
         var pos:Point = new Point(_characterWidth * 11 - _characterWidth / 2,_characterHeight * 3 - _characterHeight / 2);
         for(var m:int = pos.x - 5; m < pos.x + 5; m++)
         {
            for(n = pos.y - 5; n < pos.y + 5; n++)
            {
               if(suit.getPixel(m,n) != 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function removeWing() : void
      {
         if(this._wing == null)
         {
            return;
         }
         if(Boolean(this.rightWing) && Boolean(this.rightWing.parent))
         {
            this.rightWing.parent.removeChild(this.rightWing);
         }
         if(Boolean(this.leftWing) && Boolean(this.leftWing.parent))
         {
            this.leftWing.parent.removeChild(this.leftWing);
         }
         this._wing = null;
      }
      
      public function switchWingVisible(v:Boolean) : void
      {
         if(Boolean(this.leftWing) && Boolean(this.rightWing))
         {
            this.rightWing.visible = this.leftWing.visible = v;
         }
      }
      
      public function setWingPos(xPos:Number, yPos:Number) : void
      {
         if(Boolean(this.rightWing) && Boolean(this.leftWing))
         {
            this.rightWing.x = this.leftWing.x = xPos;
            this.rightWing.y = this.leftWing.y = yPos;
         }
      }
      
      public function setWingScale(xScale:Number, yScale:Number) : void
      {
         if(Boolean(this.rightWing) && Boolean(this.leftWing))
         {
            this.leftWing.scaleX = this.rightWing.scaleX = xScale;
            this.leftWing.scaleY = this.rightWing.scaleY = yScale;
         }
      }
      
      public function set WingState($wingState:int) : void
      {
         this._wingState = $wingState;
         if(this.leftWing && this.leftWing.totalFrames == 2 && this.rightWing && this.rightWing.totalFrames == 2)
         {
            if(this._wingState == GAME_WING_SHOOT)
            {
               this._wingState = 2;
            }
            else
            {
               this._wingState = 1;
            }
         }
         if(Boolean(this.leftWing) && Boolean(this.rightWing))
         {
            this.leftWing.gotoAndStop(this._wingState);
            this.rightWing.gotoAndStop(this._wingState);
         }
      }
      
      public function get WingState() : int
      {
         return this._wingState;
      }
      
      public function get wing() : MovieClip
      {
         return this._wing;
      }
      
      public function get leftWing() : MovieClip
      {
         if(Boolean(this._wing))
         {
            return this._wing["leftWing"];
         }
         return null;
      }
      
      public function get rightWing() : MovieClip
      {
         if(Boolean(this._wing))
         {
            return this._wing["rightWing"];
         }
         return null;
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         this.removeWing();
         ObjectUtils.disposeObject(this._ghostMovie);
         this._ghostMovie = null;
         ObjectUtils.disposeObject(this._ghostShine);
         this._ghostShine = null;
         ObjectUtils.disposeObject(this._spBitmapData);
         this._spBitmapData = null;
         ObjectUtils.disposeObject(this._faceupBitmapData);
         this._faceupBitmapData = null;
         ObjectUtils.disposeObject(this._faceBitmapData);
         this._faceBitmapData = null;
         ObjectUtils.disposeObject(this._lackHpFaceBitmapdata);
         this._lackHpFaceBitmapdata = null;
         ObjectUtils.disposeObject(this._faceDownBitmapdata);
         this._faceDownBitmapdata = null;
         ObjectUtils.disposeObject(this._normalSuit);
         this._normalSuit = null;
         ObjectUtils.disposeObject(this._lackHpSuit);
         this._lackHpSuit = null;
         ObjectUtils.disposeObject(this._soulFace);
         this._soulFace = null;
         ObjectUtils.disposeObject(this._tempCryFace);
         this._tempCryFace = null;
         ObjectUtils.disposeObject(this._defaultFace);
         this._defaultFace = null;
         if(Boolean(this._cryBmps))
         {
            for(i = 0; i < this._cryBmps.length; i++)
            {
               ObjectUtils.disposeObject(this._cryBmps[i]);
               this._cryBmps[i] = null;
            }
         }
         ObjectUtils.disposeAllChildren(this._cryFrace);
         this._cryFrace = null;
         ObjectUtils.disposeObject(this.blackBm);
         this.blackBm = null;
         ObjectUtils.disposeObject(this.blackEyes);
         this.blackEyes = null;
         super.dispose();
         this._frameStartPoint = null;
         this._cryBmps = null;
      }
      
      private function drawSoul() : void
      {
         var i:int = 0;
         var frame:int = 0;
         var tempMatrix:Matrix = null;
         var tempBitmapData:BitmapData = null;
         var j:int = 0;
         var tempRect:Rectangle = null;
         var n:Number = NaN;
         var tempPoint:Point = new Point(0,0);
         if(_info.getShowSuits())
         {
            this._soulFace = new BitmapData(this._normalSuit.width,this._normalSuit.height,true,0);
            for(i = 0; i < 4; i++)
            {
               tempPoint.x = _characterWidth * i;
               this._soulFace.copyPixels(this._lackHpSuit,_frames[36],tempPoint,null,null,true);
            }
         }
         else
         {
            this._soulFace = new BitmapData(this._faceBitmapData.width,this._faceBitmapData.height,true,0);
            frame = 0;
            tempMatrix = new Matrix();
            tempBitmapData = new BitmapData(this._faceBitmapData.width,this._faceBitmapData.height,true,0);
            for(j = 0; j < 4; j++)
            {
               tempPoint.x = _characterWidth * j;
               switch(j)
               {
                  case 0:
                     frame = 0;
                     break;
                  case 1:
                     frame = 10;
                     break;
                  case 2:
                     frame = 14;
                     break;
                  case 3:
                     frame = 17;
                     break;
               }
               tempPoint.x = _characterWidth * j;
               this._soulFace.copyPixels(this._faceBitmapData,_frames[frame],tempPoint,null,null,true);
            }
            tempMatrix.scale(0.75,0.75);
            tempPoint.x = tempPoint.y = 0;
            tempBitmapData.draw(this._soulFace,tempMatrix,null,null,null,true);
            tempRect = new Rectangle(0,0,_characterWidth,_characterHeight);
            this._soulFace.fillRect(this._soulFace.rect,0);
            for(n = 0; n < 4; n++)
            {
               tempRect.x = n * _characterWidth * 0.75;
               tempPoint.x = _characterWidth * n + 7;
               tempPoint.y = 5;
               this._soulFace.copyPixels(this._faceDownBitmapdata,_frames[36],new Point(n * _characterWidth,0),null,null,true);
               this._soulFace.copyPixels(tempBitmapData,tempRect,tempPoint,null,null,true);
               this._soulFace.copyPixels(this._faceupBitmapData,_frames[36],new Point(n * _characterWidth,0),null,null,true);
            }
            tempPoint.x = tempPoint.y = 0;
            this._soulFace.applyFilter(this._soulFace,this._soulFace.rect,tempPoint,grayFilter);
            tempBitmapData.dispose();
         }
      }
      
      private function drawBomd() : void
      {
         var blackBmd:BitmapData = new BitmapData(_body.width,_body.height,true,0);
         blackBmd.fillRect(new Rectangle(0,0,blackBmd.height,blackBmd.height),0);
         if(_info.getShowSuits())
         {
            blackBmd.copyPixels(this._normalSuit,_frames[1],this._frameStartPoint,null,null,true);
         }
         else
         {
            blackBmd.copyPixels(this._faceDownBitmapdata,_frames[1],this._frameStartPoint,null,null,true);
            blackBmd.copyPixels(this._faceBitmapData,_frames[1],this._frameStartPoint,null,null,true);
            blackBmd.copyPixels(this._faceupBitmapData,_frames[1],this._frameStartPoint,null,null,true);
         }
         this.drawBlack(blackBmd);
         this.blackBm = new Bitmap(blackBmd);
         this.blackBm.x = _body.x;
         this.blackBm.y = _body.y;
         if(this.blackEyes == null)
         {
            this.blackEyes = ClassUtils.CreatInstance("asset.game.bombedAsset1") as MovieClip;
            this.blackEyes.x = 8;
            this.blackEyes.y = -10;
         }
      }
      
      override public function drawFrame(frame:int, type:int = 0, clearOld:Boolean = true) : void
      {
         var bmd:BitmapData = null;
         if(type == 1)
         {
            bmd = this._faceDownBitmapdata != null ? this._faceDownBitmapdata : this._defaultFace;
         }
         else if(type == 2)
         {
            if(Boolean(this._lackHpFaceBitmapdata))
            {
               bmd = this._lackHpFaceBitmapdata[this._specialType];
            }
            else
            {
               bmd = this._defaultFace;
            }
         }
         else if(type == 3)
         {
            if(this._currentAction == CRY && this._cryType > 0)
            {
               bmd = this._tempCryFace != null ? this._tempCryFace : this._defaultFace;
            }
            else
            {
               bmd = this._faceBitmapData != null ? this._faceBitmapData : this._defaultFace;
            }
         }
         else if(type == 4)
         {
            bmd = this._faceupBitmapData != null ? this._faceupBitmapData : this._defaultFace;
         }
         else if(type == 5)
         {
            if(Boolean(this._spBitmapData))
            {
               bmd = this._spBitmapData[this._specialType];
            }
            else
            {
               bmd = this._defaultFace;
            }
         }
         else if(type == 6)
         {
            bmd = this._normalSuit != null ? this._normalSuit : this._defaultFace;
         }
         else if(type == 7)
         {
            bmd = this._lackHpSuit != null ? this._lackHpSuit : this._defaultFace;
         }
         else if(type == 8)
         {
            bmd = this._soulFace != null ? this._soulFace : this._defaultFace;
         }
         if(this._currentAction == SOUL)
         {
            if(this.closeEys < 4)
            {
               frame = 1;
            }
            else if(Math.random() < 0.008)
            {
               this.closeEys = 0;
            }
            ++this.closeEys;
         }
         if(bmd != this._defaultFace)
         {
            if(frame < 0 || frame >= _frames.length)
            {
               frame = 0;
            }
            _currentframe = frame;
            if(clearOld)
            {
               _body.bitmapData.fillRect(this._rect,0);
            }
            if(this._currentAction == CRY && (type == 2 || type == 3))
            {
               _body.bitmapData.copyPixels(bmd,_frames[frame - this._cryTypes[this._cryType]],this._frameStartPoint,null,null,true);
            }
            else
            {
               _body.bitmapData.copyPixels(bmd,_frames[frame],this._frameStartPoint,null,null,true);
            }
         }
         else
         {
            if(frame < 0 || frame >= _frames.length)
            {
               frame = 0;
            }
            _currentframe = frame;
            _body.bitmapData.copyPixels(bmd,_frames[frame],this._defaultStartPoint,null,null,true);
            this.scaleX = this.parent.scaleX;
         }
      }
   }
}

