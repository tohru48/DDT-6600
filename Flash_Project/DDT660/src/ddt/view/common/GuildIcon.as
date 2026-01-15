package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.GuildIconTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class GuildIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const BIG:String = "big";
      
      public static const SMALL:String = "small";
      
      private var _icon:ScaleFrameImage;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:GuildIconTipInfo;
      
      private var _cid:int;
      
      private var _level:int;
      
      private var _repute:int;
      
      public function GuildIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatComponentByStylename("asset.core.guildIcon");
         addChild(this._icon);
         this._icon.setFrame(1);
         this._tipStyle = "core.guildIconTip";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6";
         ShowTipManager.Instance.addTip(this);
         this._tipData = new GuildIconTipInfo();
      }
      
      public function setInfo(level:int, cid:int, repute:int) : void
      {
         this._cid = cid;
         this._level = level;
         this._repute = repute;
         var st:int = PlayerManager.Instance.Self.ConsortiaID > 0 ? (cid == PlayerManager.Instance.Self.ConsortiaID ? GuildIconTipInfo.MEMBER : GuildIconTipInfo.ENEMY) : GuildIconTipInfo.NEUTRAL;
         this._icon.setFrame(st == GuildIconTipInfo.ENEMY ? 2 : 1);
         this._tipData.Level = level;
         this._tipData.State = st;
         this._tipData.Repute = repute;
      }
      
      public function set showTip(value:Boolean) : void
      {
         if(value)
         {
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            ShowTipManager.Instance.removeTip(this);
         }
      }
      
      public function set size(value:String) : void
      {
         if(value == BIG)
         {
            this._icon.scaleX = this._icon.scaleY = 1;
         }
         else
         {
            this._icon.scaleX = this._icon.scaleY = 0.8;
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         var st:int = PlayerManager.Instance.Self.ConsortiaID > 0 ? (this._cid == PlayerManager.Instance.Self.ConsortiaID ? GuildIconTipInfo.MEMBER : GuildIconTipInfo.ENEMY) : GuildIconTipInfo.NEUTRAL;
         this._icon.setFrame(st == GuildIconTipInfo.ENEMY ? 2 : 1);
         this._tipData.Level = this._level;
         this._tipData.State = st;
         this._tipData.Repute = this._repute;
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value as GuildIconTipInfo;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this._icon.dispose();
         this._icon = null;
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

