package bagAndInfo.bag.ring
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class RingSystemSkillTips extends Sprite implements ITransformableTip, Disposeable
   {
       
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _name:FilterFrameText;
      
      protected var _contentTxt:FilterFrameText;
      
      private var _line:Image;
      
      private var _nextLevel:FilterFrameText;
      
      private var _limitLevel:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function RingSystemSkillTips()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         addChild(this._bg);
         this._bg.width = 300;
         this._bg.height = 140;
         this._name = ComponentFactory.Instance.creatComponentByStylename("ringSystem.skill.nameText");
         addChild(this._name);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("ringSystem.skill.contentText");
         addChild(this._contentTxt);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         PositionUtils.setPos(this._line,"ringSystem.skill.linePos");
         addChild(this._line);
         this._nextLevel = ComponentFactory.Instance.creatComponentByStylename("ringSystem.skill.nextContentText");
         addChild(this._nextLevel);
         this._limitLevel = ComponentFactory.Instance.creatComponentByStylename("ringSystem.skill.limitLevel");
         addChild(this._limitLevel);
      }
      
      public function set tipData(param1:Object) : void
      {
         if(param1 != null)
         {
            this._name.text = param1.name;
            this._contentTxt.text = param1.content;
            this._nextLevel.text = param1.nextLevel;
            this._limitLevel.text = param1.limitLevel;
         }
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return this._bg.height;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._contentTxt)
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
         }
         this._line = null;
         if(this._nextLevel)
         {
            ObjectUtils.disposeObject(this._nextLevel);
         }
         this._nextLevel = null;
         if(this._limitLevel)
         {
            ObjectUtils.disposeObject(this._limitLevel);
         }
         this._limitLevel = null;
         this._data = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
