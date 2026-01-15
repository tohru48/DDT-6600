package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.FightBuffInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class PayBuffListItem extends Sprite implements Disposeable
   {
      
      private var _icon:DisplayObject;
      
      private var _labelField:FilterFrameText;
      
      private var _timeField:FilterFrameText;
      
      private var _w:int;
      
      private var _h:int;
      
      private var _countField:FilterFrameText;
      
      private var levelDic:Dictionary = new Dictionary();
      
      public function PayBuffListItem(buff:*)
      {
         super();
         this.initLevelDic();
         var bitmapLink:String = "";
         if(buff is BuffInfo)
         {
            bitmapLink = "asset.core.payBuffAsset" + buff.Type;
         }
         else if(buff is FightBuffInfo)
         {
            bitmapLink = "asset.game.buff" + buff.displayid;
         }
         this._icon = addChild(ComponentFactory.Instance.creatBitmap(bitmapLink));
         var size:Point = ComponentFactory.Instance.creatCustomObject("asset.core.PayBuffIconSize");
         this._icon.width = size.x;
         this._icon.height = size.y;
         this._labelField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipLabel");
         this._labelField.text = buff.buffName;
         addChild(this._labelField);
         if(buff is BuffInfo)
         {
            this._countField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipCount");
            if(buff.maxCount > 0 && Boolean(buff.isSelf))
            {
               this._countField.text = buff.ValidCount + "/" + buff.maxCount;
            }
            addChild(this._countField);
            this._timeField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipTime");
            this._timeField.text = LanguageMgr.GetTranslation("tank.view.buff.VipLevelFree",this.levelDic[buff.Type]);
            addChild(this._timeField);
            this._w = this._timeField.x + this._timeField.width;
         }
         else
         {
            this._timeField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipTime");
            this._timeField.text = FightBuffInfo(buff).description;
            addChild(this._timeField);
            this._timeField.x = this._labelField.x + this._labelField.textWidth + 15;
            this._w = this._timeField.x + this._timeField.width;
         }
         this._h = this._icon.height;
      }
      
      private function initLevelDic() : void
      {
         this.levelDic[BuffInfo.Agility] = "7";
         this.levelDic[BuffInfo.Save_Life] = "4";
         this.levelDic[BuffInfo.ReHealth] = "6";
         this.levelDic[BuffInfo.Train_Good] = "8";
         this.levelDic[BuffInfo.Level_Try] = "3";
         this.levelDic[BuffInfo.Card_Get] = "5";
         this.levelDic[BuffInfo.Caddy_Good] = "9";
      }
      
      override public function get width() : Number
      {
         return this._w;
      }
      
      override public function get height() : Number
      {
         return this._h;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._labelField);
         this._labelField = null;
         ObjectUtils.disposeObject(this._timeField);
         this._timeField = null;
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

