package church.view.churchScene
{
   import church.model.ChurchRoomModel;
   import church.player.ChurchPlayer;
   import church.view.churchFire.ChurchFireEffectPlayer;
   import church.vo.FatherBallConfigVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.BitmapUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class WeddingSceneMap extends SceneMap
   {
      
      public static const MOVE_SPEED:Number = 0.055;
      
      public static const MOVE_SPEEDII:Number = 0.15;
      
      private var _model:ChurchRoomModel;
      
      private var father_read:MovieClip;
      
      private var father_com:MovieClip;
      
      private var bride:ChurchPlayer;
      
      private var groom:ChurchPlayer;
      
      private var guestPos:Array;
      
      private var _fatherPaopaoBg:ScaleFrameImage;
      
      private var _fatherPaopao:ScaleFrameImage;
      
      private var _fatherPaopaoConfig:Array = [];
      
      private var frame:uint = 1;
      
      private var _brideName:FilterFrameText;
      
      private var _groomName:FilterFrameText;
      
      private var kissMovie:MovieClip;
      
      private var fireTimer:Timer;
      
      public function WeddingSceneMap(model:ChurchRoomModel, scene:SceneScene, data:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite = null, sky:Sprite = null)
      {
         this._model = model;
         super(this._model,scene,data,bg,mesh,acticle,sky);
         SoundManager.instance.playMusic("3002");
         this.initFather();
      }
      
      private function initFather() : void
      {
         if(bgLayer != null)
         {
            this.father_read = bgLayer.getChildByName("father_read") as MovieClip;
            this.father_com = bgLayer.getChildByName("father_com") as MovieClip;
            if(Boolean(this.father_read))
            {
               this.father_read.visible = false;
            }
         }
      }
      
      public function fireImdily(pt:Point, type:uint, playSound:Boolean = false) : void
      {
         var fire:ChurchFireEffectPlayer = null;
         if(type > 1)
         {
            return;
         }
         var fireID:int = int(this._model.fireTemplateIDList[type]);
         fire = new ChurchFireEffectPlayer(fireID);
         fire.x = pt.x;
         fire.y = pt.y;
         addChild(fire);
         fire.firePlayer(playSound);
      }
      
      public function playWeddingMovie() : void
      {
         var bridePos:Point = null;
         var groomPos:Point = null;
         this.bride = _characters[ChurchManager.instance.currentRoom.brideID] as ChurchPlayer;
         this.groom = _characters[ChurchManager.instance.currentRoom.groomID] as ChurchPlayer;
         this.bride.moveSpeed = MOVE_SPEED;
         this.groom.moveSpeed = MOVE_SPEED;
         bridePos = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePos");
         this.bride.x = bridePos.x;
         this.bride.y = bridePos.y;
         groomPos = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.groomPos");
         this.groom.x = groomPos.x;
         this.groom.y = groomPos.y;
         this.rangeGuest();
         ajustScreen(this.bride);
         this.bride.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.groom.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.bride.sceneCharacterActionType = "naturalWalkBack";
         this.bride.playerVO.walkPath = [new Point(1104,660)];
         this.bride.playerWalk(this.bride.playerVO.walkPath);
         this.groom.sceneCharacterActionType = "naturalWalkBack";
         this.groom.playerVO.walkPath = [new Point(1003,651)];
         this.groom.playerWalk(this.groom.playerVO.walkPath);
      }
      
      public function stopWeddingMovie() : void
      {
         var bridePosII:Point = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePosII");
         this.bride.x = bridePosII.x;
         this.bride.y = bridePosII.y;
         this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.groom.moveSpeed = MOVE_SPEEDII;
         this.groom.moveSpeed = MOVE_SPEEDII;
         ajustScreen(_selfPlayer);
         setCenter(null);
         if(Boolean(this.father_read))
         {
            this.father_read.visible = false;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = true;
         }
         this.hideDialogue();
         this.stopKissMovie();
         this.stopFireMovie();
         this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
      }
      
      private function __arrive(event:SceneCharacterEvent) : void
      {
         this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         ajustScreen(null);
         this.bride.sceneCharacterActionType = "naturalStandFront";
         this.groom.sceneCharacterActionType = "naturalStandFront";
         this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.groom.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.playDialogue();
      }
      
      public function rangeGuest() : void
      {
         var j:uint = 0;
         var i:uint = 0;
         var player:ChurchPlayer = null;
         this.getGuestPos();
         var playerArr:Array = _characters.list;
         for(playerArr.sortOn("ID",Array.NUMERIC); i < _characters.length; )
         {
            player = playerArr[i] as ChurchPlayer;
            if(!ChurchManager.instance.isAdmin(player.playerVO.playerInfo))
            {
               if(Boolean(j % 2))
               {
                  player.x = (this.guestPos[0][0] as Point).x;
                  player.y = (this.guestPos[0][0] as Point).y;
                  (this.guestPos[0] as Array).shift();
                  player.sceneCharacterActionType = "naturalStandBack";
                  player.sceneCharacterDirection = SceneCharacterDirection.RT;
               }
               else
               {
                  player.x = (this.guestPos[1][0] as Point).x;
                  player.y = (this.guestPos[1][0] as Point).y;
                  (this.guestPos[1] as Array).shift();
                  player.sceneCharacterActionType = "naturalStandBack";
                  player.sceneCharacterDirection = SceneCharacterDirection.LT;
                  if((this.guestPos[1] as Array).length == 0)
                  {
                     this.guestPos.shift();
                     this.guestPos.shift();
                  }
               }
               j++;
            }
            i++;
         }
      }
      
      private function getGuestPos() : void
      {
         var count:uint = 0;
         this.guestPos = [];
         var lineClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.church.room.GuestLineAsset") as Class;
         var lineAsset:MovieClip = new lineClass() as MovieClip;
         addChild(lineAsset);
         for(var i:uint = 1; i <= 8; i++)
         {
            if(i == 1 || i == 2)
            {
               count = 19;
               this.guestPos.push(this.spliceLine(lineAsset["line" + i],count,false,false));
            }
            else if(i == 3 || i == 5 || i == 7)
            {
               count = 9;
               this.guestPos.push(this.spliceLine(lineAsset["line" + i],count,false,true));
            }
            else
            {
               count = 9;
               this.guestPos.push(this.spliceLine(lineAsset["line" + i],count,true,false));
            }
         }
         removeChild(lineAsset);
      }
      
      private function spliceLine(line:DisplayObject, count:uint, right:Boolean, top:Boolean) : Array
      {
         var i:uint = 0;
         var point:Point = null;
         var stepX:Number = line.width / count;
         var stepY:Number = line.height / count;
         var dirX:int = right ? 1 : -1;
         var dirY:int = top ? -1 : 1;
         for(var arr:Array = []; i <= count; )
         {
            point = new Point();
            point.x = line.x + stepX * i * dirX;
            point.y = line.y + stepY * i * dirY;
            arr.push(point);
            i++;
         }
         return arr;
      }
      
      private function playDialogue() : void
      {
         var _fatherPaopaoConfigVO:FatherBallConfigVO = null;
         this.frame = 1;
         if(Boolean(this.father_read))
         {
            this.father_read.visible = true;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = false;
         }
         for(var i:int = 0; i < 23; i++)
         {
            _fatherPaopaoConfigVO = ComponentFactory.Instance.creatCustomObject("church.room.FatherBallConfigVO" + (i + 1));
            this._fatherPaopaoConfig.push(_fatherPaopaoConfigVO);
         }
         this._fatherPaopaoBg = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopaoBg");
         this._fatherPaopaoBg.setFrame(this.frame);
         addChild(this._fatherPaopaoBg);
         this._fatherPaopao = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopao");
         this._fatherPaopao.setFrame(this.frame);
         addChild(this._fatherPaopao);
         this.playerFatherPaopaoFrame();
      }
      
      private function playerFatherPaopaoFrame() : void
      {
         var maskShape:Shape = null;
         ObjectUtils.disposeObject(this._brideName);
         this._brideName = null;
         ObjectUtils.disposeObject(this._groomName);
         this._groomName = null;
         if(!this._fatherPaopaoBg || !this._fatherPaopao)
         {
            return;
         }
         if(this._fatherPaopao.getFrame >= this._fatherPaopao.totalFrames)
         {
            this.hideDialogue();
            if(Boolean(this.bride) && Boolean(this.groom) && Boolean(_selfPlayer))
            {
               this.readyForKiss();
            }
            return;
         }
         this._fatherPaopaoBg.setFrame(this.frame);
         this._fatherPaopao.setFrame(this.frame);
         switch(this.frame)
         {
            case 3:
               this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName");
               this._brideName.text = ChurchManager.instance.currentRoom.brideName;
               addChild(this._brideName);
               break;
            case 7:
               this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName");
               this._groomName.text = ChurchManager.instance.currentRoom.groomName;
               addChild(this._groomName);
               break;
            case 22:
               this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName2");
               this._groomName.text = ChurchManager.instance.currentRoom.groomName;
               addChild(this._groomName);
               this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName2");
               this._brideName.text = ChurchManager.instance.currentRoom.brideName;
               addChild(this._brideName);
         }
         var fatherPaopaoConfigVO:FatherBallConfigVO = this._fatherPaopaoConfig[this.frame - 1] as FatherBallConfigVO;
         if(fatherPaopaoConfigVO.isMask == "true")
         {
            maskShape = new Shape();
            maskShape.x = this._fatherPaopao.x + this._fatherPaopao.getFrameImage(this.frame - 1).x;
            maskShape.y = this._fatherPaopao.y + this._fatherPaopao.getFrameImage(this.frame - 1).y;
         }
         ++this.frame;
         BitmapUtils.maskMovie(this._fatherPaopao,maskShape,fatherPaopaoConfigVO.isMask,fatherPaopaoConfigVO.rowNumber,fatherPaopaoConfigVO.rowWitdh,fatherPaopaoConfigVO.rowHeight,fatherPaopaoConfigVO.frameStep,fatherPaopaoConfigVO.sleepSecond,this.playerFatherPaopaoFrame);
      }
      
      private function readyForKiss() : void
      {
         this.bride.moveSpeed = 0.025;
         this.groom.moveSpeed = 0.025;
         this.groom.sceneCharacterActionType = "naturalWalkFront";
         this.groom.playerVO.walkPath = [new Point(1026,666)];
         this.groom.playerWalk(this.groom.playerVO.walkPath);
         this.bride.sceneCharacterActionType = "naturalWalkBack";
         this.bride.playerVO.walkPath = [new Point(1060,707),new Point(1044,694)];
         this.bride.playerWalk(this.bride.playerVO.walkPath);
         this.playKissMovie();
         this.playFireMovie();
         this.ajustPosition();
      }
      
      private function ajustPosition() : void
      {
         SocketManager.Instance.out.sendPosition(_selfPlayer.x,_selfPlayer.y);
      }
      
      private function hideDialogue() : void
      {
         ObjectUtils.disposeObject(this._fatherPaopaoBg);
         this._fatherPaopaoBg = null;
         ObjectUtils.disposeObject(this._fatherPaopao);
         this._fatherPaopao = null;
         if(Boolean(this.father_read))
         {
            this.father_read.visible = false;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = true;
         }
      }
      
      private function playKissMovie() : void
      {
         var kissClass:Class = ClassUtils.uiSourceDomain.getDefinition("tank.church.KissMovie") as Class;
         this.kissMovie = new kissClass() as MovieClip;
         this.kissMovie.x = 1040;
         this.kissMovie.y = 610;
         addChild(this.kissMovie);
      }
      
      private function stopKissMovie() : void
      {
         if(Boolean(this.kissMovie))
         {
            removeChild(this.kissMovie);
         }
         this.kissMovie = null;
      }
      
      public function playFireMovie() : void
      {
         this.fireTimer = new Timer(100);
         this.fireTimer.addEventListener(TimerEvent.TIMER,this.__fireTimer);
         this.fireTimer.start();
      }
      
      private function __fireTimer(event:TimerEvent) : void
      {
         var pos:Point = null;
         var type:uint = 0;
         var playSound:Boolean = false;
         pos = this.getFirePosition();
         type = Math.round(Math.random() * 3);
         playSound = !(Math.round(Math.random() * 9) % 3) ? true : false;
         this.fireImdily(pos,type,playSound);
      }
      
      private function getFirePosition() : Point
      {
         var point:Point = null;
         var tempX:Number = Math.round(Math.random() * (1000 - 100)) + 50;
         var tempY:Number = Math.round(Math.random() * (600 - 100)) + 50;
         return this.globalToLocal(new Point(tempX,tempY));
      }
      
      private function __fireTimerComplete(event:TimerEvent) : void
      {
         if(!this.fireTimer)
         {
            return;
         }
         this.fireTimer.stop();
         this.fireTimer.removeEventListener(TimerEvent.TIMER,this.__fireTimer);
         this.fireTimer = null;
      }
      
      private function stopFireMovie() : void
      {
         this.__fireTimerComplete(null);
      }
      
      override protected function __click(event:MouseEvent) : void
      {
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            return;
         }
         super.__click(event);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.bride))
         {
            this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         }
         if(Boolean(this.groom))
         {
            this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         }
         if(Boolean(this.fireTimer))
         {
            this.fireTimer.stop();
            this.fireTimer.removeEventListener(TimerEvent.TIMER,this.__fireTimer);
         }
         this.fireTimer = null;
         this.stopKissMovie();
         this.stopFireMovie();
         ObjectUtils.disposeObject(this._fatherPaopaoBg);
         this._fatherPaopaoBg = null;
         ObjectUtils.disposeObject(this._fatherPaopao);
         this._fatherPaopao = null;
         if(Boolean(this.father_read) && Boolean(this.father_read.parent))
         {
            this.father_read.parent.removeChild(this.father_read);
         }
         this.father_read = null;
         if(Boolean(this.father_com) && Boolean(this.father_com.parent))
         {
            this.father_com.parent.removeChild(this.father_com);
         }
         this.father_com = null;
         this.bride = null;
         this.groom = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

