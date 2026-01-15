package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameManager;
   
   public class SmallPlayerTip extends BaseTip implements ITip
   {
      
      private static var _instance:SmallPlayerTip;
      
      private var _bg:ScaleBitmapImage;
      
      private var _lv:Bitmap;
      
      private var _winRate:WinRate;
      
      private var _battle:Battle;
      
      private var _tipContainer:Sprite;
      
      private var _nameField:FilterFrameText;
      
      private var _level:int;
      
      private var _reputeCount:int;
      
      private var _win:int;
      
      private var _total:int;
      
      private var _enableTip:Boolean;
      
      private var _tip:Sprite;
      
      private var _tipInfo:Object;
      
      private var _battleNum:int;
      
      private var _exploitValue:int;
      
      private var _bgH:int;
      
      public function SmallPlayerTip()
      {
         if(!_instance)
         {
            super();
            _instance = this;
         }
      }
      
      public static function get instance() : SmallPlayerTip
      {
         if(!instance)
         {
            _instance = new SmallPlayerTip();
         }
         return _instance;
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._tipbackgound = this._bg;
         this._lv = ComponentFactory.Instance.creatBitmap("asset.core.leveltip.LevelTipLv");
         this._lv.x = 4;
         this._lv.y = 28;
         this.createLevelTip();
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("game.smallplayer.NameField");
         addChild(this._nameField);
         addChild(this._lv);
         addChild(this._tipContainer);
         this.updateWH();
      }
      
      public function get txtPos() : Point
      {
         var ret:Point = new Point();
         if(Boolean(this._lv))
         {
            ret.x = this._lv.x + this._lv.width + 3;
            ret.y = this._lv.y + 4;
         }
         return ret;
      }
      
      override public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is LevelTipInfo)
         {
            this.visible = true;
            this.makeTip(data);
         }
         else
         {
            this.visible = false;
         }
         this._tipInfo = data;
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function createLevelTip() : void
      {
         this._tipContainer = new Sprite();
         this._winRate = new WinRate(this._win,this._total);
         this._battle = new Battle(this._battleNum);
         this._winRate.y = 52;
         this._battle.y = 77;
         this._battle.x = 10;
         this._winRate.x = 10;
         this._tipContainer.addChild(this._winRate);
         this._tipContainer.addChild(this._battle);
      }
      
      private function makeTip(obj:Object) : void
      {
         if(Boolean(obj))
         {
            this.resetLevelTip(obj.Level,obj.Repute,obj.Win,obj.Total,obj.Battle,obj.exploit,obj.enableTip,obj.team,obj.nickName);
         }
      }
      
      private function resetLevelTip(lv:int, repute:int, win:int, total:int, battle:int, exploit:int, enableTip:Boolean = true, team:int = 1, name:String = "") : void
      {
         this._level = lv;
         this._reputeCount = repute;
         this._win = win;
         this._total = total;
         this._exploitValue = exploit;
         this._enableTip = enableTip;
         this._nameField.text = name;
         this.visible = this._enableTip;
         if(!this._enableTip)
         {
            return;
         }
         this.setRepute(this._level,this._reputeCount);
         this.setRate(win,total);
         this.setBattle(battle);
         this.setExploit(this._exploitValue);
         if(this._bgH == 0)
         {
            this._bgH = this._bg.height;
         }
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this._battle.visible = false;
               this._bg.height = this._bgH - 20 - 20;
            }
            else
            {
               this._battle.visible = true;
               this._bg.height = this._bgH - 20;
            }
         }
         else
         {
            this._battle.visible = true;
            this._bg.height = this._bgH - 20;
         }
         this.updateTip();
      }
      
      private function setRepute(level:int, reputeCount:int) : void
      {
      }
      
      private function setRate($win:int, $total:int) : void
      {
         this._winRate.setRate($win,$total);
      }
      
      private function setBattle(num:int) : void
      {
         this._battle.BattleNum = num;
      }
      
      private function setExploit(value:int) : void
      {
      }
      
      private function updateTip() : void
      {
         if(Boolean(this._tip))
         {
            this.removeChild(this._tip);
         }
         this._tip = new Sprite();
         LevelPicCreater.creatLevelPicInContainer(this._tip,this._level,int(this.txtPos.x),int(this.txtPos.y));
         addChild(this._tip);
         this._bg.width = this._tipContainer.width + 15;
         this.updateWH();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._tip))
         {
            if(Boolean(this._tip.parent))
            {
               this._tip.parent.removeChild(this._tip);
            }
         }
         this._tip = null;
         if(Boolean(this._tipContainer))
         {
            if(Boolean(this._tipContainer.parent))
            {
               this._tipContainer.parent.removeChild(this._tipContainer);
            }
         }
         this._tipContainer = null;
         ObjectUtils.disposeObject(this._winRate);
         this._winRate = null;
         ObjectUtils.disposeObject(this._battle);
         this._battle = null;
         if(Boolean(this._lv))
         {
            ObjectUtils.disposeObject(this._lv);
         }
         this._lv = null;
         ObjectUtils.disposeObject(this);
         _instance = null;
         super.dispose();
      }
   }
}

