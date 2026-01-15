package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionPollInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortionPollItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _name:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _info:ConsortionPollInfo;
      
      private var _selected:Boolean;
      
      private var _index:int;
      
      public function ConsortionPollItem(index:int)
      {
         super();
         this._index = index;
         this.initView();
      }
      
      private function initView() : void
      {
         this._selected = false;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.bg");
         if(this._index % 2 == 0)
         {
            this._bg.setFrame(1);
         }
         else
         {
            this._bg.setFrame(2);
         }
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.selected");
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.name");
         this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.pollItem.count");
         addChild(this._bg);
         addChild(this._selectedBtn);
         this._selectedBtn.addChild(this._name);
         addChild(this._count);
      }
      
      override public function get height() : Number
      {
         if(this._bg == null)
         {
            return 0;
         }
         return this._bg.y + this._bg.displayHeight;
      }
      
      public function set info(value:ConsortionPollInfo) : void
      {
         this._info = value;
         this._name.text = this._info.pollName;
         this._count.text = String(this._info.pollCount);
      }
      
      public function get info() : ConsortionPollInfo
      {
         return this._info;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      private function __selectHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.selected = this._selected == true ? false : true;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._bg.visible = true;
            this._bg.setFrame(1);
         }
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._bg.visible = false;
            this._bg.setFrame(1);
         }
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this._selectedBtn.selected = value;
      }
      
      public function get selected() : Boolean
      {
         return this._selectedBtn.selected;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._selectedBtn = null;
         this._name = null;
         this._count = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

