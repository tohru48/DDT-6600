package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.LivingEvent;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import game.model.Living;
   import game.model.SimpleBoss;
   import room.RoomManager;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossCutHpMC;
   
   public class BossThumbnail extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _living:Living;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BossBloodItem;
      
      private var _name:FilterFrameText;
      
      private var lightingFilter:BitmapFilter;
      
      public function BossThumbnail(living:Living)
      {
         super();
         this._living = living;
         this.init();
         this.initEvents();
      }
      
      public function init() : void
      {
         var p:Point = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossThumbnailBgAsset");
         addChild(this._bg);
         this._headFigure = new HeadFigure(62,62,this._living);
         addChild(this._headFigure);
         this._headFigure.y = 11;
         this._headFigure.x = 4;
         if(RoomManager.Instance.current.type == 14)
         {
            this._blood = new BossBloodItem(WorldBossManager.Instance.bossInfo.total_Blood);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA,this.__showCutHp);
            this._blood.bloodNum = WorldBossManager.Instance.bossInfo.current_Blood;
         }
         else
         {
            this._blood = new BossBloodItem(this._living.maxBlood);
            this.__updateBlood(null);
         }
         addChild(this._blood);
         p = ComponentFactory.Instance.creatCustomObject("room.bossThumbnailHPPos");
         this._blood.x = p.x;
         this._blood.y = p.y;
         this._name = ComponentFactory.Instance.creatComponentByStylename("asset.game.bossThumbnailNameTxt");
         addChild(this._name);
         this._name.text = this._living.name;
         this.autoBossNameText();
      }
      
      private function autoBossNameText() : void
      {
         if(this._name.length >= 12)
         {
            this._name.text = this._name.text.substring(0,12) + "...";
         }
      }
      
      public function initEvents() : void
      {
         if(Boolean(this._living))
         {
            this._living.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.addEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      public function __updateBlood(evt:LivingEvent) : void
      {
         if(RoomManager.Instance.current.type != 14)
         {
            this._blood.bloodNum = this._living.blood;
         }
         if(this._living.blood <= 0)
         {
            if(Boolean(this._headFigure))
            {
               this._headFigure.gray();
            }
         }
      }
      
      public function __die(evt:LivingEvent) : void
      {
         if(Boolean(this._headFigure))
         {
            this._headFigure.gray();
         }
         if(Boolean(this._blood))
         {
            this._blood.visible = false;
         }
      }
      
      private function __shineChange(evt:LivingEvent) : void
      {
         var boss:SimpleBoss = this._living as SimpleBoss;
         if(Boolean(boss) && boss.isAttacking)
         {
         }
      }
      
      public function setUpLintingFilter() : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([1,0,0,0,25]);
         matrix = matrix.concat([0,1,0,0,25]);
         matrix = matrix.concat([0,0,1,0,25]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(matrix);
      }
      
      public function removeEvents() : void
      {
         if(Boolean(this._living))
         {
            this._living.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.removeEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      public function updateView() : void
      {
         if(!this._living)
         {
            this.visible = false;
         }
         else
         {
            if(Boolean(this._headFigure))
            {
               this._headFigure.dispose();
               this._headFigure = null;
            }
            if(Boolean(this._blood))
            {
               this._blood = null;
            }
            this.init();
         }
      }
      
      public function set info(value:Living) : void
      {
         if(!value)
         {
            this.removeEvents();
         }
         this._living = value;
         this.updateView();
      }
      
      public function get Id() : int
      {
         if(!this._living)
         {
            return -1;
         }
         return this._living.LivingID;
      }
      
      private function __showCutHp(e:WorldBossRoomEvent) : void
      {
         if(WorldBossManager.Instance.bossInfo.cutValue <= 0)
         {
            return;
         }
         if(Boolean(this._blood))
         {
            this._blood.updateBlood(WorldBossManager.Instance.bossInfo.current_Blood,WorldBossManager.Instance.bossInfo.total_Blood);
         }
         var numMC:WorldBossCutHpMC = new WorldBossCutHpMC(WorldBossManager.Instance.bossInfo.cutValue);
         PositionUtils.setPos(numMC,"fightBoss.numMC.pos");
         addChildAt(numMC,0);
      }
      
      private function offset(off:int = 30) : int
      {
         var i:int = int(Math.random() * 10);
         if(i % 2 == 0)
         {
            return -int(Math.random() * off);
         }
         return int(Math.random() * off);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._living = null;
         this._headFigure.dispose();
         this._headFigure = null;
         this._blood.dispose();
         this._blood = null;
         this._name.dispose();
         this._name = null;
         this.lightingFilter = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

