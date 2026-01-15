package church.view.churchScene
{
   import baglocked.BaglockedManager;
   import church.model.ChurchRoomModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class MoonSceneMap extends SceneMap
   {
      
      public static const GAME_WIDTH:int = 1000;
      
      public static const GAME_HEIGHT:int = 600;
      
      public static const YF_OFSET:int = 230;
      
      public static const FIRE_TEMPLETEID:int = 22001;
      
      private var _model:ChurchRoomModel;
      
      private var saluteContainer:Sprite;
      
      private var saluteMask:MovieClip;
      
      private var _isSaluteFiring:Boolean;
      
      private var saluteQueue:Array;
      
      private var timer:Timer;
      
      public function MoonSceneMap(model:ChurchRoomModel, scene:SceneScene, data:DictionaryData, bg:Sprite, mesh:Sprite, acticle:Sprite = null, sky:Sprite = null)
      {
         this._model = model;
         super(this._model,scene,data,bg,mesh,acticle,sky);
         SoundManager.instance.playMusic("3003");
         this.initSaulte();
      }
      
      private function get isSaluteFiring() : Boolean
      {
         return this._isSaluteFiring;
      }
      
      private function set isSaluteFiring(value:Boolean) : void
      {
         if(this._isSaluteFiring == value)
         {
            return;
         }
         this._isSaluteFiring = value;
         if(this._isSaluteFiring)
         {
            this.playSaluteSound();
         }
         else
         {
            this.stopSaluteSound();
         }
      }
      
      override public function setCenter(event:SceneCharacterEvent = null) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         if(Boolean(reference))
         {
            xf = -(reference.x - GAME_WIDTH / 2);
            yf = -(reference.y - GAME_HEIGHT / 2) + YF_OFSET;
         }
         else
         {
            xf = -(sceneMapVO.defaultPos.x - GAME_WIDTH / 2);
            yf = -(sceneMapVO.defaultPos.y - GAME_HEIGHT / 2) + YF_OFSET;
         }
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < GAME_WIDTH - sceneMapVO.mapW)
         {
            xf = GAME_WIDTH - sceneMapVO.mapW;
         }
         if(yf > 0)
         {
            yf = 0;
         }
         if(yf < GAME_HEIGHT - sceneMapVO.mapH)
         {
            yf = GAME_HEIGHT - sceneMapVO.mapH;
         }
         x = xf;
         y = yf;
      }
      
      private function initSaulte() : void
      {
         var index:int = this.getChildIndex(articleLayer);
         this.saluteContainer = new Sprite();
         addChildAt(this.saluteContainer,index);
         this.saluteMask = new (ClassUtils.uiSourceDomain.getDefinition("asset.church.room.FireMaskOfMoonSceneAsset") as Class)() as MovieClip;
         addChild(this.saluteMask);
         this.saluteContainer.mask = this.saluteMask;
         this.saluteQueue = [];
         nameVisible();
         chatBallVisible();
         fireVisible();
      }
      
      override public function setSalute(id:int) : void
      {
         var saluteFire:MovieClip = null;
         var saluteFirePos:Point = null;
         if(this.isSaluteFiring && id == PlayerManager.Instance.Self.ID)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.MoonSceneMap.lipao"));
            return;
         }
         if(id == PlayerManager.Instance.Self.ID)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            SocketManager.Instance.out.sendGunSalute(id,FIRE_TEMPLETEID);
         }
         var SaluteClass:Class = ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.Salute") as Class;
         saluteFire = new SaluteClass();
         saluteFirePos = ComponentFactory.Instance.creatCustomObject("church.MoonSceneMap.saluteFirePos");
         saluteFire.x = saluteFirePos.x;
         saluteFire.y = saluteFirePos.y;
         if(this.isSaluteFiring)
         {
            this.saluteQueue.push(saluteFire);
         }
         else
         {
            this.isSaluteFiring = true;
            saluteFire.addEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
            saluteFire.gotoAndPlay(1);
            this.saluteContainer.addChild(saluteFire);
         }
      }
      
      private function saluteFireFrameHandler(e:Event) : void
      {
         var nextMovie:MovieClip = null;
         var movie:MovieClip = e.currentTarget as MovieClip;
         if(movie.currentFrame == movie.totalFrames)
         {
            this.isSaluteFiring = false;
            this.clearnSaluteFire();
            nextMovie = this.saluteQueue.shift();
            if(Boolean(nextMovie))
            {
               this.isSaluteFiring = true;
               nextMovie.addEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
               nextMovie.gotoAndPlay(1);
               this.saluteContainer.addChild(nextMovie);
            }
         }
      }
      
      private function clearnSaluteFire() : void
      {
         while(this.saluteContainer.numChildren > 0)
         {
            this.saluteContainer.getChildAt(0).removeEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
            this.saluteContainer.removeChildAt(0);
         }
      }
      
      private function playSaluteSound() : void
      {
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this.timer.start();
      }
      
      private function __timer(event:TimerEvent) : void
      {
         var random:uint = 0;
         var playSound:Boolean = false;
         random = Math.round(Math.random() * 15);
         if(random < 6)
         {
            playSound = !(Math.round(Math.random() * 9) % 3) ? true : false;
            if(playSound)
            {
               SoundManager.instance.play("118");
            }
         }
      }
      
      private function stopSaluteSound() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this.timer = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         }
         this.timer = null;
         if(Boolean(this.saluteMask) && Boolean(this.saluteMask.parent))
         {
            this.saluteMask.parent.removeChild(this.saluteMask);
         }
         this.saluteMask = null;
         this.clearnSaluteFire();
         this.stopSaluteSound();
         if(Boolean(this.saluteContainer) && Boolean(this.saluteContainer.parent))
         {
            this.saluteContainer.parent.removeChild(this.saluteContainer);
         }
         this.saluteContainer = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

