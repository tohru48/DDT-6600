package ddt.manager
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.Experience;
   import ddt.data.player.PlayerInfo;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class GradeExaltClewManager
   {
      
      private static var instance:GradeExaltClewManager;
      
      public static const LIGHT:int = 1;
      
      public static const BLACK:int = 2;
      
      private var _asset:MovieClip;
      
      private var _increBlood:String;
      
      private var _grade:int;
      
      private var _character:RoomCharacter;
      
      private var _isSteup:Boolean = false;
      
      private var _info:PlayerInfo;
      
      private var _bloodMovie:Sprite;
      
      public function GradeExaltClewManager()
      {
         super();
      }
      
      public static function getInstance() : GradeExaltClewManager
      {
         if(instance == null)
         {
            instance = new GradeExaltClewManager();
         }
         return instance;
      }
      
      public function setup() : void
      {
         if(this._isSteup)
         {
            return;
         }
         this.addEvent();
         this._isSteup = true;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function __GradeExalt(e:PlayerPropertyEvent) : void
      {
         if(e.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade && PlayerManager.Instance.Self.Grade > 28)
         {
            DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.UP_GRADE));
            if(e.target.Grade == this._grade)
            {
               return;
            }
            this._grade = e.target.Grade;
            if(StateManager.currentStateType != StateType.FIGHTING)
            {
               this.show(BLACK);
            }
         }
      }
      
      public function show(type:int) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_MOVIE);
         this.hide();
         this._asset = ComponentFactory.Instance.creat("asset.core.upgradeClewMcOne");
         this._asset.addEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         this._asset.gotoAndPlay(1);
         var grade:int = PlayerManager.Instance.Self.Grade;
         this._increBlood = grade == 1 ? "100" : (Experience.getBasicHP(grade) - Experience.getBasicHP(grade - 1)).toString();
         this._bloodMovie = this.creatNumberMovie();
         PositionUtils.setPos(this._bloodMovie,"core.upgradeMoive.pos");
         this._asset.leftMC.addChild(this._bloodMovie);
         this._character = CharactoryFactory.createCharacter(PlayerManager.Instance.Self,"room") as RoomCharacter;
         this._character.showGun = false;
         this._character.show(false,-1);
         this._character.scaleX = this._character.scaleY = 1.5;
         this._asset.character.addChild(this._character);
         SoundManager.instance.play("063");
         this._asset.buttonMode = this._asset.mouseChildren = this._asset.mouseEnabled = false;
         if(type == LIGHT)
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
         var chatMsg:ChatData = new ChatData();
         chatMsg.msg = LanguageMgr.GetTranslation("tank.manager.GradeExaltClewManager");
         chatMsg.channel = ChatInputView.SYS_NOTICE;
         ChatManager.Instance.chat(chatMsg);
      }
      
      private function creatNumberMovie() : Sprite
      {
         var sprite:Sprite = null;
         var number:Bitmap = null;
         sprite = new Sprite();
         for(var i:int = 0; i < this._increBlood.length; i++)
         {
            number = ComponentFactory.Instance.creat("asset.core.upgradeNum_" + this._increBlood.charAt(i));
            number.x += i * 20;
            sprite.addChild(number);
         }
         return sprite;
      }
      
      private function end() : void
      {
         this._asset.gotoAndStop(this._asset.totalFrames);
         this.hide();
      }
      
      private function __cartoonFrameHandler(event:Event) : void
      {
         if(this._asset == null)
         {
            return;
         }
         if(this._asset.currentFrame == this._asset.totalFrames)
         {
            this.end();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_MOVIE);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MOVIE,1000);
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._asset))
         {
            this._asset.removeEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         }
         if(Boolean(this._asset) && Boolean(this._asset.parent))
         {
            this._asset.parent.removeChild(this._asset);
         }
         if(Boolean(this._increBlood))
         {
            ObjectUtils.disposeObject(this._increBlood);
         }
         this._increBlood = null;
         this._asset = null;
         if(Boolean(this._character))
         {
            ObjectUtils.disposeObject(this._character);
         }
         this._character = null;
      }
   }
}

